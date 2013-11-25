outType =
  coffee: 'js'
  jade: 'html'
  less: 'less.css' # keeps webstorm's requirejs file following happy

developmentBuild = (inType) ->
  expand: true
  cwd: 'dev/src'
  src: ["**/*.#{inType}"]
  dest: 'dev'
  ext: ".#{outType[inType]}"

module.exports = (grunt) ->
  initConfig =
    pkg: grunt.file.readJSON 'package.json'

    coffee:
      dev: developmentBuild 'coffee'
      options:
        sourceMap: true

    less:
      dev: developmentBuild 'less'

    jade:
      dev: developmentBuild 'jade'
      options:
        pretty: true

    symlink:
      bower:
        src: 'src/lib'
        dest: 'dev/lib'
      source:
        src: 'src'
        dest: 'dev/src' # for source maps

    shell:
      makeAngular:
        command: 'npm install && grunt package'
        options:
          execOptions:
            cwd: 'lib/angular-latest'

    clean: ['dev']

  # Configuration goes here
  grunt.initConfig initConfig

  # Load plugins here
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-symlink'
  grunt.loadNpmTasks 'grunt-shell'

  # Define your tasks here
  grunt.registerTask 'default', 'compile dev files', ['symlink', 'coffee', 'less', 'jade']
