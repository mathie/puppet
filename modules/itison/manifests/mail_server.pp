class itison::mail_server($rails_env = 'production') {
  class {
    'itison::code':
      rails_env => $rails_env;
  }
}
