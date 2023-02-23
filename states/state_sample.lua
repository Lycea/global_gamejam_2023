
local in_root =class_base:extend()

local grid_size   = nil
local base_offset = nil

local cam_offset = nil
local scr_mid = nil

local mid_angle = -1

local move_timer = timer(0.005)
visible_grids = nil
view_port = nil

function in_root:new()
    print("initialised!!")

end


function in_root:startup()
    grid_size = g.lib("generator").grid_size
    cam_offset =  g.libs.types.pos(0,0)
    scr_mid = g.libs.types.pos(scr_w/2,scr_h/2)

    base_offset={
        x= scr_w/2 -grid_size.w/2,
        y= 160 
    }

    g.vars.cam_offset = cam_offset
    g.vars.main_root = g.lib("Root")(g.libs.types.pos(scr_w/2,150), g.libs.types.pos(scr_w/2, 155))
    g.vars.click_timer = timer(0.1)
    
    g.libs.generator:new_grid()

    visible_grids =g.vars.visible_grids
    view_port = g.vars.view_port

    mpos = g.libs.types.pos(scr_w/2,150)

    --love.mouse.setPosition(mpos.x,mpos.y + 20)
    love.mouse.setPosition(mpos.x,scr_mid.y)
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
    --local act ={"0:0","1:0","-1:0"}
    --grid debug
    
    visible_grids = g.vars.full_grid

    love.graphics.push()
    love.graphics.translate(cam_offset.x,cam_offset.y)
    --for idx, grid_key in pairs(visible_grids) do
    for  grid_key, _ in pairs(visible_grids) do
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
    
    love.graphics.setColor(0,255,0)
    local act_grid = g.vars.actual_grid
    --debug active grid
    local offset ={
        x = base_offset.x + act_grid.idx.x*grid_size.w,
        y = base_offset.y + act_grid.idx.y*grid_size.h
    }

    love.graphics.rectangle("line",
                            offset.x,
                            offset.y,
                            grid_size.w,grid_size.h)

    love.graphics.pop()

end


function in_root:draw()
    love.graphics.push()
        love.graphics.translate(cam_offset.x,cam_offset.y)
        background()
    --love.graphics.pop()

    --love.graphics.push()
        --love.graphics.translate(cam_offset.x,cam_offset.y)
        g.var("main_root"):draw()
    love.graphics.pop()

    grid()
end


function update_grid()
    local act_crid = g.vars.actual_grid
    local grid_mid = helpers.to_glob( {x=grid_size.w/2, y=grid_size.h/2},
                                        g.vars.actual_grid.idx.x,g.vars.actual_grid.idx.y )

    local new_grid_idx = nil
    local gen_dir      = nil
    local new_grid_y   = nil


    --left
    if mouse_coords.x - cam_offset.x < grid_mid.x - grid_size.w/2 then
        new_grid_idx = g.vars.actual_grid:idx_to_str({x=act_crid.idx.x-1,y=act_crid.idx.y})
        gen_dir = "left"
        new_grid_y = act_crid.idx.y
    --right
    elseif mouse_coords.x - cam_offset.x > grid_mid.x + grid_size.w/2 then
        new_grid_y = act_crid.idx.y
        new_grid_idx = g.vars.actual_grid:idx_to_str({x=act_crid.idx.x+1,y=act_crid.idx.y})
        gen_dir = "right"
    elseif mouse_coords.y - cam_offset.y < grid_mid.y - grid_size.h/2 then
        new_grid_y = act_crid.idx.y -1
        new_grid_idx = g.vars.actual_grid:idx_to_str({x=act_crid.idx.x,y=act_crid.idx.y-1})
        gen_dir = "up"
    elseif mouse_coords.y  - cam_offset.y > grid_mid.y + grid_size.h/2 then
        new_grid_y = act_crid.idx.y +1
        new_grid_idx = g.vars.actual_grid:idx_to_str({x=act_crid.idx.x,y=act_crid.idx.y+1})
        gen_dir = "down"
    end

    if new_grid_idx ~= nil and new_grid_y >=0 then
        print("\n=============")
        print("UPDATING GRID\n")
        print("   MOUSE:",mouse_coords.x,mouse_coords.y)
        print("   MID:",grid_mid.x,grid_mid.y)
        g.vars.actual_grid =  g.vars.full_grid[new_grid_idx]
        print("   IDX:",new_grid_idx)
        print(g.vars.actual_grid)
        print("   UPGRADE DIR:",gen_dir)
        g.vars.actual_grid["add_"..gen_dir](g.vars.actual_grid, 
                                            g.vars.actual_grid.idx )

    
    end
    
