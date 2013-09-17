require.config(
  paths:
    'angular': 'lib/angular-latest/build/angular'
    'angularui': 'lib/bootstrap-ui/dist/ui-bootstrap-tpls-0.6.0'
    'MathJax': 'lib/MathJax/unpacked/MathJax.js?config=TeX-AMS-MML_HTMLorMML'
  map:
    '*':
      'css': 'lib/require-css/css'
  shim:
    'angular':
      exports: 'angular'
    'angularui':
      deps: ['angular']
    'MathJax':
      exports: 'MathJax'
)

require(
  ['angular',
   'angularui',
   'MathJax',
   'Main/ctrl'],
(angular, angularui, MathJax, MainCtrl) ->

  MathJax.Hub.Config(
    extensions: ['tex2jax.js']
    jax: ['input/TeX', 'output/HTML-CSS']
    tex2jax:
      inlineMath: [
        ['$', '$']
      ]
    messageStyle: 'none'
    showMathMenu: false
  )

  initialize = ($routeProvider, $locationProvider) ->
    $routeProvider.when('/',
      templateUrl: 'Main/view.html'
      controller: MainCtrl
    )

    $routeProvider.otherwise({ redirectTo: '/' })

    $locationProvider.html5Mode(true);

  app = angular.module('eqn', ['ui.bootstrap'], initialize)

  angular.bootstrap(document, ['eqn'])

  return app
)
