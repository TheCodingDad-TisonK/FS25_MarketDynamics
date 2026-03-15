--- A Jump Point Search
---@class JumpPointSearch : AStar, HybridAStar.MotionPrimitives
JumpPointSearch = CpObject(AStar)
JumpPointSearch.markers = {}

function JumpPointSearch:init(vehicle, yieldAfter, maxIterations)
    AStar.init(self, vehicle, yieldAfter, maxIterations)
    self.name = "JumpPointSearch"
end

function JumpPointSearch:initRun(start, goal, turnRadius, allowReverse, constraints, hitchLength)
    self.logger:setLevel(Logger.level.debug)
    return AStar.initRun(self, start, goal, turnRadius, allowReverse, constraints, hitchLength)
end

--- The motion primitives in JPS use so many attributes of the pathfinder class itself, that we just implement
--- the motion primitive interface in the pathfinder
function JumpPointSearch:getMotionPrimitives(turnRadius, allowReverse)
    self:initMotionPrimitives()
    return self
end

function JumpPointSearch:initMotionPrimitives()
    -- similar to the A*, the possible motion primitives (the neighbors) are in all 8 directions.
    self.primitives = {}
    self.gridSize = self.deltaPos
    local d = self.gridSize
    table.insert(self.primitives, Vector(d, 0))
    table.insert(self.primitives, Vector(d, d))
    table.insert(self.primitives, Vector(0, d))
    table.insert(self.primitives, Vector(-d, d))

    table.insert(self.primitives, Vector(-d, 0))
    table.insert(self.primitives, Vector(-d, -d))
    table.insert(self.primitives, Vector(0, -d))
    table.insert(self.primitives, Vector(d, -d))

    -- set up the pruning rules for each primitive, that is, if we used this primitive to move to the
    -- next node, which neighbors of that node should be examined further.
    -- always unconditionally include natural neighbors (check = nil)
    -- create forced neighbors when the grid identified by the check vector is invalid

    -- right
    self.primitives[1].nextPrimitives = {
        { check = nil, nextPrimitive = self.primitives[1] },
        { check = Vector(0, self.gridSize), nextPrimitive = self.primitives[2] },
        { check = Vector(0, -self.gridSize), nextPrimitive = self.primitives[8] }
    }
    -- left
    self.primitives[5].nextPrimitives = {
        { check = nil, nextPrimitive = self.primitives[5] },
        { check = Vector(0, self.gridSize), nextPrimitive = self.primitives[4] },
        { check = Vector(0, -self.gridSize), nextPrimitive = self.primitives[6] }
    }

    -- up
    self.primitives[3].nextPrimitives = {
        { check = nil, nextPrimitive = self.primitives[3] },
        { check = Vector(self.gridSize, 0), nextPrimitive = self.primitives[2] },
        { check = Vector(-self.gridSize, 0), nextPrimitive = self.primitives[4] }
    }

    -- down
    self.primitives[7].nextPrimitives = {
        { check = nil, nextPrimitive = self.primitives[7] },
        { check = Vector(self.gridSize, 0), nextPrimitive = self.primitives[8] },
        { check = Vector(-self.gridSize, 0), nextPrimitive = self.primitives[6] }
    }

    -- up right
    self.primitives[2].nextPrimitives = {
        { check = nil, nextPrimitive = self.primitives[2] },
        { check = nil, nextPrimitive = self.primitives[1] },
        { check = nil, nextPrimitive = self.primitives[3] },
        { check = Vector(-self.gridSize, 0), nextPrimitive = self.primitives[4] },
        { check = Vector(0, -self.gridSize), nextPrimitive = self.primitives[8] },
    }

    -- up left
    self.primitives[4].nextPrimitives = {
        { check = nil, nextPrimitive = self.primitives[4] },
        { check = nil, nextPrimitive = self.primitives[3] },
        { check = nil, nextPrimitive = self.primitives[5] },
        { check = Vector(self.gridSize, 0), nextPrimitive = self.primitives[2] },
        { check = Vector(0, -self.gridSize), nextPrimitive = self.primitives[6] },
    }

    -- down left
    self.primitives[6].nextPrimitives = {
        { check = nil, nextPrimitive = self.primitives[6] },
        { check = nil, nextPrimitive = self.primitives[5] },
        { check = nil, nextPrimitive = self.primitives[7] },
        { check = Vector(self.gridSize, 0), nextPrimitive = self.primitives[8] },
        { check = Vector(0, self.gridSize), nextPrimitive = self.primitives[4] },
    }

    -- down right
    self.primitives[8].nextPrimitives = {
        { check = nil, nextPrimitive = self.primitives[8] },
        { check = nil, nextPrimitive = self.primitives[1] },
        { check = nil, nextPrimitive = self.primitives[7] },
        { check = Vector(-self.gridSize, 0), nextPrimitive = self.primitives[6] },
        { check = Vector(0, self.gridSize), nextPrimitive = self.primitives[2] },
    }

    for i = 1, #self.primitives do
        -- if we moved to the current node using primitive[i], then the primitive we would need to go back to
        -- the parent is primitive[i].parent
        self.primitives[i].parent = self.primitives[i + 4] or self.primitives[i - 4]
        -- cache the length
        self.primitives[i].d = self.primitives[i]:length()
    end
