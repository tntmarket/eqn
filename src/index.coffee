require.config
   paths:
      angular: 'lib/angular'
      text: 'lib/text'
   map:
      '*':
         css: 'lib/require-css/css'

   shim:
      angular:
         exports: 'angular'

require [
   'angular'
   'expression/expression'
   'paper/paper'
   'globals'
], (
   angular
) ->
   app = angular.module 'eqn', [
      'expression'
      'paper'
   ]

   app.controller 'MainCtrl', ($scope) ->
      $scope.expressions =
         0:
            x: 100
            y: 100
            src: '-0 = 0'
            id: 0
         1:
            x: 200
            y: 200
            src: 'F = -kx'
            id: 1

   #  addEventListener 'beforeunload', -> 'GTFO?'

   angular.bootstrap document, ['eqn']

   return app
