define [
   'angular'
   'css!./pan_zoom.less'
], ->
   class PanZoom
      panX: -> @_panX() - @excessX()
      panY: -> @_panY() - @excessY()

      excessX: -> @withExceededBoundX @_excessX
      excessY: -> @withExceededBoundY @_excessY

      #without edge resistance
      _panX: -> @_lastPanX + @dDragX()
      _panY: -> @_lastPanY + @dDragY()

      dDragX: -> @_lastMoveX - @_lastTouchX
      dDragY: -> @_lastMoveY - @_lastTouchY

      _excessX: (xBound) -> @dDragX() - (xBound - @_lastPanX)
      _excessY: (yBound) -> @dDragY() - (yBound - @_lastPanY)

      constructor: (
         initX=0, initY=0,
         @initWidth=7680, @initHeight=4320,
         @viewportWidth=820, @viewportHeight=679
      ) ->
         @panning = false

         @minZoom = 1 / 4 - 0.01
         @zoom = 1
         @maxZoom = 1

         @_lastPanX = initX; @_lastPanY = initY
         @_lastTouchX = 0; @_lastTouchY = 0
         @_lastMoveX = 0; @_lastMoveY = 0

      touch: (x, y) ->
         @panning = true
         @_lastPanX = @_panX()
         @_lastPanY = @_panY()
         @_lastTouchX = @_lastMoveX = x
         @_lastTouchY = @_lastMoveY = y

      withExceededBoundX: (doWithBound) ->
         if @_panX() < @minX()
            doWithBound.call this, @minX()
         else if @_panX() > @maxX()
            doWithBound.call this, @maxX()
         else
            0
      withExceededBoundY: (doWithBound) ->
         if @_panY() < @minY()
            doWithBound.call this, @minY()
         else if @_panY() > @maxY()
            doWithBound.call this, @maxY()
         else
            0

      untouch: ->
         @panning = false
         @snapToBounds()

      snapToBounds: ->
         @withExceededBoundX @setX
         @withExceededBoundY @setY

      scroll: (factor, aboutX, aboutY) ->
         newZoom = @zoom * factor
         if @minZoom <= newZoom and newZoom <= @maxZoom
            ###
            We want the mouse to point to the same thing
            before and after a zoom. This means the mouse
            position inside the viewport (offset) and the absolute mouse
            position (pan + zoom*offset) need to be the same
            before and after a zoom:

            pan  + zoom  * offset = pan' + zoom' * offset

            Ticked variables are the values after the zoom.
            We know zoom' = factor * zoom so solving for pan':

            pan' = pan + (zoom - zoom') * offset. Hence:
            ###
            @_lastPanX += (@zoom - newZoom) * aboutX
            @_lastPanY += (@zoom - newZoom) * aboutY
            @zoom = newZoom

      move: (x, y) ->
         if @panning
            @_lastMoveX = x;
            @_lastMoveY = y

      minX: -> if @width() < @viewportWidth  then 0 else @viewportWidth - @width()
      minY: -> if @height() < @viewportHeight then 0 else @viewportHeight - @height()
      maxX: -> if @width() < @viewportWidth  then @viewportWidth - @width() else 0
      maxY: -> if @height() < @viewportHeight then @viewportHeight - @height() else 0

      width: ->
         Math.round @initWidth * @zoom
      height: ->
         Math.round @initHeight * @zoom

      setX: (x) ->
         @_lastPanX = x
         @_lastTouchX = @_lastMoveX
      setY: (y) ->
         @_lastPanY = y
         @_lastTouchY = @_lastMoveY


   _document = angular.element(document)
   class PanZoomElement
      constructor: (panZoom, element) ->
         @panZoom = panZoom
         @element = element
         @boundOnMove = @onMove.bind(this)

         @element.on 'mousedown', @onTouch.bind(this)
         @element.on 'mouseup', @onUntouch.bind(this)
         @element.on 'wheel', @onScroll.bind(this)
         @setPan()
         @setZoom()

      onTouch: (event) ->
         if event.button == 1
            @element.addClass 'panning'
            _document.on 'mousemove', @boundOnMove
            @panZoom.touch event.clientX, event.clientY
            @setPan()

      onUntouch: (event) ->
         if event.button == 1
            @element.removeClass 'panning'
            @panZoom.untouch()
            _document.off 'mousemove'

      onMove: (event) ->
         @panZoom.move event.clientX, event.clientY
         @setPan()

      onScroll: (event) ->
         if not @panZoom.panning
            #offset doesn't work if scrolling on child events
            scrollX = event.pageX / @panZoom.zoom
            scrollY = event.pageY / @panZoom.zoom
            @panZoom.scroll (zoomFactor event.deltaY), scrollX, scrollY
            @panZoom.snapToBounds()
         @setZoom()
         @setPan()

      setZoom: ->
         @element.css 'zoom', @panZoom.zoom

      setPan: ->
         scrollTo -@panZoom.panX(), -@panZoom.panY()

   zoomInFactor = Math.sqrt(2)
   zoomOutFactor = 1 / Math.sqrt(2)
   zoomFactor = (scrollDelta) ->
      if scrollDelta < 0 then zoomInFactor else zoomOutFactor

   _viewport = angular.element (document.body)

   return (
      PanZoom: PanZoom
      bindElement: (el, initX = 0, initY = 0) ->
         new PanZoomElement(
            new PanZoom(
               initX, initY
               el[0].offsetWidth, el[0].offsetHeight,
               _viewport[0].offsetWidth, _viewport[0].offsetHeight
            ), el)
   )
