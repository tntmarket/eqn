define [
  'angular'
  'pan_zoom/draggable'
  'text!./expression.html'
  'css!./expression.less'
], (angular, Draggable, template) ->

  module = angular.module 'expression', []

  module.directive 'expression', (paper) ->
    restrict: 'E'
    template: template
    replace: true
    scope:
      equation: '='
      x: '='
      y: '='

    link: (scope, el) ->
      paper.addItem scope

      Draggable.bindElement el, scope.x, scope.y, paper.panZoom

      scope.select = (leftClick) ->
        if not scope.editing and leftClick
          paper.unselectAll()
          scope.selected = true


    controller: ($scope) ->
      $scope.unselect = ->
        $scope.selected = false
        $scope.editing = false

      $scope.edit = (event) ->
        if not $scope.editing and event.button == 0
          log event.offsetX
          $scope.editing = true

      $scope.selected = false
      $scope.editing = false


  module.directive 'editable', ->
    restrict: 'A'
    link: (scope, el, attr) ->
      el.attr 'spellcheck', false

      el.on 'keydown', (event) ->
        if event.keyCode == 13
          event.preventDefault()
          scope.$apply attr.submit

      scope.$watch attr.model, (model) ->
        el.text model

      scope.$watch attr.editable, (editable) ->
        el.attr 'contenteditable', editable
        if editable
          el[0].focus()
        else
          scope[attr.model] = el.text()

