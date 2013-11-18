define [
  'angular'
  'pan_zoom/pan_zoom'
  'text!./paper.html'
  'css!./paper.less'
], (angular, PanZoom, template) ->

  module = angular.module 'paper', []

  module.directive 'paper', () ->
    restrict: 'E'
    template: template
    transclude: true
    replace: true
    scope: {}
    link: (scope, el) ->
      PanZoom.bindElement el

    controller: ($scope) ->
      $scope.select = () ->
        $scope.selected ^= true

      $scope.selected = false
