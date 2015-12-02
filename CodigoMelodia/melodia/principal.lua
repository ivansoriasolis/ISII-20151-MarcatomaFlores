local storyboard =require 'storyboard'
local widget = require "widget"--importamos libreria widget para crear los botones
local clase =require "loadsave"--importamos modulo loadsave para hacer uso de sus metodos
cont = clase.cargarTabla("tabla.json", system.DocumentsDirectory)--asignamos a la variable global 'cont' el dato del fichero tabla.json
local tecla,nota ={},{}--creamos las tablas para almacenar teclas y sonidos
local r   --variable que almacenara el audio a grabar
local temporal  --            
local SonidoPlay = false  --estado de reproduccion 
local SonidoPausado = false   --estado de reproduccion
local btnGrabar,btnMostrar,txtMensaje--vaiables locales que almacenaran los objetos(botones y mensaje de estado)
local scene =storyboard.newScene()--variable que almacenara una nueva escena
function scene:createScene()
	grupo2=self.view  --creamos un nuevo grupo
    print( 'create principal' )
	crearControl()--llamamos a la funcion crearControl
    NombreArchivo = "melodia"
    temporal = system.pathForFile( NombreArchivo, system.DocumentsDirectory )
    r = media.newRecording(temporal)  
	crearTeclas()--llamamos a la funcion crearTeclas
	asignarNota()--llamamos a la funcion asignarNota
if cont==nil then---la primera vez que se carga  cont es nulo=nil, porque no contiene ningun dato
       cont=0
       clase.guardarTabla(cont, "tabla.json", system.DocumentsDirectory)--guardamos cont=0 en el fichero tabla.json
      end
end
function ir()
storyboard.gotoScene( "listaMelodias", 'fade',1000 )--ir a la escena listaMelodias
end
function crearTeclas()
	for i=1,7 do 
		tecla[i]=display.newImageRect( grupo2,'img/color'..i..'.png',60,200)
		tecla[i].x,tecla[i].y=i*65-20,160
		tecla[i].id=i
		tecla[i].alpha=.3
		tecla[i]:addEventListener( 'touch',toque )
	end
end
function toque(event)
	modo=event.target.id
    if event.phase=='began' then audio.play(nota[modo])    transition.to(event.target,{time=200,alpha=1,xScale=1.3,yScale=1.3}) end --iniciamos reproduccion de la nota y escalamos tecla(animacion)
    if event.phase=='ended' or event.phase=='cancel' then  transition.to(event.target,{time=200,alpha=.3,xScale=1,yScale=1})  end --al soltar la tecla restablecemos el escalado
end
function asignarNota( )
	for i=1,7 do
		nota[i]=audio.loadSound('sonido/nota'..i..'.')--asigmanos  sonidos a la tabla nota
	end
end
function verificarEstado ()--funcion para verificar el estado de la grabacion
    local estado = " "
    if r then -- si r=true osea existe
        local EstadoString = ""--estring vacio
        local Recortando = r:isRecording ()
        if Recortando then --si Recortando=true
            EstadoString = "GRABANDO" 
          	btnGrabar:setLabel( "PARAR GRABACION")--cambiamos texto del boton
        elseif SonidoPlay then --si SonidoPlay=true
            EstadoString = "ESCUCHANDO"
            btnGrabar:setLabel( "PAUSAR REPRODUCCION") --cambiamos texto del boton
        elseif SonidoPausado then-- si SonidoPausado=true
            EstadoString = "PAUSADO"
            btnGrabar:setLabel( "RESUMIR REPRODUCCION") --cambiamos texto del boton
        else --caso contrario se espera entrada del usuario
            EstadoString = "INICIAR"
            btnGrabar:setLabel( "GRABAR")
        end
        estado =  EstadoString 
    end
    txtMensaje.text = estado--modificamos el texto del mensaje
end
-------------------------------------------------------------------------------
function ReproduccionCompleta (event)--verificar si la reproduccion de la melodia finalizo
    SonidoPlay = false
    SonidoPausado = false
	audio.dispose(event.handle)-- liberamos memoria
	verificarEstado ()	
end 
function grabar ( event )--evento para grabar melodia
    if SonidoPlay then --si SonidoPlay=true
        SonidoPlay = false
        SonidoPausado = true
		audio.pause() --pausamos la reproduccion
    elseif SonidoPausado then --si SonidoPausado=true
        SonidoPlay = true   
        SonidoPausado = false
        audio.resume()  --resumimos Reproduccion
    else
        if r then -- si r=true osea existe
            if r:isRecording() then--si se esta grabando
                r:stopRecording()--paramos la grabacion
          --      escucharGrabacion()
            else
            	cont=cont+1--incrementamos indice
            	NombreArchivo = "melodia"..cont..'.wav' --nombre del archivo de audio a guardar
            	local temporal = system.pathForFile( NombreArchivo, system.DocumentsDirectory )
                r = media.newRecording(temporal) --creamos nueva melodia con su indice incrementado
                SonidoPlay = false
                SonidoPausado = false
                r:startRecording() --iniciamos grabacion de la melodia
                clase.guardarTabla(cont, "tabla.json", system.DocumentsDirectory)  --guardamos el indice incrementado en el fichero tabla.json                            
                print( 'grabando' )               
            end
        end
    end
    verificarEstado ()--verificamos el estado
end
 function escucharGrabacion()
   	  local temporal = system.pathForFile( NombreArchivo, system.DocumentsDirectory )
                local archivo = io.open( temporal, "r" )
                if archivo then
                    io.close( archivo )
                    SonidoPlay = true
                    SonidoPausado = false
                    print( 'abrir' )
					EscucharGrabacion = audio.loadStream( NombreArchivo, system.DocumentsDirectory )
					audio.play( EscucharGrabacion, { onComplete=ReproduccionCompleta } )
                end                
   end  
function crearControl()
    btnGrabar = widget.newButton--creamos boton grabar
{
    defaultFile = "img/buttonRed.png",
    overFile = "img/buttonRedOver.png",
    onPress = grabar,
    label = " GRABAR",
    fontSize = 10,
}
btnGrabar.x =250;          btnGrabar.y = 30
grupo2:insert(btnGrabar)--agregamos al grupo

txtMensaje = display.newText( grupo2," ", display.contentWidth/2, 195, native.systemFont, 32 )--creamos mensaje
txtMensaje:setFillColor( 10/255, 240/255, 102/255 )

btnMostrar = widget.newButton--creamos boton mostrar 
{
    defaultFile = "img/buttonRed.png",
    overFile = "img/buttonRedOver.png",
    label = "Mostrar Melodias",
    fontSize = 10,
}
btnMostrar.x =250;         btnMostrar.y = 300
btnMostrar:addEventListener( 'tap',ir )
grupo2:insert(btnMostrar) --agregamos al grupo
end
function scene:enterScene()
print( 'enter principal' )
end
function scene:exitScene()
grupo2:removeSelf( )	--eliminamos grupo
print( 'exit principal' )
storyboard.removeScene('principal','fade',1000)
end
function scene:destroyScene()
print( 'destroy principal' )	
end
--EVENTOS DE LA ESCENA
scene:addEventListener( 'createScene',scene)
scene:addEventListener( 'enterScene',scene)
scene:addEventListener( 'exitScene',scene)
scene:addEventListener( 'destroyScene',scene)
return scene
