define [
   'angular'
], (
   angular
) ->

   ghost = null
   paperWidth = 0
   paperHeight = 0

   class Draggable
      constructor: (@onDrop) ->

      touch: (@xInsideElement, @yInsideElement) ->

      drop: (xFromPaperLeft, yFromPaperTop) ->
         # assume zoom doesn't change between pickup and drop
         dropX = xFromPaperLeft - @xInsideElement
         dropY = yFromPaperTop - @yInsideElement
         if dropX < 0
            dropX = 0
         else if paperWidth < dropX
            dropX = paperWidth - 10

         if dropY < 0
            dropY = 0
         else if paperHeight < dropY
            dropY = paperHeight - 10

         @onDrop dropX, dropY


   class DraggableEventRouter
      constructor: (@element, @draggable) ->
         @element.on 'mousedown', @recordOffsetInElement.bind @
         @element.on 'dragstart', @onDragstart.bind @
         @element.on 'dragend', @reTranslate.bind @

      recordOffsetInElement: (event) ->
         @draggable.touch event.offsetX, event.offsetY

      onDragstart: (event) ->
         @element.addClass 'dragging'
         ghost.html @element.html()
         ghost.css '-webkit-transform-origin', "#{@draggable.xInsideElement}px
                                                #{@draggable.yInsideElement}px"

         event.dataTransfer.setDragImage ghost[0], @draggable.xInsideElement,
                                                   @draggable.yInsideElement
         event.dataTransfer.effectAllowed = 'move'
         event.dataTransfer.setData 'text/plain', @element.text()

      reTranslate: (event) ->
         @element.removeClass 'dragging'
         @draggable.drop event.offsetX + (parseInt @element.css 'left'),
                         event.offsetY + (parseInt @element.css 'top')


   return (
      Draggable: Draggable

      setPaper: (paperEl) ->
         paperEl.on 'dragover', (event) ->
            # Lets you actually drop?! Fucking HTML5 DND spec.
            event.preventDefault()

         paperEl.on 'drop', (event) ->
            # prevents following the content as a link or some shit
            event.preventDefault()

         ghost = angular.element (
            '<div style="z-index: -1"
                  class="expression expression-selected drag-ghost
                         default-text-color"></div>'
         )
         paperEl.after ghost[0]

      bindElement: (el, onDrop) ->
         draggable = new Draggable onDrop
         new DraggableEventRouter el, draggable

      setBounds: (width, height) ->
         paperWidth = width
         paperHeight = height

      zoomGhost: (zoom) ->
         ghost.css '-webkit-transform', "scale(#{zoom})"
   )



