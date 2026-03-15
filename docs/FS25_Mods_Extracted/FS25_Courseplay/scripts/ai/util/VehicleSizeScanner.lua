--[[
This file is part of Courseplay (https://github.com/Courseplay)
Copyright (C) 2025 Courseplay Dev Team

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

--- A utility to scan the actual vehicle size using overlap boxes.
VehicleSizeScanner = CpObject()

function VehicleSizeScanner:init()
    self.logger = Logger('VehicleSizeScanner', Logger.level.debug, CpDebug.DBG_IMPLEMENTS)
end

--- Scan the size of the given vehicle, using the given reference node (or the root node if nil).
--- This function uses overlap boxes moved towards the vehicle from all four directions to find the extents
--- by detecting collisions between the box and the vehicle.
---@param vehicle Vehicle
---@param referenceNode number|nil
---@return number front distance of the frontmost point from the reference node
---@return number rear distance of the rearmost point from the reference node
---@return number left distance of the leftmost point from the reference node
---@return number right distance of the rightmost point from the reference node
function VehicleSizeScanner:scan(vehicle, referenceNode)
    self.left = self:_measureDimension(vehicle, referenceNode, 50, 0.1, 'x')
    self.right = self:_measureDimension(vehicle, referenceNode, -50, -0.1, 'x')
    self.front = self:_measureDimension(vehicle, referenceNode, 50, 0.1, 'z')
    self.rear = self:_measureDimension(vehicle, referenceNode, -50, -0.1, 'z')
    self.logger:debug(vehicle, 'Front: %.1f Rear: %.1f Left: %.1f Right: %.1f ',
            self.front, self.rear, self.left, self.right)
    return self.front, self.rear, self.left, self.right
end

function VehicleSizeScanner:getLength()
    -- front is positive z, rear is negative z
    return self.front - self.rear
end

function VehicleSizeScanner:getWidth()
    -- left is positive x, right is negative x
    return self.left - self.right
end

function VehicleSizeScanner:_measureDimension(vehicle, referenceNode, startDistance, endDistance, axis)
    local step = endDistance > startDistance and 0.1 or -0.1
    local boxHalfSize = 25
    local obX, obY, obZ, getLocalPosition
    if axis == 'x' then
        getLocalPosition = function(node, d)
            return localToWorld(node, d, 0, 0)
        end
        -- a rectangle (thin box) in the y-z plane, moving along the x axis
        obX, obY, obZ = 0.1, 10, boxHalfSize
    elseif axis == 'y' then
        getLocalPosition = function(node, d)
            return localToWorld(node, 0, d, 0)
        end
        -- a rectangle (thin box) in the x-z plane, moving along the y axis
        obX, obY, obZ = boxHalfSize, 0.1, boxHalfSize
    elseif axis == 'z' then
        getLocalPosition = function(node, d)
            return localToWorld(node, 0, 0, d)
        end
        -- a rectangle (thin box) in the x-y plane, moving along the z axis
        obX, obY, obZ = boxHalfSize, 10, 0.1
    end
    local dimension = 3
    local node = referenceNode or vehicle.rootNode
    local xRot, yRot, zRot = getWorldRotation(node)
    self.vehicleBeingScanned = vehicle
    self.scannedVehicleFound = false
    -- create an overlap box, very thin, like a plane and move it towards the vehicle until we find a collision
    for ix = startDistance, endDistance, step do
        local x, y, z = getLocalPosition(vehicle.rootNode, ix)
        overlapBox(x, y, z, xRot, yRot, zRot, obX, obY, obZ, "_overlapBoxCallback", self, CpUtil.getDefaultCollisionFlags(), true, true, true, true)
        if self.scannedVehicleFound then
            --PathfinderUtil.addOverlapBox(x, y, z, xRot, yRot, zRot, obX, obY, obZ)
            dimension = ix
            break
        end
    end
    return dimension
end

function VehicleSizeScanner:_overlapBoxCallback(transformId)
    local collidingObject = g_currentMission.nodeToObject[transformId]
    if collidingObject and self.vehicleBeingScanned == collidingObject then
        self.scannedVehicleFound = true
    end
end

