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

   #  addEventListener 'beforeunload', -> 'GTFO?'

   angular.bootstrap document, ['eqn']

   return app
