
local in_root =class_base:extend()


function in_root:new()
    print("initialised!!")
end




function in_root:startup()
    g.vars.main_root = g.lib("Root")(g.libs.types.pos(scr_w/2,150), g.libs.types.pos(scr_w/2, 155))
    g.vars.click_timer = timer(0.1)
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


function in_root:draw()
    background()

    g.var("main_root"):draw()
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