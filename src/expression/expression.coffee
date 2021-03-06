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

   LEFT_CLICK = 0
   RIGHT_CLICK = 2
   module.controller 'ExpressionCtrl', ($scope) ->
      $scope.selected = false

      $scope.select = (mouseButton) ->
         if not $scope.editing and (mouseButton == LEFT_CLICK or
                                    mouseButton == RIGHT_CLICK)
            $scope.deselectAll()
            $scope.selected = true

      $scope.deselect = ->
         $scope.selected = false
         $scope.editing = false

      $scope.deleteIfEmpty = ->
         window.x = $scope.model.src
         if isBlank $scope.model.src.replace (/&nbsp;/g), ''
            $scope.deleteThis()

      $scope.editing = $scope.model.focus or false

   module.directive 'expression', ->
      restrict: 'E'
      require: '^paper'
      template: template
      replace: true
      scope:
         model: '='
      controller: 'ExpressionCtrl'
      link: (scope, _, __, paperCtrl) ->
         paperCtrl.registerDeselector scope.deselect
         scope.deselectAll = paperCtrl.deselectAll
         scope.deleteThis = paperCtrl.deleteById.bind paperCtrl, scope.model.id


   module.directive 'draggable', ->
      restrict: 'A'
      link: (scope, el) ->
         Draggable.bindElement el, (x, y) ->
            scope.$apply ->
               scope.model.x = x
               scope.model.y = y

   ENTER_KEY = 13
   module.directive 'editable', ($timeout) ->
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
               Focus.whereClicked el, event.offsetX

         if scope.model.focus
            el.attr 'contenteditable', true
            $timeout ->
               Focus.firstChar el
            , 0

