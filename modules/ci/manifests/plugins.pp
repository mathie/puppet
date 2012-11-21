class ci::plugins {
  jenkins::plugin {
    [ 'git', 'rake', 'rubyMetrics',
      'github', 'github-api', 'github-oauth',
      'gravatar', 'ansicolor',
      'xvfb',
      'greenballs',
      'compact-columns', 'dashboard-view', 'project-stats-plugin',
      'configurationslicing', 'timestamper'
    ]: ;
  }
}
