/* jshint node: true */
'use strict';
require('coffee-script/register');

var
  gulp = require('gulp'),
  jasmine = require('gulp-jasmine'),
  reporters = require('jasmine-reporters');

gulp.task('test', function(){
  return gulp.src('test/**/*Spec.{js,coffee}')
    .pipe(jasmine({
      reporter: new reporters.TerminalReporter()
    }));
});

gulp.task('watch', function(){
  gulp.watch([
    'test/**/*Spec.{js,coffee}',
    'src/**/*.{js,coffee}'
  ], ['test']);
});

gulp.task('default', ['test', 'watch']);
