var gulp = require("gulp")
    , $ = require("gulp-load-plugins")({lazy: true})
    , karma_server = require("karma").Server
    , base_dir = __dirname

gulp.task("compile", function(){
    gulp.src(base_dir + "/app/app.coffee")
        .pipe($.coffeeify())
        .pipe($.uglify())
        .pipe(gulp.dest(base_dir + "/build/"))
})

gulp.task("test", function(){
    new karma_server({
        configFile: base_dir + "/karma.conf.js",
        singleRun: true
    }).start();
})

gulp.task("watch", ["compile"], function(){
    gulp.watch([base_dir + "/app/**/*.coffee"], ["compile"])
})
