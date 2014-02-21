define [
   'angular'
   'mocks'
   './paper.js'
], (
   angular
) ->
   describe "The paper", ->
      beforeEach module 'paper'

      scope = null
      ctrl = null

      beforeEach inject ($rootScope, $controller) ->
         scope = $rootScope.$new()
         ctrl = $controller 'PaperCtrl', $scope: scope

      it "can create new expressions", ->
         itemId = scope.newItem 0, 0
         scope.expressions[itemId].src.should.equal ' '
