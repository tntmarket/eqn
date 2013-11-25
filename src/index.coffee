require.config
  paths:
    angular: 'lib/angular'
#    MathJax: 'lib/MathJax/MathJax.js?config=TeX-AMS-MML_HTMLorMML'
    text: 'lib/text'
#    jquery: 'lib/jquery'
  map:
    '*':
      css: 'lib/require-css/css'
#      TweenMax: 'lib/TweenMax'

  shim:
    angular:
      exports: 'angular'
#      deps: ['jquery']
#    MathJax:
#      exports: 'MathJax'

require [
  'angular',
  'expression/expression'
  'paper/paper'
  'hud/hud'
  'globals'
], (angular) ->

  app = angular.module 'eqn', [
    'expression',
    'paper',
    'hud'
  ]

#  addEventListener 'beforeunload', -> 'GTFO?'

  angular.bootstrap document, ['eqn']

  return app
