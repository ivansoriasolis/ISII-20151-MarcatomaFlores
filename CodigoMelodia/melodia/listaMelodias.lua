local storyboard =require 'storyboard'
local widget = require "widget"--importamos libreria widget para crear los botones
local clase =require "loadsave"--importamos modulo loadsave para hacer uso de sus metodos
cont = clase.cargarTabla("tabla.json", system.DocumentsDirectory)--asignamos a la variable global 'cont' el dato del fichero tabla.json
local pausa = true
local arrayMelodia ={}--creamos tabla para almacenar las melodias grabadas
local scene =storyboard.newScene()
function scene:createScene(event)
	grupo3=display.newGroup()  
	cantidad=cont--almacenamos el valor de cont en la variable cantidad
    print( 'create listamelodias' )
    crearFondo()--llamamos a la funcion crear fondo
	cargarMelodias()--llamamos a la funcion cargarMelodias
	crearControl()--llamamos a la funcion crearControl
end
function crearFondo( ) --funcion para crear fondo de la scena
	fondo=display.newImageRect( grupo3,'img/fondo2.jpg',400,150)
	fondo.x,fondo.y=300,90
end
local function onRowRender( event )--renderizamos datos del array a la list1
	local phase = event.phase--evento de toque de la fila de la lista
	local row = event.row	--fila de la lista
	local y = row.contentHeight * 0.5
	local fila = display.newText( row, row.id, 0, 0, native.systemFontBold, 13 )
	fila.anchorX = 0
	fila.x = 5
	fila.y = y
	fila:setFillColor( 0 )
end
local function onRowTouch( event )
	local phase = event.phase--evento de toque de la fila de la lista
	local row = event.target--fila de la lista
	if "press" == phase then--si prisiono la fila
		 print( "melodia: " .. row.id )
		 txtMelodia.text=row.id--cambiamos el texto de la melodia por el texto de la fila pulsada
		 txtMelodia.id=row.id	--	agregamos id al texto de la melodia
	end
end
function cargarMelodias()
txtMelodia=display.newText( grupo3,'',display.contentWidth/2, display.contentHeight/2+10,nil,30)--creamos texo
txtMelodia:setTextColor( 255,0,0)
local barra = display.newRect( grupo3, 45, 0,130, 32 )--creamos rectangulo superior
local titulo = display.newText( grupo3,'MELODIAS',display.contentWidth/2, 40,nil,13)--creamos texto que tendra la barra
barra.fill = { type = 'gradient', color1 = { .74, .8, .86, 1 }, color2 = { .35, .45, .6, 1 } }--cambiamos de color la barra
barra.x,barra.y =display.contentWidth/2,40--lo ubicamos en pantalla
list1 = widget.newTableView--creamos la lista
{
	top = barra.contentHeight + display.screenOriginY,
	left = display.screenOriginX,
	width = 130, 
	height = 100,
	onRowRender = onRowRender,--funcion para renderizar datos en la lista
	onRowTouch = onRowTouch,--funcion para el toque de los elementos de la lista
}
list1.x=display.contentWidth/2--lo ubicamos en pantalla
list1.y=100
grupo3:insert( list1 )--agregamos lista al grupo
	for i=1,cantidad do
		local temporal = system.pathForFile( 'melodia'..i..'.wav', system.DocumentsDirectory )--ruta del audio
		local	existe= io.open(temporal)--abrimos audio se existe
		if existe~=nil then --si el archivo existe entonces existe sera distinto de nulo caso contrario no existe
			 arrayMelodia[i]='melodia'..i..'.wav'--almacenamos nombre del audio
			 print( arrayMelodia[i] )
			 list1:insertRow{id = arrayMelodia[i],}--insertamos fila con su nombre del archivo respectivo
			 existe:close()	 existe=nil --como abrimos el audio si existe, pues tendremos que cerrarlo
		else
			print( existe )--aqui inprimira 'nil' si el audio no existe
		end

	end

