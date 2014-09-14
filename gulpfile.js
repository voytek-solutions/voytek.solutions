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

gulp.task('html', function() {
    gulp.src('site/**/*.page')
    .pipe($.size({title: 'styles:scss'}))
    .pipe($.spawn({
        cmd: "php",
        args: [
            "displayService.phar",
            "ds:generate",
            "--source=/",
            "--output=/Users/wojtek/workspace/voytech.io/out/",
        ]
    }))
    .on('error', function(err) { console.error('Display Service Error'); console.error(err) })
    .on('end', function(err) { console.log('Display Service Done'); })
});

// Prepare Static Page
gulp.task('build', [ 'html', 'styles' ]);

gulp.task('watch', [ 'styles', 'html' ], function() {
    gulp.watch([ 'site/**/*.page' ], [ 'html' ]);
	gulp.watch([ 'styles/**/*.scss' ], [ 'styles' ]);
});

gulp.on('error', function() {
    console.error('Error');

});
