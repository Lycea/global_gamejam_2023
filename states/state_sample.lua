
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


local function draw_selected(pos,size)
    love.graphics.setColor(255,255,0)
    love.graphics.circle("line", pos.x,pos.y, size)
    helpers.clear_color()
end

local function draw_puddle(puddle, offsets)
    if puddle.selected then
        draw_selected(helpers.to_glob( puddle.pos, puddle.idx.x,puddle.idx.y), puddle.size +3)
    end

    love.graphics.setColor(20,235,247)
    
    love.graphics.circle("fill",
                            puddle.pos.x + offsets.x,
                            puddle.pos.y + offsets.y,
                            puddle.size)
    helpers.clear_color()
end

local function draw_cave(cave, offsets)


    love.graphics.setColor(0,0,15)
    
    love.graphics.circle("fill",
                            cave.pos.x + offsets.x,
                            cave.pos.y + offsets.y,
                            cave.size)

    if cave.selected  then
        draw_selected(helpers.to_glob( cave.interact, cave.idx.x,cave.idx.y), 10 +3) 
    end
    helpers.clear_color()
end


local function grid()
    local viewable_grids ={"0:0","1:0","-1:0"}
    --grid debug
    

    for idx, grid_key in pairs(viewable_grids) do
        --print("debug print keys")
        --for key,val in pairs( g.vars.full_grid) do
        --    print(key)
        --end

        local draw_grid =g.vars.full_grid[grid_key]

        love.graphics.setColor(0,0,0)
        local offset ={
            x = base_offset.x + draw_grid.idx.x*grid_size.w,
            y = base_offset.y + draw_grid.idx.y*grid_size.h
        }

        love.graphics.rectangle("line",
                                offset.x,
                                offset.y,
                                grid_size.w,grid_size.h)

        for _,puddle in pairs(draw_grid.objects.puddles) do
            draw_puddle(puddle, offset)
        end

        if draw_grid.objects.cave then
            draw_cave(draw_grid.objects.cave,offset)
        end
    end
    

end


function in_root:draw()
    background()

    g.var("main_root"):draw()

    grid()
end


function in_root:update()
    local viewable_grids ={"0:0","1:0","-1:0"}

    --print(love.mouse.isDown(1))
    if love.mouse.isDown(1) and g.vars.click_timer:check() then
        local m_pos_x,m_pos_y = love.mouse.getPosition()
       --print("adding")
       local pos = g.libs.types.pos(m_pos_x,m_pos_y)
       --print(pos.x,pos.y)
       g.var("main_root"):append(pos)

    end

    if mouse_moved==true and g.vars.cur_selection== nil then
        
        print("check which is selected")
        print(mouse_moved, g.vars.cur_selection)
        local found_hit = false
        for _,grid_id in pairs(viewable_grids) do
            local grid = g.vars.full_grid[grid_id]

            for _ ,puddle in pairs(grid.objects.puddles) do
                if helpers.to_glob( puddle.pos,grid.idx.x,grid.idx.y ):distance_to(mouse_coords) <= puddle.size then
                    puddle.selected = true
                
                    found_hit = true

                    g.vars.cur_selection = puddle
                    break
                end
            end
            
            if grid.objects.cave and found_hit == false then
                local cave = grid.objects.cave
                if helpers.to_glob( cave.interact,grid.idx.x,grid.idx.y ):distance_to(mouse_coords) <= 10 then
                    cave.selected = true
                    found_hit = true
                    g.vars.cur_selection = cave
                    break
                end
            end

            if found_hit then
                break
            end
        end
    elseif mouse_moved then
        print("check if still selected")
        local obj_coord = nil
        local obj_dist = nil

        local cur_selection = g.vars.cur_selection
        if cur_selection:is(g.libs.generator.cave) then
            obj_coord = cur_selection.interact
            obj_dist =  10
        elseif cur_selection:is(g.libs.generator.puddle) then
            obj_coord = cur_selection.pos
            obj_dist = cur_selection.size
        end

        if helpers.to_glob( obj_coord ,cur_selection.idx.x,cur_selection.idx.y ):distance_to(mouse_coords) > obj_dist +3 then
            cur_selection.selected = false
            g.vars.cur_selection   = nil
        end
    end 
end

function in_root:shutdown()
    
end





return in_root()