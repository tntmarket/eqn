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


  module.service 'uid', ->
    counter = 100
    getUid = -> (counter += 1)


  module.directive 'paper', (paper) ->
    restrict: 'C'
    link: (scope, el) ->
      viewport = (angular.element document.body)[0]
      el.css 'width', viewport.offsetWidth*4 + 'px'
      el.css 'height', viewport.offsetHeight*4 + 'px'

      panZoom = (PanZoom.bindElement el).panZoom
      paper.setPanZoom panZoom
      Draggable.setPaper el

    controller: ($scope, paper, uid) ->
      $scope.expressions =
        1:
          x: 100
          y: 100
          src: '-0 = 0'
          id: 1
        2:
          x: 200
          y: 200
          src: 'F = -kx'
          id: 2
        3:
          x: 300
          y: 300
          src: 'z = sqrt(133)'
          id: 3
        4:
          x: 400
          y: 400
          src: 'a^2 + b^2 = c^2'
          id: 4
        5:
          x: 500
          y: 500
          src: 'sin(2t) = 2 sin(t) cos(t)'
          id: 5

      $scope.newItem = (event) ->
        id = uid()
        $scope.expressions[id] =
          x: (event.pageX)/paper.getZoom() - 8
          y: (event.pageY)/paper.getZoom() - 17
          src: ''
          id: id
          focus: true

      $scope.deleteItem = (index) -> delete $scope.expressions[index]

      $scope.unselectAll = paper.unselectAll.bind paper

      this.deleteItem = $scope.deleteItem

      return


