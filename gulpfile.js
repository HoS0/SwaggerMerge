/* jshint node: true */
'use strict';

require('coffee-script/register');
const istanbul = require('gulp-istanbul')
const eslint = require('gulp-eslint')
const mocha = require('gulp-mocha')
const gulp = require('gulp')
const jasmine = require('gulp-jasmine')
const reporters = require('jasmine-reporters')

gulp.task('pre-test', function() {
  return gulp.src(['src/*.js'])
    .pipe(istanbul())
    .pipe(istanbul.hookRequire())
})

gulp.task('cover', ['pre-test'], function() {
  return gulp.src('test/**/*Spec.{js,coffee}')
  .pipe(jasmine())
  .pipe(istanbul.writeReports())
})

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
