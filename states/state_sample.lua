
local in_root =class_base:extend()

local grid_size   = nil
local base_offset = nil

function in_root:new()
    print("initialised!!")

end


function in_root:startup()
    grid_size = g.lib("generator").grid_size
    
    base_offset={
        x= scr_w/2 -grid_size.w/2,
        y= 160 
    }


    g.vars.main_root = g.lib("Root")(g.libs.types.pos(scr_w/2,150), g.libs.types.pos(scr_w/2, 155))
    g.vars.click_timer = timer(0.1)

    g.libs.generator:new_grid()
end




local function background()
    --sky base
    love.graphics.setColor(86, 194, 240)
    love.graphics.rectangle("fill",0,0,scr_w,150)
    --grass layer
    love.graphics.setColor(0, 194, 0)
    love.graphics.rectangle("fill",0,150,scr_w,10)
    --earth ~
    love.graphics.setColor(112, 72, 33)
    love.graphics.rectangle("fill",0,160,scr_w,scr_h-160)

    helpers.clear_color()
end


local function draw_puddle(puddle, offsets)
    love.graphics.setColor(20,235,247)
    love.graphics.circle("fill",
                            puddle.pos.x + offsets.x,
                            puddle.pos.y + offsets.y,
                            puddle.size)
    helpers.clear_color()
end

local function draw_cave(cave, offsets)

end


local function grid()
    local viewable_grids ={"0:0","1:0","-1:0"}
    --grid debug
    

    for idx, grid_key in pairs(viewable_grids) do
        print("debug print keys")
        for key,val in pairs( g.vars.full_grid) do
            print(key)
        end

        local draw_grid =g.vars.full_grid[grid_key]

        love.graphics.setColor(0,0,0)
        local offset ={
            x = base_offset.x + draw_grid.idx.x*grid_size.w,
            y = base_offset.y + draw_grid.idx.y*grid_size.h
        }

        love.graphics.rectangle("line",
                                base_offset.x + draw_grid.idx.x*grid_size.w,
                                base_offset.y + draw_grid.idx.y*grid_size.h,
                                grid_size.w,grid_size.h)

        for _,puddle in pairs(draw_grid.objects.puddles) do
            draw_puddle(puddle, offset)
        end

    end
    

end


function in_root:draw()
    background()

    g.var("main_root"):draw()

    grid()
end



function in_root:update()
    print(love.mouse.isDown(1))
    if love.mouse.isDown(1) and g.vars.click_timer:check() then
       local m_pos_x,m_pos_y = love.mouse.getPosition()
       print("adding")
       local pos = g.libs.types.pos(m_pos_x,m_pos_y)
       print(pos.x,pos.y)
       g.var("main_root"):append(pos)
    end
end

function in_root:shutdown()
    
end





return in_root()