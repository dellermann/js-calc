module.exports = (grunt) ->
  grunt.initConfig
    clean:
      build: ['<%= dirs.target.build.base %>']
      demo: ['<%= dirs.target.demo.base %>']
      docs: ['<%= dirs.target.docs %>']
      test: ['<%= dirs.target.test.base %>']
    codo:
      docs:
        dest: '<%= dirs.target.docs %>'
        options:
          name: 'js-calc'
          title: 'js-calc CoffeeScript documentation'
        src: ['<%= dirs.src.coffee %>']
    coffee:
      build:
        files: [
          cwd: '<%= dirs.src.coffee %>/'
          dest: '<%= dirs.target.build.js %>/'
          expand: true
          ext: '.js'
          src: ['*.coffee']
        ]
      demo:
        files:
          '<%= dirs.target.demo.js %>/js-calc.js': [
            '<%= dirs.src.coffee %>/stack.coffee'
            '<%= dirs.src.coffee %>/js-calc.coffee'
            '<%= dirs.src.coffee %>/input.coffee'
          ]
        options:
          join: true
      test:
        files: [
            cwd: '<%= dirs.src.coffee %>/'
            dest: '<%= dirs.target.test.js.scripts %>/'
            expand: true
            ext: '.js'
            src: ['*.coffee']
          ,
            cwd: '<%= dirs.src.test.coffee %>/'
            dest: '<%= dirs.target.test.js.scripts %>/'
            expand: true
            ext: '.js'
            src: ['*.coffee']
        ]
    copy:
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
      test:
        files: [
            cwd: '<%= dirs.src.test.base %>/'
            dest: '<%= dirs.target.test.js.base %>/'
            expand: true
            src: ['*.html']
          ,
            cwd: '<%= dirs.src.bower.qunit %>/qunit/'
            dest: '<%= dirs.target.test.js.css %>/'
            expand: true
            src: 'qunit.css'
          ,
            cwd: '<%= dirs.src.bower.qunit %>/qunit/'
            dest: '<%= dirs.target.test.js.scripts %>/'
            expand: true
            src: 'qunit.js'
          ,
            cwd: '<%= dirs.src.javascript %>/'
            dest: '<%= dirs.target.test.js.scripts %>/'
            expand: true
            src: [
              '_jquery.js'
              '_jquery-ui.js'
              '_jquery-autosize.js'
            ]
          ,
            cwd: '<%= dirs.src.bower.jqueryMockjax %>/'
            dest: '<%= dirs.target.test.js.scripts %>/'
            expand: true
            src: 'jquery.mockjax.js'
          ,
            cwd: '<%= dirs.src.bower.handlebars %>/'
            dest: '<%= dirs.target.test.js.scripts %>/'
            expand: true
            src: 'handlebars.js'
          ,
            cwd: '<%= dirs.src.assets %>/'
            dest: '<%= dirs.target.test.js.base %>/'
            expand: true
            src: 'fonts/**'
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

#          jquery: '<%= dirs.src.bower.base %>/jquery'
#          jqueryMockjax: '<%= dirs.src.bower.base %>/jquery-mockjax'
#          jqueryUi: '<%= dirs.src.bower.base %>/jquery-ui'
#          jqueryUiTouchPunch:
#            '<%= dirs.src.bower.base %>/jquery-ui-touch-punch-working'
#          qunit: '<%= dirs.src.bower.base %>/qunit'
        test:
          base: '<%= dirs.src.base %>/test/js'
          coffee: '<%= dirs.src.test.base %>/coffee'
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

        # TODO
        test:
          base: '<%= dirs.target.base %>/test'
          js:
            base: '<%= dirs.target.test.base %>/javascript'
            css: '<%= dirs.target.test.js.base %>/css'
            scripts: '<%= dirs.target.test.js.base %>/scripts'
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
      test:
        files: [
          cwd: '<%= dirs.src.javascript %>/templates/'
          dest: '<%= dirs.target.test.js.scripts %>/templates/'
          expand: true
          ext: '.js'
          src: ['**/*.hbs']
        ]
    less:
      build:
        files:
          '<%= dirs.target.build.css %>/js-calc.css':
            '<%= dirs.src.less %>/js-calc.less'
      demo:
        files:
          '<%= dirs.target.demo.css %>/js-calc.css':
            '<%= dirs.src.less %>/js-calc.less'
      options:
        path: '<%= dirs.src.less %>/'
      test:
        files:
            '<%= dirs.target.test.js.css %>/_calculator.css': '<%= dirs.src.stylesheet %>/_calculator.less'
    pkg: grunt.file.readJSON 'package.json'
    watch:
      coffee:
        files: [
          '<%= dirs.src.coffee %>/*.coffee'
#          '<%= dirs.src.test.coffee %>/*.coffee'
        ]
        tasks: ['coffee']
      less:
        files: ['<%= dirs.src.less %>/*.less']
        tasks: ['less']
#      testCases:
#        files: ['<%= dirs.src.test.base %>/*.html']
#        tasks: ['copy:test']

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-handlebars'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-codo'

  grunt.registerTask 'default', [
    'clean:build', 'less:build', 'coffee:build', 'handlebars:build'
  ]
  grunt.registerTask 'demo', [
    'clean:demo', 'less:demo', 'coffee:demo', 'handlebars:demo', 'copy:demo'
  ]
  grunt.registerTask 'test', [
    'clean:test', 'less:test', 'coffee:test', 'handlebars:test', 'copy:test'
  ]
  grunt.registerTask 'docs', ['clean:docs', 'codo:docs']

# vim:set ts=2 sw=2 sts=2:

