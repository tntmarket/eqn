do ->
   tests = []

   for own file of window.__karma__.files
      if /\.spec\.js$/.test file
         tests.push file

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

      deps: tests.concat 'globals'

      callback: window.__karma__.start
