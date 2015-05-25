/*
 * server-workflow-scripts
 * Tasks (uses GruntJS)
 *
 * Copyright 2015, Valérian Saliou
 * Author: Valérian Saliou <valerian@valeriansaliou.name>
 */


module.exports = function(grunt) {

  // Project configuration
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),

    // Task BashLint
    bashlint: {
      src: [
        '**/*.sh'
      ]
    }
  });

  // Load plugins
  grunt.loadNpmTasks('grunt-lint-bash');

  // Map tasks
  var GRUNT_TASKS_TEST = {
    all: [['lint',0]]
  };

  var GRUNT_TASKS_LINT = {
    php: [['bashlint',0]]
  };

  // Register tasks
  grunt.registerTask('default', function() {
    return grunt.warn('Usage:' + '\n\n' + 'test - grunt test' + '\n\n');
  });

  grunt.registerTask('test', function() {
    for(t in GRUNT_TASKS_TEST) {
      for(i in GRUNT_TASKS_TEST[t]) {
        grunt.task.run(GRUNT_TASKS_TEST[t][i][0] + (GRUNT_TASKS_TEST[t][i][1] ? (':' + t) : ''));
      }
    }
  });

  grunt.registerTask('lint', function(t) {
    var lint_t_all = [];

    if(t == null) {
      for(t in GRUNT_TASKS_LINT) {
        lint_t_all.push(t);
      }
    } else if(typeof GRUNT_TASKS_LINT[t] != 'object') {
      return grunt.warn('Invalid lint target name.\n');
    } else {
      lint_t_all.push(t);
    }

    for(c in lint_t_all) {
      t = lint_t_all[c];

      for(i in GRUNT_TASKS_LINT[t]) {
        grunt.task.run(GRUNT_TASKS_LINT[t][i][0] + (GRUNT_TASKS_LINT[t][i][1] ? (':' + t) : ''));
      }
    }
  });

};
