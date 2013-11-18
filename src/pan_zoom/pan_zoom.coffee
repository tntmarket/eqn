define [
#  'TweenMax/CSSPlugin'
#  'TweenMax/TweenMax'
  'angular'
  'css!./pan_zoom.less'
], ->

  class PanZoom
    panX: -> @_panX() - @edgeResist*(@withExceededBoundX @excessX)
    panY: -> @_panY() - @edgeResist*(@withExceededBoundY @excessY)

    #without edge resistance
    _panX: -> @_lastPanX + @dDragX()
    _panY: -> @_lastPanY + @dDragY()

    dDragX: -> @_lastMoveX - @_lastTouchX
    dDragY: -> @_lastMoveY - @_lastTouchY

    excessX: (xBound) -> @dDragX() - (xBound - @_lastPanX)
    excessY: (yBound) -> @dDragY() - (yBound - @_lastPanY)

    constructor: () ->
      @panning = false

      @initWidth     = 7000; @initHeight     = 4000
      @viewportWidth = 800 ; @viewportHeight = 679

      @edgeResist = 0.92

      @minZoom = 1/4
      @zoom = 1
      @maxZoom = 1

      @_lastPanX   = 0; @_lastPanY   = 0
      @_lastTouchX = 0; @_lastTouchY = 0
      @_lastMoveX  = 0; @_lastMoveY  = 0

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
        @_lastMoveX = x; @_lastMoveY = y

    minX: -> if @width()  < @viewportWidth  then 0 else @viewportWidth - @width()
    minY: -> if @height() < @viewportHeight then 0 else @viewportHeight - @height()
    maxX: -> if @width()  < @viewportWidth  then @viewportWidth - @width() else 0
    maxY: -> if @height() < @viewportHeight then @viewportHeight - @height() else 0

    width:  -> @initWidth  * @zoom
    height: -> @initHeight * @zoom

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

    onTouch: (event) ->
      if event.button == 1
        @element.addClass 'dragging'
        @panZoom.touch event.pageX, event.pageY
        _document.on 'mousemove', @boundOnMove

    onUntouch: (event) ->
      if event.button == 1
        @element.removeClass 'dragging'
        @panZoom.untouch()
        _document.off 'mousemove'
        @repaint()

    onMove: (event) ->
      @panZoom.move event.pageX, event.pageY
      @repaint()

    onScroll: (event) ->
      @panZoom.scroll (zoomFactor event.originalEvent.deltaY),
                      event.originalEvent.offsetX,
                      event.originalEvent.offsetY
      @repaint()


    repaint: ->
      @element.css '-webkit-transform',
                   transform @panZoom.panX(),
                             @panZoom.panY(),
                             @panZoom.zoom

  zoomInFactor = 2
  zoomOutFactor = 1/2
  zoomFactor = (scrollDelta) ->
    if scrollDelta < 0 then zoomInFactor else zoomOutFactor



  transform = (panX, panY, zoom) ->
    "matrix(#{zoom}, 0, 0, #{zoom}, #{panX}, #{panY})"


  PanZoom: PanZoom
  bindElement: (el) ->
    window.pz = new PanZoomElement(new PanZoom(), el)

