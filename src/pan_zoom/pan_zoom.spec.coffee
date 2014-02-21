define [
   'pan_zoom/pan_zoom'
], (
   PanZoom
) ->
   describe "PanZoom", ->
      panZoom = null

      touch = null
      move = null
      untouch = null
      scroll = null

      beforeEach ->
         panZoom = new PanZoom.PanZoom()
         touch = panZoom.touch.bind panZoom
         move = panZoom.move.bind panZoom
         untouch = panZoom.untouch.bind panZoom
         scroll = panZoom.scroll.bind panZoom
         minZoom -Infinity
         maxZoom Infinity
         viewport Infinity, Infinity
         size 100, 100

      viewport = (w, h) ->
         panZoom.viewportWidth = w
         panZoom.viewportHeight = h

      size = (w, h) ->
         panZoom.initWidth = w
         panZoom.initHeight = h


      minZoom = (zoom) ->
         panZoom.minZoom = zoom

      maxZoom = (zoom) ->
         panZoom.maxZoom = zoom

      zoomShouldBe = (zoom) ->
         panZoom.zoom.should.equal zoom

      panShouldBe = (x, y) ->
         panZoom.panX().should.equal x
         panZoom.panY().should.equal y

      excessShouldBe = (x, y) ->
         panZoom.excessX().should.equal x
         panZoom.excessY().should.equal y

      panningShouldBe = (touching) ->
         panZoom.panning.should.equal touching


      describe "panning state", ->
         it "should start not panning", ->
            panningShouldBe false

         it "should be panning between touch and untouch", ->
            touch 0, 0
            panningShouldBe true

         it "should not be panning after untouch", ->
            touch 0, 0
            untouch()
            panningShouldBe false

      describe "panning with no zoom", ->
         it "should start at 0,0", ->
            panShouldBe 0, 0

         it "should move while dragging", ->
            touch 0, 0
            move 1, 1
            panShouldBe 1, 1
            move 2, 2
            panShouldBe 2, 2

         it "should move after one drag", ->
            touch 0, 0
            move 10, 1
            move 500, -51
            move 100, 100
            untouch()
            panShouldBe 100, 100

         it "should move when dragging in two drags", ->
            touch 0, 0
            move 50, 50
            untouch()
            touch 0, 0
            move 50, 50
            untouch()
            panShouldBe 100, 100

         it "should not move if it is clicked ", ->
            touch 0, 0
            move 100, 100
            untouch()
            touch 50, 50
            untouch()
            panShouldBe 100, 100

         it "should not move if it wasn't touched", ->
            move 100, 100
            move 100, 100
            panShouldBe 0, 0

         it "should not move if it was released", ->
            touch 0, 0
            move 10, 1
            move 100, 100
            untouch()
            move 100, 100
            panShouldBe 100, 100

      describe "zooming", ->
         it "should start at 1.0 zoom", ->
            zoomShouldBe 1

         it "can zoom in", ->
            scroll 1.2, 0, 0
            zoomShouldBe 1.2
            scroll 1.2, 0, 0
            zoomShouldBe 1.44

         it "can zoom out", ->
            scroll 0.5, 0, 0
            zoomShouldBe 0.5
            scroll 0.5, 0, 0
            zoomShouldBe 0.25

         ###

        -50           0     25    50

    -50   x2──────────┼─────┼─────┼──────────────
          │           ·
          │           ·
          │           ·
          │           ·                           x2   = after zoom in
          │           ·                           x1   = initial box
      0   ┼···········x1························  x0.5 = after zoom out
          │           ·
          │           ·                           •    = scroll pivot
     25   ┼           ·     x0.5────────────────
          │           ·     │
          │           ·     │
     50   ┼           ·     │     •
          │           ·     │
          │           ·     │
          │           ·     │
          │           ·     │
          │           ·     │
          │           ·     │

         ###

         it "should zoom in around the scroll point", ->
            viewport 50, 50
            size 100, 100
            scroll 2, 50, 50
            zoomShouldBe 2
            panShouldBe -50, -50
            scroll 1 / 2, 50, 50
            zoomShouldBe 1
            panShouldBe 0, 0

         it "should zoom out around the scroll point", ->
            scroll 1 / 2, 50, 50
            zoomShouldBe 1 / 2
            panShouldBe 25, 25
            scroll 2, 50, 50
            zoomShouldBe 1
            panShouldBe 0, 0

         it "should not zoom beyond maxZoom", ->
            maxZoom 2
            scroll 3, 0, 0
            zoomShouldBe 1

         it "should not zoom beyond minZoom", ->
            minZoom 1 / 2
            scroll 1 / 3, 50, 50
            zoomShouldBe 1

      describe "Pan boundaries when smaller than viewport", ->
         beforeEach ->
            viewport 100, 100
            size 50, 50

         it "snaps back drags past the top left corner", ->
            touch 0, 0
            move -200, -200
            untouch()
            panShouldBe 0, 0

         it "snaps back drags past the top left corner when zoomed", ->
            scroll 1 / 2, 0, 0
            touch 0, 0
            move -200, -200
            untouch()
            panShouldBe 0, 0

         it "snaps back drags past the bottom right corner", ->
            touch 0, 0
            move 200, 200
            untouch()
            panShouldBe 50, 50

         it "snaps back drags past the bottom right corner when zoomed", ->
            scroll 1 / 2, 0, 0
            touch 0, 0
            move 200, 200
            untouch()
            panShouldBe 75, 75

         it "doesn't drag beyond the top left corner", ->
            touch 0, 0
            move -200, -200
            panShouldBe 0, 0

         it "reports excess when dragging beyond the top left corner", ->
            touch 0, 0
            move -200, -200
            excessShouldBe -200, -200


      describe "Pan boundaries when larger than viewport", ->
         beforeEach ->
            viewport 100, 100
            size 150, 150

         it "snaps back after exposing the top left viewport corner", ->
            touch 0, 0
            move 200, 200
            untouch()
            panShouldBe 0, 0

         it "snaps back after exposing the top left viewport corner when zoomed", ->
            scroll 2, 0, 0
            touch 0, 0
            move 200, 200
            untouch()
            panShouldBe 0, 0

         it "snaps back after exposing the bottom right viewport corner", ->
            touch 0, 0
            move -200, -200
            untouch()
            panShouldBe -50, -50

         it "snaps back after exposing the bottom right viewport corner when zoomed", ->
            scroll 2, 0, 0
            touch 0, 0
            move -300, -300
            untouch()
            panShouldBe -200, -200

         it "doesn't expose the top left corner", ->
            touch 0, 0
            move 200, 200
            panShouldBe 0, 0

         it "reports excess when exposing the top left corner", ->
            touch 0, 0
            move 200, 200
            excessShouldBe 200, 200