end

function eventoToque(event)     
modo=event.target.id	--modo = al id de la fila de la lista o,boton play o, boton pause o, boton atraz
   if  txtMelodia.text~='' then --si el texto de la melodia contiene un valor
 		
   		if modo=='play' then 
   			if event.phase=='began' then --si presiona boton play
      		transition.to( event.target, {time=200,xScale=1.5,yScale=1.5} )--animacion de escalado

   			end    
   			if event.phase=='ended' then --si suelta boton play
      		transition.to( event.target, {time=200,xScale=1,yScale=1} ) --animacion de escalado
      		print( modo )
      		local filePath = system.pathForFile(  txtMelodia.text, system.DocumentsDirectory )--ruta del audio 
               
            local file = io.open( filePath, "r" ) --leeremos el audio 'r'
                
	            if file then--si el audio existe es file=true caso contrario no existe y nos da file=false
                io.close( file ) --cerramos audio
	      		EscucharGrabacion = audio.loadStream( txtMelodia.text, system.DocumentsDirectory )--cargamos audio
	            audio.play( EscucharGrabacion ,{ onComplete=ReproduccionCompleta } )--reproducimos audio y verificamos si se reproducio completamente
	           audio.setVolume (10)--volumen del audio
	           txtEstado.text='REPRODUCIENDO'--mostramos mensaje que el audio se esta reproduciendo
		        btnPlay.isVisible=false  
		        btnPausa.isVisible=true  
		        end
   			end  
   		end
   		if modo=='pausa' then 
            if event.phase=='began' then --si presiona boton pausa
      		transition.to( event.target, {time=200,xScale=1.5,yScale=1.5} )--animacion de escalado
   			end    
   			if event.phase=='ended' then --si suelta boton pausa
      		   transition.to( event.target, {time=200,xScale=1,yScale=1} )--animacion de escalado
		      		if pausa== true then 
		      		   audio.pause()  txtEstado.text='PAUSADO' pausa=false --pausamos reproduccion
		      		else
		      		   audio.resume() txtEstado.text='REPRODUCIENDO' pausa=true --remumimos reproduccion
		      		end	                       
   			end  
   		end
   else
	txtMelodia.text='seleccione una melodia'--si el texto de la melodia contiene no tiene un valor
   end
   if modo=='atraz' then 
      		if event.phase=='began' then --si presionamos boton atraz
      		transition.to( event.target, {time=200,xScale=1.5,yScale=1.5} )--animacion de escalado

   			end    
   			if event.phase=='ended' then  --si soltamos boton atraz
      		transition.to( event.target, {time=200,xScale=1,yScale=1} )--animacion de escalado
            salir()--llamamos a la funcion salir
   		    end
   end  
   if modo=='restablecer' then 
      		if event.phase=='began' then --si presionamos boton atraz
      		transition.to( event.target, {time=200,xScale=1.5,yScale=1.5} )--animacion de escalado

   			end    
   			if event.phase=='ended' then  --si soltamos boton atraz
      		transition.to( event.target, {time=200,xScale=1,yScale=1} )--animacion de escalado
       alerta = native.showAlert( "Mensaje", "¿Desea restablecer todas las grabaciones?", { "No", "Si" },accion1)      
   		    end
   end       	
end
function ReproduccionCompleta (event)--verificamos que la reproduccion se realizo completamente
   	audio.dispose(event.handle)--liberamos memoria
	txtEstado.text='COMPLETADO'--mostramos mensaje de reproduccion finalizada
	btnPlay.isVisible=true        
    btnPausa.isVisible=false
