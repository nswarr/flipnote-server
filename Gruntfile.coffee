"use strict"
app = "app/"
build = "build/"
module.exports = (grunt) ->
  require("time-grunt") grunt
  require("load-grunt-tasks") grunt
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    develop:
      server:
        file: build + "app.js"

    watch:
      options:
        nospawn: true

      coffee:
        files: [ app + "**/*.coffee" ]
        tasks: [ "coffee:dist" ]

      server:
        files: [ build + "**/*.*", build + "routes/*.js" ]
        tasks: [ "develop" ]

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

    forever:
      options:
        index: build + "app.js"
        logDir: "logs"

  grunt.registerTask "default", [ "build", "develop", "watch" ]
  grunt.registerTask "ide", [ "build", "watch" ]
  grunt.registerTask "build", [ "clean:dist", "coffee:dist", "copy:dist" ]