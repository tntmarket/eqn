define ->

   class Draggable
      constructor: (@paperSizes, @onDrop) ->

      touch: (_xInsideElement, _yInsideElement) ->
         @xInsideElement = _xInsideElement
         @yInsideElement = _yInsideElement

      drop: (xFromDocumentLeft, yFromDocumentTop) ->
         # assume zoom doesn't change between pickup and drop
         dropX = (xFromDocumentLeft - @xInsideElement) / @paperSizes.zoom()
         dropY = (yFromDocumentTop - @yInsideElement) / @paperSizes.zoom()
         if ( 0 < dropX and dropX < @paperSizes.initWidth() and
              0 < dropY and dropY < @paperSizes.initHeight() )
            @onDrop dropX, dropY


   class DraggableEventRouter
      constructor: (@element, @draggable) ->
         @element.on 'mousedown', @recordOffsetInElement.bind @
         @element.on 'dragstart', @onDragstart.bind @
         @element.on 'dragend', @reTranslate.bind @

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

      bindElement: (el, paperSizes, onDrop) ->
         draggable = new Draggable paperSizes, onDrop
         new DraggableEventRouter el, draggable
   )


