local generator = class_base:extend()

local puddle = class_base:extend()
local cave = class_base:extend()

local grid_tile = class_base:extend()
local grid = class_base:extend()
str = tostring

function grid_tile:new( idx )
    if connections == nil then
        self.neighbours = {}
    end
    self.idx =idx
    self.objects ={}
    print("ADDING IDXs:", self.idx.x,self.idx.y)
    print("TO_STR:",self:idx_to_str(self.idx))
    g.vars.full_grid[self:idx_to_str(self.idx)] = self
end


function grid_tile:idx_to_str(idx)
    return ""..str(idx.x)..":"..str(idx.y)
end 

function puddle:new(pos,size,idx)
    --grid local placements
    self.pos = pos
    self.size =size
    self.idx = idx

    self.water_value_max = 100
    self.water_value_now = 90

    self.selected=false

    self.connection= nil
end

function cave:new(pos,size,idx)
    self.pos = pos
    self.size = size
    self.idx = idx
    
    self.interact = g.libs.types.pos( self.pos.x, self.pos.y +self.size)
    self.selected = false
    self.plants= nil
end

function generator:new()
    self.grid_size = {w= 200,h= 200}
end

function generator:add_puddles(idx)
    local puddles ={}
    table.insert(puddles,  
                puddle( g.libs.types.pos( 50,50 ), 20 ,idx  ))

    table.insert(puddles,  
                puddle( g.libs.types.pos( self.grid_size.w - 50, 50 ), 20, idx   ))

    table.insert(puddles,  
                puddle( g.libs.types.pos( 50, 150 ), 20,idx   ))
    
    table.insert(puddles,  
                puddle( g.libs.types.pos( self.grid_size.w - 50, 150 ), 20,idx   ))
    
    return puddles 
end

function generator:add_cave(idx)
    local cave = cave( g.libs.types.pos(self.grid_size.w/2, self.grid_size.h/2 ), 40, idx)
    return cave
end


generator.cave   = cave
generator.puddle = puddle




function generator:new_grid_tile(idx)
    local grid_tile = grid_tile(idx)

    grid_tile.objects.puddles = self:add_puddles(idx)
    grid_tile.objects.cave    = self:add_cave(idx)

    grid_tile.objects.root_parts = {}

    return grid_tile
end

function generator:first_tile()
    local grid_tile = grid_tile({x=0,y=0})

    grid_tile.objects.puddles  = self:add_puddles(grid_tile.idx)
    grid_tile.objects.cave     = self:add_cave(grid_tile.idx)
    grid_tile.objects.root_parts = {}

    return grid_tile
end





-- general extenders
function grid_tile:add_left(base_idx)end
function grid_tile:add_right(base_idx)end
function grid_tile:add_up(base_idx)end
function grid_tile:add_down(base_idx)end

--first init helpers
function grid_tile:add_mid()
     g.libs.generator:new_grid_tile({x=-1,y=0})
     g.libs.generator:new_grid_tile({x=1 ,y=0})
end

function grid_tile:add_bot()
    g.libs.generator:new_grid_tile({x=-1,y=-1})
    g.libs.generator:new_grid_tile({x=0 ,y=-1})
    g.libs.generator:new_grid_tile({x=1 ,y=-1})
end

function generator:new_grid()
    g.vars.full_grid   = {}
    g.vars.actual_grid =  self:first_tile()
    
    g.vars.actual_grid:add_mid()
    g.vars.actual_grid:add_bot()
end

return generator()