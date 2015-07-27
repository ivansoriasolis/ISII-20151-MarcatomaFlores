local storyboard =require 'storyboard'
local scene =storyboard.newScene()--variable que almacenara una nueva escena
function scene:createScene()
	grupo1=self.view 
	print( 'create menu' )
	crearFondo()--llamamos a la funcion crearFondo
	crearMenu()-- llamamos a la funcion crearMenu
end
function crearMenu( )
   txtIniciar=display.newText( grupo1,'INICIAR', display.contentWidth/2,display.contentHeight/2-80,nil,30)--creamos el texto	
   txtIniciar.id='INICIAR'--asignamos id al texto
   txtIniciar:setTextColor( 255,0,0 )--color del texto
   txtIniciar:addEventListener( 'tap',ir)--agregamos evento tap al texto
   
   txtSalir=display.newText( grupo1,'SALIR', display.contentWidth/2,display.contentHeight/2-20,nil,30)	
   txtSalir.id='SALIR'
   txtSalir:setTextColor( 255,0,0 )
   txtSalir:addEventListener( 'tap',ir)
end
function crearFondo( )
	fondo=display.newImageRect( grupo1,'img/fondo.jpg',480,320)
	fondo.x,fondo.y=display.contentWidth/2,display.contentHeight/2
end
function ir(event)
	modo=event.target.id--asignamos a la variable modo el id de los textos
	if modo=='INICIAR' then 
       storyboard.gotoScene('principal','fade',1000)---pasamos a otra escena 'principal'
	end
	if modo=='SALIR' then 
      os.exit()--salimos de la aplicacion
	end
end
function scene:enterScene()
	print( 'enter menu' )	
end
function scene:exitScene()
	grupo1:removeSelf( )--eliminamos todos los objetos del grupo
	print( 'exit menu' )
    storyboard.removeScene('menu','fade',1000)--eliminamos la scena al pasar a otra
end
function scene:destroyScene()
	print( 'destroy menu' )
	
end
-----EVENTOS DE LA ESCENA
scene:addEventListener( 'createScene',scene)
scene:addEventListener( 'enterScene',scene)
scene:addEventListener( 'exitScene',scene)
scene:addEventListener( 'destroyScene',scene)
return scene
