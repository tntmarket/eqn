define [
  'angular'
], (angular) ->

  proxy = null

  class DraggableElement
    constructor: (@element, initX, initY, @parentPanZoom) ->
      @canDrag = true
      @element.on 'mousedown', @recordElementOffset.bind this
      @element.on 'dragstart', @onDragstart.bind this
      @element.on 'dragend', @reTranslate.bind this
      @moveTo initX, initY

    recordElementOffset: (event) ->
      if @canDrag
        @_offsetX = event.offsetX
        @_offsetY = event.offsetY

    reTranslate: (event) ->
      if @canDrag
        @element.removeClass 'dragging'
        zoom = @parentPanZoom.zoom
        pageX = event.pageX; pageY = event.pageY
        dropX = (pageX - @_offsetX)/zoom
        dropY = (pageY - @_offsetY)/zoom
        if 0 < dropX and dropX < @parentPanZoom.initWidth and
           0 < dropY and dropY < @parentPanZoom.initHeight
          @moveTo dropX, dropY

    moveTo: (x, y) ->
      if @onDrop
        @onDrop x, y
      @element.css 'left', x + 'px'
      @element.css 'top', y + 'px'

    onDragstart: (event) ->
      if @canDrag
        @element.addClass 'dragging'

        proxy.attr 'class', @element.attr 'class'
        proxy.addClass 'drag-proxy'
        proxy.html @element.html()

        event.dataTransfer.setDragImage proxy[0], @_offsetX, @_offsetY
        event.dataTransfer.effectAllowed = 'move'
        event.dataTransfer.setData 'text/plain','crap'


  exports =
    setPaper: (paperEl) ->
      paperEl.on 'dragover', (event) ->
        # Lets you actually drop?! Fucking HTML5 DND spec.
        event.preventDefault()

      paperEl.on 'drop', (event) ->
        # prevents following the content as a link or some shit
        event.preventDefault()

      proxy = angular.element '<div style="z-index:-1" class="drag-proxy"></div>'
      paperEl.append proxy

    bindElement: (el, initX, initY, parentPanZoom) ->
      new DraggableElement(el, initX, initY, parentPanZoom)



