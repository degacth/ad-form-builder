var gulp = require("gulp")
    , karma_server = require('karma').Server
    , base_dir = __dirname

gulp.task("test", function () {
    new karma_server({
        configFile: base_dir + '/karma.conf.js',
        singleRun: true
    }).start();
})
