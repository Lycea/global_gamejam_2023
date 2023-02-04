local globals ={}

globals.vars ={}
globals.libs ={}

glib = globals.libs
gvar = globals.vars

local function lib(lib,name)
    glib[name]=require(lib)
    print(glib[name])
end

function globals.lib(name)
    return glib[name]
end

function globals.var(name)
    return gvar[name]
end

lib("components.root","Root")
lib("helper.base_types","types")

return globals