end

function in_root:update()
    --local viewable_grids ={"0:0","1:0","-1:0"}
    visible_grids = g.vars.full_grid


    --print(love.mouse.isDown(1))
    if love.mouse.isDown(1) and g.vars.click_timer:check() then
        local m_pos_x,m_pos_y = love.mouse.getPosition()
       --print("adding")
       local pos = g.libs.types.pos(m_pos_x,m_pos_y)
       --print(pos.x,pos.y)
       g.var("main_root"):append(pos)

    end
    
    if mouse_moved == false and move_timer:check()  then
        -- adjust camera offset since in a moving zone
        if mid_angle ~= -1 then
            cam_offset = helpers.point_in_circle(cam_offset,1,math.deg(mid_angle)+180)--mid_dist)
            update_grid()
        end
    elseif mouse_moved then
        if mouse_coords_prev == nil then
            mouse_coords_prev = mouse_coords:copy()
        end

        --cam_offset = g.libs.types.pos( cam_offset.x +(mouse_coords_prev.x - mouse_coords.x),
        --                               cam_offset.y +(mouse_coords_prev.y - mouse_coords.y))
        --local mid_diff = g.lib.types.pos(scr_mid.x -mouse_coords.x, scr_mid.y - mouse_coords.y   )
        local mid_dist = scr_mid:distance_to(mouse_coords)  
        
        if mid_dist > 20  then
            mid_angle = scr_mid:angle(mouse_coords)

            print("Distance:",mid_dist)
            

            cam_offset = helpers.point_in_circle(cam_offset,1,math.deg(mid_angle)+180)--mid_dist)
            print("Updated offset:",cam_offset.x,cam_offset.y)
        else
            mid_angle = -1
        end


        update_grid()

        mouse_coords_prev = mouse_coords:copy()
    end


    --check for a selection
    if mouse_moved==true and g.vars.cur_selection== nil then
        
        --print("check which is selected")
        --print(mouse_moved, g.vars.cur_selection)
        local found_hit = false
        --for _,grid_id in pairs(visible_grids) do
        for grid_id, _ in pairs(visible_grids) do
            local grid = g.vars.full_grid[grid_id]
            if grid ~= nil then
                for _ ,puddle in pairs(grid.objects.puddles) do
                    --if helpers.to_glob( puddle.pos,grid.idx.x,grid.idx.y ):distance_to(  mouse_coords) <= puddle.size then
                    if helpers.to_glob( puddle.pos ,grid.idx.x,grid.idx.y ):distance_to(  {x = mouse_coords.x - cam_offset.x,  y= mouse_coords.y - cam_offset.y}) <= puddle.size then
                        puddle.selected = true
                    
                        found_hit = true

                        g.vars.cur_selection = puddle
                        
                        break
                    end
                end
                
                if grid.objects.cave and found_hit == false then
                    local cave = grid.objects.cave
                    if helpers.to_glob( cave.interact,grid.idx.x,grid.idx.y ):distance_to({x=mouse_coords.x - cam_offset.x,y= mouse_coords.y - cam_offset.y}) <= 10 then
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
        end
    elseif mouse_moved then
        --print("check if still selected")
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