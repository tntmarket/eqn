define [
  'angular'
  'pan_zoom/pan_zoom'
  'pan_zoom/draggable'
  'css!./paper.less'
], (angular, PanZoom, Draggable) ->

  module = angular.module 'paper', []

  module.service 'paper', ->
    this.setPanZoom = (panZoom) -> this.panZoom = panZoom
    this.getZoom = -> this.panZoom.zoom

    itemScopes = []
    unselect = (itemScope) -> itemScope.unselect()
    this.registerItem = (itemScope) -> itemScopes.push itemScope
    this.unselectAll = -> itemScopes.forEach unselect

    return


  module.directive 'paper', (paper) ->
    restrict: 'C'
    link: (scope, el) ->
      viewport = (angular.element document.body)[0]
      el.css 'width', viewport.offsetWidth*4 + 'px'
      el.css 'height', viewport.offsetHeight*4 + 'px'

      panZoom = (PanZoom.bindElement el).panZoom
      paper.setPanZoom panZoom
      Draggable.setPaper el

    controller: ($scope, paper) ->
      $scope.expressions = [
          x: 100
          y: 100
          src: '-0 = 0'
        ,
          x: 200
          y: 200
          src: 'F = -kx'
        ,
          x: 300
          y: 300
          src: 'z = sqrt(133)'
        ,
          x: 400
          y: 400
          src: 'a^2 + b^2 = c^2'
        ,
          x: 500
          y: 500
          src: 'sin(2t) = 2 sin(t) cos(t)'
      ]

      $scope.newItem = (event) ->
        $scope.expressions.push
          x: (event.pageX)/paper.getZoom() - 8
          y: (event.pageY)/paper.getZoom() - 17
          src: ''
          focus: true

      $scope.deleteItem = (index) -> $scope.expressions.splice index, 1

      $scope.unselectAll = paper.unselectAll.bind paper

      this.deleteItem = $scope.deleteItem

      return


