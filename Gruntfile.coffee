"use strict"
request = require("request")
app = "app/"
build = "build/"
module.exports = (grunt) ->
  require("time-grunt") grunt
  require("load-grunt-tasks") grunt
  reloadPort = 35729
  files = undefined
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    develop:
      server:
        file: build + "app.js"

    watch:
      options:
        nospawn: true
        livereload: reloadPort

      server:
        files: [ build + "app.js", build + "routes/*.js" ]
        tasks: [ "develop", "delayed-livereload" ]

      coffee:
        files: [ app + "**/*.coffee" ]
        tasks: [ "coffee:dist" ]

      js:
        files: [ "public/js/*.js" ]
        options:
          livereload: reloadPort

      css:
        files: [ "public/css/*.css" ]
        options:
          livereload: reloadPort

      jade:
        files: [ "views/*.jade" ]
        options:
          livereload: reloadPort

    coffee:
      dist:
        files: [
          expand: true
          cwd: app
          src: "**/*.coffee"
          dest: build
          ext: ".js"
        ]

    copy:
      dist:
        files: [
          expand: true
          dot: true
          cwd: app
          dest: build
          src: [ "public/**/*.*", "views/**/*.*" ]
        ]

    clean:
      dist:
        files: [
          dot: true
          src: [ build + "**" ]
        ]

  grunt.config.requires "watch.server.files"
  files = grunt.config("watch.server.files")
  files = grunt.file.expand(files)
  grunt.registerTask "delayed-livereload", "Live reload after the node server has restarted.", ->
    done = @async()
    setTimeout (->
      request.get "http://localhost:" + reloadPort + "/changed?files=" + files.join(","), (err, res) ->
        reloaded = not err and res.statusCode is 200
        if reloaded
          grunt.log.ok "Delayed live reload successful."
        else
          grunt.log.error "Unable to make a delayed live reload."
        done reloaded
    ), 500

  grunt.registerTask "default", [ "build", "develop", "watch" ]
  grunt.registerTask "build", [ "clean:dist", "coffee:dist", "copy:dist" ]