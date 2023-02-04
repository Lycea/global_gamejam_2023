local pos = class_base:extend()

function pos:new(x,y)
    self.x = x
    self.y = y
end


function pos:copy()
    return pos(self.x,self.y)
end

function pos:distance_to(pos)
    return ((self.x-pos.x)^2+(self.y-pos.y)^2)^0.5 
end

return {pos=pos}