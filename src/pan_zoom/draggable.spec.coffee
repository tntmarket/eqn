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

      beforeEach ->
         moveTo = sinon.spy()
         Draggable.setBounds 1000, 1000
         draggable = new Draggable.Draggable moveTo

      it "should call moveTo with x and y on drop", ->
         draggable.touch 10, 10
         draggable.drop 100, 100
         moveTo.should.have.been.calledOnce
         moveTo.should.have.been.calledWith 90, 90

      it "should call moveTo with boundaries on drop beyond bottom right", ->
         draggable.touch 0, 0
         draggable.drop 1001, 1001
         moveTo.should.have.been.calledOnce
         moveTo.should.have.been.calledWith 1000, 1000

      it "should call moveTo with 0, 0 on drop beyond top left", ->
         draggable.touch 0, 0
         draggable.drop -5, -5
         moveTo.should.have.been.calledOnce
         moveTo.should.have.been.calledWith 0, 0

