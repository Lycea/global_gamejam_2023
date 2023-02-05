
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

function helpers.to_glob(loc_pos,grid_x,grid_y)
  grid_size = g.lib("generator").grid_size
    
  base_offset={
      x= scr_w/2 -grid_size.w/2,
      y= 160 
  }

  return g.libs.types.pos(
    base_offset.x + grid_x*grid_size.w  +loc_pos.x,
    base_offset.y + grid_y*grid_size.h  +loc_pos.y)
end

return helpers