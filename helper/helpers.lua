
local helpers ={}

function  helpers.lerp(x,y,t) local num = x+t*(y-x)return num end


function helpers.lerp_2d_(x1,y1,x2,y2,t)
  local x = lerp_(x1,x2,t)
  local y = lerp_(y1,y2,t)
  --print(x.." "..y)
  return x,y
end


function helpers.lerp_2d(p1, p2, t)
    local x = helpers.lerp(p1.x, p2.x, t)
    local y = helpers.lerp(p1.y, p2.y, t)
    return g.lib.base_type.pos(x,y)
end

function helpers.clear_color()
    love.graphics.setColor(255,255,255,255)
end

return helpers