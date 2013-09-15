sourcePaths = (extension) ->
  ["app/**/*.#{extension}", "!app/lib/**"]

getExtension = (filename) ->
  [paths..., extension] = filename.split('.')
  return extension

outType =
  coffee: 'js'
  jade: 'html'
  less: 'css'

devConfig = (inType) ->
  expand: true
  cwd: 'app'
  src: sourcePaths(inType)
  dest: 'app'
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

    shell:
      makeAngular:
        command: "grunt package"
        options:
          execOptions:
            cwd: 'app/lib/angular-latest'
      makeBootstrapUi:
        command: "grunt"
        options:
          execOptions:
            cwd: 'app/lib/bootstrap-ui'

    clean: ["app/**/*.js", "app/**/*.html", "app/**/*.css", "!lib/**"]

  # Configuration goes here
  grunt.initConfig(initConfig)

  # Load plugins here
  grunt.loadNpmTasks('grunt-contrib-coffee')
  grunt.loadNpmTasks('grunt-contrib-less')
  grunt.loadNpmTasks('grunt-contrib-jade')
  grunt.loadNpmTasks('grunt-contrib-clean')
  grunt.loadNpmTasks('grunt-shell')

  # Define your tasks here
  grunt.registerTask('default', 'compile dev files', ['coffee', 'less', 'jade'])
  grunt.registerTask('deps', 'compile bower dependencies', ['shell'])
  grunt.registerTask('clean', 'clean compiled dev files', ['clean'])
