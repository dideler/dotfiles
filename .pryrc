# coding:utf-8 vim:ft=ruby

# Use Syck instead of default Psych so `y` method is available in zeus console.
require 'yaml'
YAML::ENGINE.yamler = 'syck' if defined?(YAML::ENGINE)

# Use a simple prompt.
Pry.config.prompt = Pry::SIMPLE_PROMPT

# Tell Readline when the window resizes.
old_winch = trap 'WINCH' do
  if `stty size` =~ /\A(\d+) (\d+)\n\z/
    Readline.set_screen_size $1.to_i, $2.to_i
  end
  old_winch.call unless old_winch.nil?
end

# Use AwesomePrint for output if available.
begin
  require 'awesome_print'
  Pry.config.print = proc do |output, value|
    value = value.to_a if defined?(ActiveRecord) && value.is_a?(ActiveRecord::Relation)
    output.puts value.ai
  end
rescue LoadError => err
  Pry.config.print = Pry::DEFAULT_PRINT
end

# Startup hooks
org_logger_active_record = nil
org_logger_rails = nil
Pry.hooks.add_hook :before_session, :rails do |output, target, pry|
  # Show ActiveRecord SQL queries in the console
  if defined? ActiveRecord
    org_logger_active_record = ActiveRecord::Base.logger
    ActiveRecord::Base.logger = Logger.new STDOUT
  end

  if defined?(Rails) && Rails.env
    # Output all other log info such as deprecation warnings to the console
    if Rails.respond_to? :logger=
      org_logger_rails = Rails.logger
      Rails.logger = Logger.new STDOUT
    end

    # Load Rails console commands
    if Rails::VERSION::MAJOR >= 3
      require 'rails/console/app'
      require 'rails/console/helpers'
      if Rails.const_defined? :ConsoleMethods
        extend Rails::ConsoleMethods
      end
    else
      require 'console_app'
      require 'console_with_helpers'
    end
  end
end

Pry.hooks.add_hook :after_session, :rails do |output, target, pry|
  ActiveRecord::Base.logger = org_logger_active_record if org_logger_active_record
  Rails.logger = org_logger_rails if org_logger_rails
end
