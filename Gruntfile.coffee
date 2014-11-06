banner = '''
  /* <%= pkg.name %> v<%= pkg.version %> (<%= grunt.template.today("yyyy-mm-dd") %>)
   *
   * Copyright (c) <%= grunt.template.today("yyyy") %>, AMC World Technologies GmbH
   * Released under MIT License.  See LICENSE for more information.
   */
  '''

module.exports = (grunt) ->
  grunt.initConfig
    bower:
      demo:
        options:
          targetDir: '<%= dirs.bower.base %>/'
    clean:
      build: ['<%= dirs.target.build.base %>']
      demo: ['<%= dirs.target.demo.base %>']
      docs: ['<%= dirs.target.docs %>']
    codo:
      docs:
        dest: '<%= dirs.target.docs %>/api/'
        options:
          name: 'js-calc'
          title: 'js-calc API documentation'
        src: ['<%= dirs.src.coffee %>']
    coffee:
      build:
        files:
          '<%= dirs.target.build.js %>/js-calc.js': [
            '<%= dirs.src.coffee %>/js-calc.coffee'
            '<%= dirs.src.coffee %>/stack.coffee'
            '<%= dirs.src.coffee %>/input.coffee'
          ]
      demo:
        files:
          '<%= dirs.target.demo.js %>/js-calc.js': [
            '<%= dirs.src.coffee %>/js-calc.coffee'
            '<%= dirs.src.coffee %>/stack.coffee'
            '<%= dirs.src.coffee %>/input.coffee'
          ]
      options:
        join: true
        sourceMap: true
    copy:
      build:
        files: [
            cwd: '<%= dirs.src.base %>/'
            dest: '<%= dirs.target.build.base %>/'
            expand: true
            src: ['README.md', 'LICENSE']
        ]
      demo:
        files: [
            cwd: '<%= dirs.src.base %>/'
            dest: '<%= dirs.target.demo.base %>/'
            expand: true
            src: ['demo.html']
          ,
            cwd: '<%= dirs.bower.bootstrap %>/dist/css/'
            dest: '<%= dirs.target.demo.css %>/'
            expand: true
            src: ['bootstrap.css']
          ,
            cwd: '<%= dirs.bower.jquery %>/dist/'
            dest: '<%= dirs.target.demo.js %>/'
            expand: true
            src: ['jquery.js']
          ,
            cwd: '<%= dirs.bower.handlebars %>/'
            dest: '<%= dirs.target.demo.js %>/'
            expand: true
            src: ['handlebars.js']
        ]
    dirs:
      bower:
        base: 'bower_components'
        bootstrap: '<%= dirs.bower.base %>/bootstrap'
        handlebars: '<%= dirs.bower.base %>/handlebars'
        jquery: '<%= dirs.bower.base %>/jquery'
      src:
        base: '.'
        coffee: '<%= dirs.src.base %>/coffee'
        less: '<%= dirs.src.base %>/less'
        templates: '<%= dirs.src.base %>/templates'
      target:
        base: 'target'
        build:
          base: '<%= dirs.target.base %>/build'
          css: '<%= dirs.target.build.base %>/css'
          js: '<%= dirs.target.build.base %>/js'
        demo:
          base: '<%= dirs.target.base %>/demo'
          css: '<%= dirs.target.demo.base %>/css'
          js: '<%= dirs.target.demo.base %>/js'
        docs: '<%= dirs.target.base %>/docs'
    handlebars:
      build:
        files: [
          cwd: '<%= dirs.src.templates %>/'
          dest: '<%= dirs.target.build.js %>/templates/'
          expand: true
          ext: '.js'
          src: ['*.hbs']
        ]
      demo:
        files: [
          cwd: '<%= dirs.src.templates %>/'
          dest: '<%= dirs.target.demo.js %>/templates/'
          expand: true
          ext: '.js'
          src: ['*.hbs']
        ]
      options:
        namespace: 'Handlebars.templates'
        processName: (filePath) ->
          filePath.replace /^templates\/(.+)\.hbs/, '$1'
    less:
      build:
        files:
          '<%= dirs.target.build.css %>/js-calc.css':
            '<%= dirs.src.less %>/js-calc.less'
        options:
          banner: banner
          cleancss: true
          report: true
      demo:
        files:
          '<%= dirs.target.demo.css %>/js-calc.css':
            '<%= dirs.src.less %>/js-calc.less'
      options:
        path: '<%= dirs.src.less %>/'
    markdown:
      build:
        files:
          '<%= dirs.target.build.base %>/README.html':
            '<%= dirs.src.base %>/README.md'
      docs:
        files:
          '<%= dirs.target.docs %>/README.html':
            '<%= dirs.src.base %>/README.md'
      options:
        markdownOptions:
          gfm: true
          highlight: 'manual'
    pkg: grunt.file.readJSON 'package.json'
    uglify:
      build:
        files:
          '<%= dirs.target.build.js %>/js-calc.min.js':
            '<%= dirs.target.build.js %>/js-calc.js'
          '<%= dirs.target.build.js %>/templates/js-calc.min.js':
            '<%= dirs.target.build.js %>/templates/js-calc.js'
        options:
          banner: banner
          sourceMap: true
          sourceMapName: (path) -> path + '.map'
    watch:
      coffee:
        files: ['<%= dirs.src.coffee %>/*.coffee']
        tasks: ['coffee']
      less:
        files: ['<%= dirs.src.less %>/*.less']
        tasks: ['less']

  grunt.loadNpmTasks 'grunt-bower-task'
  grunt.loadNpmTasks 'grunt-codo'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-handlebars'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-markdown'

  grunt.registerTask 'default', [
    'clean:build', 'less:build', 'coffee:build', 'handlebars:build',
    'uglify:build', 'copy:build', 'markdown:build', 'docs'
  ]
  grunt.registerTask 'demo', [
    'bower:demo', 'clean:demo', 'less:demo', 'coffee:demo', 'handlebars:demo',
    'copy:demo'
  ]
  grunt.registerTask 'docs', ['clean:docs', 'codo:docs', 'markdown:docs']

# vim:set ts=2 sw=2 sts=2:

