local root = class_base:extend()

local root_piece = class_base:extend()

function root_piece:new(start_point,end_point)
    self.start_pos = start_point
    self.end_pos = end_point
    self.is_end = false

    self.childs = {}
end

function root_piece:draw()
    love.graphics.line(self.start_pos.x,self.start_pos.y,self.end_pos.x,self.end_pos.y)
end

function root_piece:set_end(is_end)
    self.is_end = is_end
end



function root:new(start_point,end_point)
    self.parts ={}
    self._parent = nil

    self:insert(start_point,end_point)
end


function root:draw()
    for _,part in pairs(self.parts) do
        part:draw()
    end
end

function root:append(end_point)
    self:insert(self.parts[#self.parts].end_pos:copy(),end_point )
end

function root:insert(start_point,end_point)
    print("appending")
    print("end:",end_point.x,end_point.y)
    print("start:", start_point.x,start_point.y)

    table.insert(self.parts,
    root_piece(start_point,end_point) )
end

return root