define [
   'angular',
   'text!./hud.html'
   'css!./hud.less'
], (
   angular,
   template
) ->
   module = angular.module 'hud', []

   module.directive 'hud', ->
      restrict: 'E'
      template: log template
      replace: true
      scope: {}