end
function crearControl()-- creamos botones y textos
	btnPlay=display.newImageRect( grupo3,'img/play.png',30,30)
	btnPlay.x,btnPlay.y=display.contentWidth/2-50,display.contentHeight/2+50
	btnPlay.id='play'
	btnPlay:addEventListener( 'touch',eventoToque)

	btnPausa=display.newImageRect( grupo3,'img/pausa.png',30,30)
	btnPausa.x,btnPausa.y=display.contentWidth/2-50,display.contentHeight/2+50
	btnPausa.id='pausa'
	btnPausa.isVisible=false
	btnPausa:addEventListener( 'touch',eventoToque)

	txtEstado=display.newText( grupo3,'',display.contentWidth/2,display.contentHeight/2+100,nil,30)
	txtEstado:setTextColor( 0,255,0)

	btnEliminar=display.newImageRect(grupo3,'img/eliminar.png',40,40)
	btnEliminar.x,btnEliminar.y=display.contentWidth/2+50,display.contentHeight/2+50
	btnEliminar:addEventListener( 'touch',eliminar)

	btnAtraz=display.newImageRect( grupo3,'img/inicio.png',50,50)
	btnAtraz.id='atraz'
	btnAtraz.x,btnAtraz.y=50,50
	btnAtraz:addEventListener('touch',eventoToque)

    btnRestablecer=display.newImageRect( grupo3,'img/restablecer.png',50,50)
	btnRestablecer.id='restablecer'
	btnRestablecer.x,btnRestablecer.y=470,50
	btnRestablecer:addEventListener('touch',eventoToque)

end
function eliminar(event)
	if event.phase=='began' then --si presionamos boton eliminar
	   transition.to(btnEliminar,{time=200,xScale=1.5,yScale=1.5})--animacion de escalado
	end
	if event.phase=='ended' then --si soltamos boton eliminar
	   transition.to(btnEliminar,{time=200,xScale=1,yScale=1})--animacion de escalado
	   --mostramos un mensaje de alerta y llamamos a la funcion accion
       alerta = native.showAlert( "Mensaje", "¿Desea eliminar "..txtMelodia.text.."?", { "No", "Si" },accion)
    end 
end
function accion(event)
	if event.index == 2 then--se presiono el boton si
	  local temporal = system.pathForFile( ''..txtMelodia.text, system.DocumentsDirectory )--ruta del archivo de audio
      local	elimina= os.remove(temporal)--eliminamos el audio
      print( elimina )
      salir()--llamamos a la funcion salir
   end	
end
function accion1(event)
	if event.index == 2 then--se presiono el boton si	 
      for i=1,cantidad do
			local temporalAudio = system.pathForFile( 'melodia'..i..'.wav', system.DocumentsDirectory )--ruta del audio
			local	existe= io.open(temporalAudio)--abrimos audio se existe
			if existe~=nil then --si el archivo existe entonces existe sera distinto de nulo caso contrario no existe
			existe:close()	 existe=nil --como abrimos el audio si existe, pues tendremos que cerrarlo
		    local	eliminaAudio= os.remove(temporalAudio)--eliminamos el audio
			print( 'existe' )
			else
			print( 'no existe' )--aqui inprimira 'nil' si el audio no existe
			end

	  end
	   local temporal = system.pathForFile('tabla.json', system.DocumentsDirectory )--ruta del archivo de audio
       local	elimina= os.remove(temporal)--eliminamos el archivo
       print( elimina )
       salir()--llamamos a la funcion salir
   end	
end
function salir()
	storyboard.gotoScene('menu','zoomOutInFade',1000)--vamos a la escena principal de la aplicacion
end
function scene:enterScene()
print( 'enter listamelodias' )
	
end
function scene:exitScene()

print( 'exit listamelodias' )
grupo3:removeSelf( )	--eliminamos objetos del grupo
storyboard.removeScene('listaMelodias','fade',1000)
end
function scene:destroyScene()
print( 'destroy listamelodias' )	
end
--EVENTOS DE LA ESCENA
scene:addEventListener( 'createScene',scene)
scene:addEventListener( 'enterScene',scene)
scene:addEventListener( 'exitScene',scene)
scene:addEventListener( 'destroyScene',scene)
return scene
