do ->
  tests = []

  for own file of window.__karma__.files
    if /\.spec\.js$/.test file
      tests.push file

  alwaysNeeded = ['angular', 'mocks', 'globals']

  require.config
    baseUrl: '/base'

    paths:
      angular: 'lib/angular'
      mocks: 'lib/angular-mocks'
      text: 'lib/text'
      globals: 'globals'
    map:
      '*':
        css: 'lib/require-css/css'
    shim:
      angular:
        exports: 'angular'
      mocks:
        deps: ['angular']

    deps: tests.concat alwaysNeeded

    callback: window.__karma__.start
