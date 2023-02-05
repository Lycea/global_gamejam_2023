require("key_handle")
require("renderer.renderer")
g = require("globals")


require("states.game_states")
sample_state=require("states.state_sample")



local game ={} 


--------------------------- 
--preinit functions? 
--------------------------- 
 
 
local base={} 
------------------------------------------------------------ 
--Base data fields 
------------------------------------------------------------ 
 

constants = nil


------------------------ 
-- dynamic data 



--game state
game_state = GameStates.MAIN_MENUE
previous_game_state = game_state



--others
key_timer = 0--timer between movement



mouse_coords={0,0}
mouse_moved = false


exit_timer =0
selector_timer = 0
target_timer   = 0

show_main_menue =true
main_menue_item = 1

selected_state_idx = 1


----------------------------------------------------------- 
-- special data fields for debugging / testing only 
----------------------------------------------------------- 



function update_menue()
	for key,v in pairs(key_list) do
      print("Key pressed",key)
    local action=handle_main_menue(key)--get key callbacks
        if action["menue_idx_change"] ~= nil then
          if key_timer+0.2 < love.timer.getTime() then
            
            main_menue_item = main_menue_item+ action["menue_idx_change"][2] 
            if main_menue_item <1 then main_menue_item = 1 end
            if main_menue_item>4 then main_menue_item = 4 end
            print(main_menue_item)
          
            key_timer = love.timer.getTime()
          
          end
          
        end
        
        -- main menu action handling
        if action["selected_item"]~= nil then
          show_main_menue = false
          --menue item switcher
          if main_menue_item == 1 then--new game
            game_state=GameStates.PLAYING
            game.new()
          elseif main_menue_item == 2 then--load game
            
            
          elseif main_menue_item == 3 then
            
          else
            love.event.quit()
          end
          
          
        end
        
        if action["exit"]~= nil then
            love.event.quit()
        end
	end
end



--loading a game
function game.load() 


end 
 
 
 --new game
function game.new()
   sample_state:startup()
end

 

function game.play(dt) 

  --handle keys,  mainly used for menue action here....
  for key,v in pairs(key_list)do      
      --print("got some id",plid)
      
        --print(key,v)
        local action=handle_keys(key)--get key callbacks
        
        
        if action["exit"]  then
            
            if exit_timer +0.3 < love.timer.getTime() then
                love.event.quit()
            end
            
        end
  end
 
  sample_state:update()
end 
 
 
--main loop
function game.update(dt) 
  
  --handle game stuff
  if show_main_menue == false then
    game.play(dt)
    return
  end
  
  
  --handle menue
  update_menue()
  
  mouse_moved = false
end

 
function game.draw() 
    if show_main_menue ==true then
        render_menue()
        
        return
    end
    
    sample_state:draw()
end 
 
 
 
 
--default key list to check


function game.keyHandle(key,s,r,pressed_) 
  if pressed_ == true then
    key_list[key] = true
    last_key=key
  else
    key_list[key] = nil
  end
end 
 
 


function game.MouseHandle(x,y,btn) 
   
end 
 
function game.MouseMoved(mx,my) 
  mouse_coords=  g.libs.types.pos(mx,my)
  mouse_moved = true
end 
 
 

return game