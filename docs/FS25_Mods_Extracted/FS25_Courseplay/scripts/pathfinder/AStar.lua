--- A simple A star implementation based on the hybrid A star. The difference is that the state space isn't really
--- 3 dimensional as we do not take the heading into account and we use a different set of motion primitives which
--- puts us on the grid points.
---@class AStar : HybridAStar
AStar = CpObject(HybridAStar)

function AStar:init(vehicle, yieldAfter, maxIterations)
    HybridAStar.init(self, vehicle, yieldAfter, maxIterations)
    self.name = 'AStar'
    -- this needs to be small enough that no vehicle fit between the grid points (and remain undetected)
    self.deltaPos = 3
    self.deltaPosGoal = self.deltaPos
    self.deltaThetaDeg = 181
    self.deltaThetaGoal = math.rad(self.deltaThetaDeg)
    self.maxDeltaTheta = self.deltaThetaGoal
    self.originalDeltaThetaGoal = self.deltaThetaGoal
    self.analyticSolverEnabled = false
    self.ignoreValidityAtStart = false
end

function AStar:getMotionPrimitives(turnRadius, allowReverse)
    return AStar.SimpleMotionPrimitives(self.deltaPos, allowReverse)
end

--- A simple set of motion primitives to use with an A* algorithm, pointing to 8 directions
---@class AStar.SimpleMotionPrimitives : HybridAStar.MotionPrimitives
AStar.SimpleMotionPrimitives = CpObject(HybridAStar.MotionPrimitives)
---@param gridSize number search grid size in meters
function AStar.SimpleMotionPrimitives:init(gridSize, allowReverse)
    -- motion primitive table:
    self.primitives = {}
    self.gridSize = gridSize
    local d = gridSize
    local dSqrt2 = math.sqrt(2) * d
    table.insert(self.primitives, { dx = d, dy = 0, dt = 0, d = d, gear = Gear.Forward, steer = Steer.Straight})
    table.insert(self.primitives, { dx = d, dy = d, dt = 1 * math.pi / 4, d = dSqrt2, gear = Gear.Forward, steer = Steer.Straight})
    table.insert(self.primitives, { dx = 0, dy = d, dt = 2 * math.pi / 4, d = d, gear = Gear.Forward, steer = Steer.Straight})
    table.insert(self.primitives, { dx = -d, dy = d, dt = 3 * math.pi / 4, d = dSqrt2, gear = Gear.Forward, steer = Steer.Straight})
    table.insert(self.primitives, { dx = -d, dy = 0, dt = 4 * math.pi / 4, d = d, gear = Gear.Forward, steer = Steer.Straight})
    table.insert(self.primitives, { dx = -d, dy = -d, dt = 5 * math.pi / 4, d = dSqrt2, gear = Gear.Forward, steer = Steer.Straight})
    table.insert(self.primitives, { dx = 0, dy = -d, dt = 6 * math.pi / 4, d = d, gear = Gear.Forward, steer = Steer.Straight})
    table.insert(self.primitives, { dx = d, dy = -d, dt = 7 * math.pi / 4, d = dSqrt2, gear = Gear.Forward, steer = Steer.Straight})
end

--- A* successors are simply the grid neighbors
function AStar.SimpleMotionPrimitives:createSuccessor(node, primitive, hitchLength)
    local xSucc = node.x + primitive.dx
    local ySucc = node.y + primitive.dy
    local tSucc = primitive.dt
    return State3D(xSucc, ySucc, tSucc, node.g, node, primitive.gear, primitive.steer,
            node:getNextTrailerHeading(primitive.d, hitchLength), node.d + primitive.d)
end

---@param node State3D
function AStar:rollUpPath(node, goal, path)
    path = path or {}
    local currentNode = node
    self:debug('Goal node at %.2f/%.2f, cost %.1f (%.1f - %.1f)', goal.x, goal.y, node.cost,
            self.nodes.lowestCost, self.nodes.highestCost)
    table.insert(path, 1, currentNode)
    local nSkippedNodes = 0
    self.nPenaltyCalls = 0
    -- cache for penalties to make post smoothing faster, by calling getNodePenalty() only once per grid cell
    self.penalties = HybridAStar.NodeList(self.deltaPos, 360)
    while currentNode.pred do
        -- smoothing the path
        if currentNode.pred.pred then
            -- if the predecessor has a predecessor, then check if we can skip the predecessor and go directly
            -- to its parent. This will eliminate the zig-zag in the path when moving in a direction not aligned
            -- with the grid (or its diagonal)
            if self:isObstacleBetween(path[1], currentNode.pred.pred) then
                table.insert(path, 1, currentNode.pred)
            else
                nSkippedNodes = nSkippedNodes + 1
            end
        else
            table.insert(path, 1, currentNode.pred)
        end
        currentNode = currentNode.pred
    end
    self:debug('Nodes %d (skipped %d for smoothing), iterations %d, yields %d, penalty calls %d',
            #path, nSkippedNodes, self.iterations, self.yields, self.nPenaltyCalls)
    -- now that we straightened the path, we may end up with just 2 nodes, start and end, so let's add
    -- some in between
    return self:addIntermediatePoints(path)
end

---@param func function(x, y, ...) function to call for each point. If it returns anything
--- other than nil, the loop is stopped and the result is returned.
function AStar:runForImmediatePoints(n1, n2, func, ...)
    local x1, y1, x2, y2 = n1.x, n1.y, n2.x, n2.y
    local dx, dy = x2 - x1, y2 - y1
    local d = math.sqrt(dx * dx + dy * dy)
    local steps = math.floor(d / self.deltaPos)
    if steps >= 1 then
        local stepX, stepY = dx / steps, dy / steps
        for i = 1, steps do
            local x, y = x1 + i * stepX, y1 + i * stepY
            local result = func(x, y, ...)
            if result ~= nil then
                return result
            end
        end
    end
end

--- Very conservatively check, if we can make a shortcut between two nodes, to smooth (straighten) the raw A* path.
--- If there is any node penalty, we consider it an obstacle and thus won't skip this node
---@param n1 State3D
---@param n2 State3D
function AStar:isObstacleBetween(n1, n2)
    return self:runForImmediatePoints(n1, n2,
            function(x, y)
                local node = State3D(x, y, 0)
                local penalty
                local cachedPenalty = self.penalties:get(node)
                if cachedPenalty then
                    penalty = cachedPenalty.penalty
                else
                    self.nPenaltyCalls = self.nPenaltyCalls + 1
                    penalty = self.constraints:getNodePenalty(node)
                    node.penalty = penalty
                    self.penalties:add(node)
                end
                if penalty > 0 then
                    return true
                end
            end)
end

function AStar:addIntermediatePoints(path)
    local newPath = {}
    for i = 1, #path - 1 do
        local n1, n2 = path[i], path[i + 1]
        table.insert(newPath, n1)
        self:runForImmediatePoints(n1, n2,
                function(x, y)
                    table.insert(newPath, State3D(x, y, 0))
                end)
    end
    table.insert(newPath, path[#path])
    return newPath
end