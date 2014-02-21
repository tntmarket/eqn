define [
   'angular'
   './expression.js'
], (
   angular
) ->
   describe "An expression", ->
      it "selects when left clicked", ->
         2.should.equal 2

      it "doesn't select when right or middle clicked", ->
         2.should.equal 2

      it "is deselected when selecting a different one", ->
         2.should.equal 2

      it "is deleted when blurred and empty", ->
         2.should.equal 2

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