end

function JumpPointSearch:isValidNode(node)
    return self.constraints:isValidNode(node, true, true)
end

function JumpPointSearch:isPenaltyChanging(node, predecessor)
    local predecessorPenalty = self.penaltyCache:get(predecessor, self.constraints)
    local nodePenalty = self.penaltyCache:get(node, self.constraints)
    local change = (nodePenalty + 0.0001) / (predecessorPenalty + 0.0001) -- avoid problems if either is zero
    if change > 3 then
        -- penalty increasing, force a neighbor here
        return true
    elseif change < 0 then
        -- penalty decreasing, force a neighbor here
        -- this is currently disabled, as it is not clear if this is a good idea. If we enable this, it results
        -- in the scan reentering the non-penalty area and scanning it again from a different direction.
        return true
    end
end

---@param node State3D
---@param primitive
---@return table array of primitives pointing to natural and forced neighbors
---@return boolean true if there is at least one forced neighbor
function JumpPointSearch:getNextPrimitives(node, primitive)
    local nextPrimitives, forced = {}, false
    for _, n in ipairs(primitive.nextPrimitives) do
        if n.check then
            -- check if the neighbor is valid
            local neighborToCheck = State3D(node.x + n.check.x, node.y + n.check.y, n.check:heading())
            if not self:isValidNode(neighborToCheck) or self:isPenaltyChanging(neighborToCheck, node) then
                -- we have a forced neighbor
                table.insert(nextPrimitives, n.nextPrimitive)
                forced = true
            end
        else
            table.insert(nextPrimitives, n.nextPrimitive)
        end
    end
    return nextPrimitives, forced
end


function JumpPointSearch:jump(node, primitive, recursionCounter)
    recursionCounter = recursionCounter and recursionCounter + 1 or 1
    if recursionCounter > 5 then
        return node
    end
    local v = node + primitive
    local successor = State3D(v.x, v.y, primitive:heading())
    if not self:isValidNode(successor) then
        return nil
    end
    if self:isPenaltyChanging(successor, node) then
        return successor
    end
    if successor:equals(self.goal, self.deltaPosGoal, self.deltaThetaGoal) then
        return successor
    end

    local _, forced = self:getNextPrimitives(successor, primitive)
    if forced then
        return successor
    end

    if primitive.x ~= 0 and primitive.y ~= 0 then
        -- diagonal move, must check first horizontally and vertically
        -- left or right
        local jumpPoint = self:jump(successor, primitive.x > 0 and self.primitives[1] or self.primitives[5])
        if jumpPoint then
            return successor
        else
            -- up or down
            jumpPoint = self:jump(successor, primitive.y > 0 and self.primitives[3] or self.primitives[7])
            if jumpPoint then
                return successor
            end
        end
    end

    return self:jump(successor, primitive, recursionCounter)
end

-- Get the possible neighbors when coming from the predecessor node.
-- While the other HybridAStar derived algorithms use a real motion primitive, meaning it gives the relative
-- x, y and theta values which need to be added to the predecessor, JPS supplies the actual coordinates of
-- the successors here instead.
-- This is not the most elegant solution and the only reason we do this is to be able to reuse the
-- getPrimitives()/createSuccessor() interface in HybridAStar.lua with JPS.
function JumpPointSearch:getPrimitives(node)
    local primitives
    if node.primitive then
        -- the primitive that was used to get to this node
        primitives = self:getNextPrimitives(node, node.primitive)
    else
        -- first node, no predecessor, no incoming primitive
        primitives = self.primitives
    end
    local jumpNodes = {}
    for _, p in ipairs(primitives) do
        local jumpNode = self:jump(node, p)
        if jumpNode then
            -- here we have the node already, so the usual createSuccessor() does not need to calculate it again
            -- from the primitive. However, HybridAStar uses primitive.d to calculate the g cost, so we use an
            -- ugly hack here, by creating a fake primitive, setting the d value to the proper length, and
            -- add the jump node as .node to the primitive.
            table.insert(jumpNodes, {
                node = State3D(jumpNode.x, jumpNode.y, jumpNode.t, node.g, node, Gear.Forward, Steer.Straight, nil, node.d, p),
                d = (jumpNode - node):length() })
        end
    end
    return jumpNodes
end

-- Use the hacky combined nodeAndPrimitive to return the successor node
function JumpPointSearch:createSuccessor(node, nodeAndPrimitive, hitchLength)
    nodeAndPrimitive.node.tTrailer = node:getNextTrailerHeading(self.gridSize, hitchLength)
    nodeAndPrimitive.node.d = node.d + nodeAndPrimitive.d
    return nodeAndPrimitive.node
end

---@class HybridAStarWithJpsInTheMiddle : HybridAStarWithAStarInTheMiddle
HybridAStarWithJpsInTheMiddle = CpObject(HybridAStarWithAStarInTheMiddle)

function HybridAStarWithJpsInTheMiddle:getFastPathfinder()
    return JumpPointSearch(self.vehicle, self.yieldAfter, self.maxIterations)
end

