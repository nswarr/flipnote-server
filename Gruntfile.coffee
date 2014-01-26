"use strict"
app = "app/"
build = "build/"
module.exports = (grunt) ->
  require("time-grunt") grunt
  require("load-grunt-tasks") grunt
  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")

    watch:
      options:
        nospawn: true

      coffee:
        files: [ app + "**/*.coffee" ]
        tasks: [ "coffee:dist" ]

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

  grunt.registerTask "default", [ "build", "watch"]
  grunt.registerTask "prod", [ "build", "forever:restart"]
  grunt.registerTask "build", [ "clean:dist", "coffee:dist", "copy:dist" ]