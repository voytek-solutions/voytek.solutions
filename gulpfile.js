'use strict';

var gulp = require('gulp');
var $ = require('gulp-load-plugins')();

// Compile Sass Files
gulp.task('styles:scss', function () {
  return gulp.src('styles/sass/main.scss')
    .pipe($.rubySass({
      style: 'compressed',
      precision: 10,
      loadPath: ['styles/sass']
    }))
    .on('error', console.error.bind(console))
    .pipe(gulp.dest('build/out/static/styles/css'))
    .pipe($.size({title: 'styles:scss'}));
});

// Output Final CSS Styles
gulp.task('styles', ['styles:scss']);

// Prepare Static Page
gulp.task('build', ['styles']);
