define [
   'angular'
   './draggable.js'
], (
   angular
   Draggable
) ->
   describe "A Draggable", ->
      draggable = null
      moveTo = null
      panZoom =
         zoom: 1
         initWidth: 1000
         initHeight: 1000

      beforeEach ->
         moveTo = sinon.spy()
         draggable = new Draggable.Draggable panZoom, moveTo

      it "should call moveTo with x and y on drop", ->
         draggable.touch 10, 10
         draggable.drop 100, 100
         moveTo.should.have.been.calledOnce
         moveTo.should.have.been.calledWith 90, 90

      it "shouldn't call moveTo on drop out of bounds", ->
         draggable.touch 0, 0
         draggable.drop 1001, 1001
         moveTo.should.not.have.been.called

      it "should call moveTo with x and y on drop while zoomed", ->
         panZoom.zoom = 1/2
         draggable.touch 5, 5
         draggable.drop 50, 50
         moveTo.should.have.been.calledOnce
         moveTo.should.have.been.calledWith 90, 90

      it "shouldn't call moveTo on drop out of bounds while zoomed", ->
         panZoom.zoom = 1/2
         draggable.touch 0, 0
         draggable.drop 501, 501
         moveTo.should.not.have.been.called


