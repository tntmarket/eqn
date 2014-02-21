define [
   'angular'
   'mocks'
   'expression/expression'
], (
   angular
) ->
   describe "An expression", ->

      beforeEach ->
         module 'paper'
         module 'expression'

      scope = null
      expressionEls = null
      paperEl = null

      beforeEach inject ($rootScope, $compile) ->
         paperEl = $ '
            <paper>
               <expression ng-repeat="expression in expressions"
                           model="expression"></expression>
            </paper>
         '
         scope = $rootScope.$new()
         scope.expressions =
            0:
               x: 100
               y: 100
               src: 'First Expression'
               id: 0
            1:
               x: 200
               y: 200
               src: 'Second Expression'
               id: 1
         ($compile paperEl) scope
         scope.$digest()
         expressionEls = paperEl.find '.expression'

      it "selects when left or right clicked", ->
         expressionEls.eq(0).trigger {type: 'mousedown', button: 0}
         expressionEls.eq(0).isolateScope().selected.should.equal true
         expressionEls.eq(0).trigger {type: 'mousedown', button: 2}
         expressionEls.eq(0).isolateScope().selected.should.equal true

      it "doesn't select when middle clicked", ->
         expressionEls.eq(0).trigger {type: 'mousedown', button: 1}
         expressionEls.eq(0).isolateScope().selected.should.equal false

      it "deselects when selecting a different one", ->
         expressionEls.eq(0).trigger {type: 'mousedown', button: 0}
         expressionEls.eq(1).trigger {type: 'mousedown', button: 0}
         expressionEls.eq(0).isolateScope().selected.should.equal false
         expressionEls.eq(1).isolateScope().selected.should.equal true

      it "deselects when clicking the paper", ->
         expressionEls.eq(0).trigger {type: 'mousedown', button: 0}
         paperEl.click()
         expressionEls.eq(0).isolateScope().selected.should.equal false

      it "deletes when empty", ->
         scope.expressions[1].src = ' '
         scope.$apply()
         expressionEls.eq(1).trigger {type: 'blur'}
         should.not.exist scope.expressions[1]

   describe "The editable attribute", ->
      it "is uneditable initially", ->
         2.should.equal 2

      it "is editable on double click", ->
         2.should.equal 2

      it "is uneditable on blur", ->
         2.should.equal 2

      it "sets contenteditable to the value of the variable specified", ->
         2.should.equal 2

      it "syncs the ng-model with its contents", ->
         2.should.equal 2

