require.config
  paths:
    angular: 'lib/angular'
    MathJax: 'lib/MathJax/MathJax.js?config=TeX-AMS-MML_HTMLorMML'
    text: 'lib/text'
    jquery: 'lib/jquery'
  map:
    '*':
      css: 'lib/require-css/css'
      TweenMax: 'lib/TweenMax'

  shim:
    angular:
      deps: ['jquery']
      exports: 'angular'
    MathJax:
      exports: 'MathJax'
    'MathJax':
      exports: 'Draggable'

require [
  'angular',
  'drag_drop/drag_drop',
  'expression/expression'
  'paper/paper'
  'hud/hud'
  'utils'
], (angular) ->

  app = angular.module 'eqn', [
    'dragDrop',
    'expression',
    'paper',
    'hud'
  ]

  angular.bootstrap document, ['eqn']

  return app
