# I'm assuming it's only me that's using guard, really.
notification :tmux,
  :display_message       => true,
  :line_separator        => ' | ',
  :default               => 'white',
  :success               => 'white',
  :failed                => 'brightred',
  :color_location        => 'status-bg',
  :default_message_color => 'brightred'

guard 'bundler' do
  watch('Gemfile')
end

guard 'puppet-lint', :show_warnings => true do
  watch(/modules\/(.*).pp$/)
end
