define [
  'angular',
  'text!./paper.html'
  'css!./paper.less'
], (angular, template) ->

  module = angular.module 'paper', []

  module.directive 'paper', () ->
    restrict: 'E'
    template: log template
    transclude: true
    replace: true
    scope: {}

    controller: ($scope) ->
      $scope.select = () ->
        $scope.selected ^= true
        console.log arguments

      $scope.selected = false
