sourcePaths = (extension) ->
  ["**/*.#{extension}", '!lib/**']

outType =
  coffee: 'js'
  jade: 'html'
  less: 'css'

devConfig = (inType) ->
  expand: true
  cwd: 'app'
  src: sourcePaths(inType)
  dest: 'dev/app'
  ext: ".#{outType[inType]}"

module.exports = (grunt) ->
  initConfig =
    pkg: grunt.file.readJSON('package.json')

    coffee:
      server:
        options:
          sourceMap: false
          bare: true
        files:
          'dev/server.js': 'server.coffee'
      dev: devConfig('coffee')
      options:
        sourceMap: true

    less:
      dev: devConfig('less')

    jade:
      dev: devConfig('jade')
      options:
        pretty: true

    symlink:
      bower:
        src: 'app/lib'
        dest: 'dev/app/lib'

    shell:
      makeAngular:
        command: 'npm install && grunt package'
        options:
          execOptions:
            cwd: 'app/lib/angular-latest'
      makeBootstrapUi:
        command: 'npm install && grunt'
        options:
          execOptions:
            cwd: 'app/lib/bootstrap-ui'

    clean: ['dev']

  # Configuration goes here
  grunt.initConfig(initConfig)

  # Load plugins here
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-less')
  grunt.loadNpmTasks('grunt-contrib-jade')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-contrib-symlink')
  grunt.loadNpmTasks('grunt-shell')

  # Define your tasks here
  grunt.registerTask('default', 'compile dev files', ['coffee', 'less', 'jade', 'symlink'])
  grunt.registerTask('deps', 'compile bower dependencies', ['shell'])
