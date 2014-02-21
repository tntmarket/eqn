define [
   'angular'
   'mocks'
   'paper/paper'
], (
   angular
) ->
   describe "The paper", ->
      beforeEach module 'paper'

      scope = null
      ctrl = null

      beforeEach inject ($rootScope, $controller) ->
         scope = $rootScope.$new()
         scope.expressions = {}
         ctrl = $controller 'PaperCtrl', $scope: scope

      it "can create new expressions", ->
         expressionId = scope.newItem 0, 0
         scope.expressions[expressionId].should.exist

      it "can unselect all expressions", ->
         ctrl.registerDeselector (deselect1 = sinon.spy())
         ctrl.registerDeselector (deselect2 = sinon.spy())
         ctrl.deselectAll()
         deselect1.should.have.been.calledOnce
         deselect2.should.have.been.calledOnce

      it "can unselect all expressions from the scope", ->
         ctrl.registerDeselector (deselect1 = sinon.spy())
         ctrl.registerDeselector (deselect2 = sinon.spy())
         scope.deselectAll()
         deselect1.should.have.been.calledOnce
         deselect2.should.have.been.calledOnce

      it "can delete an expression", ->
         expressionId = scope.newItem 0, 0
         ctrl.deleteById expressionId
         should.not.exist scope.expressions[expressionId]
