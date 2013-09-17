outType =
  coffee: 'js'
  jade: 'html'
  less: 'less.css' # keeps webstorm's requirejs file following happy

devConfig = (inType) ->
  expand: true
  cwd: 'dev/src'
  src: ["**/*.#{inType}", '!lib/**']
  dest: 'dev'
  ext: ".#{outType[inType]}"

module.exports = (grunt) ->
  initConfig =
    pkg: grunt.file.readJSON('package.json')

    coffee:
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
        src: 'src/lib'
        dest: 'dev/lib'
      source:
        src: 'src'
        dest: 'dev/src'

    shell:
      makeAngular:
        command: 'npm install && grunt package'
        options:
          execOptions:
            cwd: 'src/lib/angular-latest'
      makeBootstrapUi:
        command: 'npm install && grunt'
        options:
          execOptions:
            cwd: 'src/lib/bootstrap-ui'

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
  grunt.registerTask('default', 'compile dev files', ['symlink', 'coffee', 'less', 'jade'])
  grunt.registerTask('deps', 'compile bower dependencies', ['shell'])
