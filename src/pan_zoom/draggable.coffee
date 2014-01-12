define ->

   class Draggable
      constructor: (@parentPanZoom, @onDrop) ->

      touch: (_xInsideElement, _yInsideElement) ->
         @xInsideElement = _xInsideElement
         @yInsideElement = _yInsideElement

      drop: (xFromDocumentLeft, yFromDocumentTop) ->
         # assume zoom doesn't change between pickup and drop
         dropX = (xFromDocumentLeft - @xInsideElement) / @parentPanZoom.zoom
         dropY = (yFromDocumentTop - @yInsideElement) / @parentPanZoom.zoom
         if ( 0 < dropX and dropX < @parentPanZoom.initWidth and
              0 < dropY and dropY < @parentPanZoom.initHeight )
            @onDrop dropX, dropY


   class DraggableEventRouter
      constructor: (@element, @draggable) ->
         @element.on 'mousedown', @recordOffsetInElement.bind this
         @element.on 'dragstart', @onDragstart.bind this
         @element.on 'dragend', @reTranslate.bind this

      recordOffsetInElement: (event) ->
         @draggable.touch event.offsetX, event.offsetY

      onDragstart: (event) ->
         event.dataTransfer.effectAllowed = 'move'
         event.dataTransfer.setData 'text/plain', @element.text()

      reTranslate: (event) ->
         @draggable.drop event.pageX, event.pageY


   return (
      Draggable: Draggable

      setPaper: (paperEl) ->
         paperEl.on 'dragover', (event) ->
            # Lets you actually drop?! Fucking HTML5 DND spec.
            event.preventDefault()

         paperEl.on 'drop', (event) ->
            # prevents following the content as a link or some shit
            event.preventDefault()

      bindElement: (el, parentPanZoom, onDrop) ->
         draggable = new Draggable parentPanZoom, onDrop
         new DraggableEventRouter el, draggable
   )


