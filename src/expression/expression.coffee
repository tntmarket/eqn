define [
  'angular',
  'text!./expression.html'
  'css!./expression.less'
], (angular, template) ->

  module = angular.module 'expression', []

  module.directive 'expression', () ->
    restrict: 'E'
    template: log template
    transclude: true
    replace: true
    scope: {}

    controller: ($scope) ->
      $scope.select = () ->
        $scope.selected = true
        console.log arguments

      $scope.unselect = () ->
        $scope.selected = false
        console.log arguments

      $scope.selected = false
