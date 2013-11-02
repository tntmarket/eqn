define [
  'angular'
  'TweenMax/Draggable',
  'TweenMax/TweenMax',
  'TweenMax/CSSPlugin'
], (angular) ->

  module = angular.module 'dragDrop', []

  module.directive 'pannable', ($window) ->
    viewPort = $($window)

    (scope, element) ->
      Draggable.create element,
        type: 'x,y'
        edgeResistance: 0.95
        zIndexBoost: false
        force3D: false
        cursor: 'default'
        bounds:
          minX: 0
          maxX: viewPort.width() - element.width()
          minY: 0
          maxY: viewPort.height() - element.height()

