define [
   'angular'
   'pan_zoom/draggable'
   'focus/focus'
   'text!./expression.html'
   'css!./expression.less'
], (
   angular
   Draggable
   Focus
   template
) ->
   module = angular.module 'expression', ['paper']

   isBlank = (str) -> !str or !str.match /\S/

   module.directive 'expression', ->
      restrict: 'E'
      require: '^paper'
      template: template
      replace: true
      scope:
         model: '='

      link: (scope, _, __, paperCtrl) ->
         scope.select = (leftClick) ->
            if not scope.editing and leftClick
               paperCtrl.unselectAll()
               scope.selected = true

         scope.deselect = ->
            scope.selected = false
            scope.editing = false
         paperCtrl.registerDeselector scope.deselect

         scope.deleteIfEmpty = ->
            if isBlank scope.model.src
               paperCtrl.deleteItem scope.model.id

         scope.selected = false
         scope.editing = scope.model.focus or false


   module.directive 'draggable', (paperSizes) ->
      restrict: 'A'
      link: (scope, el) ->
         Draggable.bindElement el, paperSizes, (x, y) ->
            scope.$apply ->
               scope.model.x = x
               scope.model.y = y

   ENTER_KEY = 13
   module.directive 'editable', (paperSizes, $timeout) ->
      restrict: 'A'
      require: 'ngModel'
      link: (scope, el, attr, ngModel) ->
         ngModel.$render = ->
            el.html (ngModel.$viewValue || '')

         el.on 'blur keyup change', ->
            scope.$apply ->
               ngModel.$setViewValue el.html()

         el.on 'blur', ->
            el.attr 'contenteditable', false
            scope.$apply ->
               scope[attr.editable] = false

         el.on 'keydown', (event) ->
            if event.keyCode == ENTER_KEY
               event.preventDefault()
               el[0].blur()

         el.on 'dblclick', (event) ->
            event.stopPropagation()
            if not scope[attr.editable] and event.button == 0
               el.attr 'contenteditable', true
               scope.$apply ->
                  scope[attr.editable] = true
               Focus.whereClicked el, event.offsetX, paperSizes.zoom()

         if scope.model.focus
            el.attr 'contenteditable', true
            $timeout ->
               Focus.firstChar el
            , 0

