local storyboard =require 'storyboard'
local scene =storyboard.newScene()
function scene:createScene()
	grupo=self.view
	print( 'Hola Mundo' )
	crearMenu()
end
function crearMenu( )
   txtIniciar=display.newText( grupo,'INICIAR', display.contentWidth/2,display.contentHeight/2,nil,20)	
   txtIniciar.id='INICIAR'
   txtIniciar:addEventListener( 'tap',ir)
   
   txtSalir=display.newText( grupo,'SALIR', display.contentWidth/2,display.contentHeight/2+50,nil,20)	
   txtSalir.id='SALIR'
   txtSalir:addEventListener( 'tap',ir)
end
function ir(event)
	modo=event.target.id
	if modo=='INICIAR' then 
     --  storyboard.gotoScene('principal','fade',1000)
	end
	if modo=='SALIR' then 
      os.exit()
	end
end
function scene:enterScene()
	
end
function scene:exitScene()
	
end
function scene:destroyScene()
	
end
scene:addEventListener( 'createScene',scene)
scene:addEventListener( 'enterScene',scene)
scene:addEventListener( 'exitScene',scene)
scene:addEventListener( 'destroyScene',scene)
return scene
