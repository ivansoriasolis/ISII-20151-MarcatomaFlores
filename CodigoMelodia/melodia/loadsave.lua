local M = {}
local json = require("json")

function M.guardarTabla(dato, nombreTabla, ubicacion)
    local path = system.pathForFile( nombreTabla, ubicacion)
    local tabla = io.open(path, "w")
    if tabla then
        local atributo = json.encode(dato)
        tabla:write( atributo )
        io.close( tabla )
        return true
    else
        return false
    end
end
 
function M.cargarTabla(nombreTabla, ubicacion)
    local path = system.pathForFile( nombreTabla, ubicacion)
    local atributo = ""
    local myTabla = {}
    local tabla = io.open( path, "r" )
    if tabla then
        local atributo = tabla:read( "*a" )
        myTabla = json.decode(atributo);
        io.close( tabla )
        return myTabla
    end
    return nil
end
return M
