define [
  'angular',
  'text!./expression.html'
  'css!./expression.less'
], (angular, template) ->

  module = angular.module 'expression', []

  module.directive 'expression', () ->
    restrict: 'E'
    template: template
    transclude: true
    replace: true
    scope: {}

    controller: ($scope) ->
      $scope.select = () ->
        $scope.selected = true
        arguments

      $scope.unselect = () ->
        $scope.selected = false
        arguments

      $scope.selected = false
