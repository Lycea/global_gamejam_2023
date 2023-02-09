local root = class_base:extend()

local root_piece = class_base:extend()

function root_piece:new(start_point,end_point,parent)
    self.start_pos = start_point
    self.end_pos = end_point

    self.length = self.start_pos:distance_to(self.end_pos)
    self.is_end = false

    self.parent = parent

    self.childs = {}
end

function root_piece:draw()
    love.graphics.line(self.start_pos.x,self.start_pos.y,self.end_pos.x,self.end_pos.y)

    love.graphics.push()
    
    local w = 10
    local h = self.start_pos:distance_to(self.end_pos)

    --love.graphics.rectangle("fill", self.start_pos.x, self.start_pos.y, w,h) -- move relative (0,0) to (x,y)
    local mid_point = helpers.lerp_2d(self.start_pos,self.end_pos,0.5)
        

    love.graphics.translate(mid_point.x , mid_point.y)
    --love.graphics.translate(self.start_pos.x , self.start_pos.y)
    
    love.graphics.rotate(  self.start_pos:angle(self.end_pos) ) -- rotate coordinate system around relative (0,0) (absolute (x,y))
    love.graphics.rectangle("fill", -h/2, -w/2, h, w) 
    love.graphics.pop()

    love.graphics.circle("fill",self.end_pos.x,self.end_pos.y, w/2)
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

function root:append(end_point,parent)
    self:insert(self.parts[#self.parts].end_pos:copy(),end_point ,parent )
end

function root:insert(start_point,end_point,parent)
    print("appending")
    print("end:",end_point.x,end_point.y)
    print("start:", start_point.x,start_point.y)

    table.insert(self.parts,
    root_piece(start_point,end_point,parent) )

    self.parts[#self.parts]:set_end()
end

return root