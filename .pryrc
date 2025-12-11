# frozen_string_literal: true

## Initialisers

begin
  require 'amazing_print'
  AmazingPrint.pry!
rescue LoadError
  warn "amazing_print not installed. Run `gem install amazing_print`"
end

begin
  require 'pry-doc'
rescue LoadError
  warn "pry-doc not installed. Run `gem install pry-doc`"
  puts "for `show-doc` and `show-source` methods (aliased as ? and $)"
end

begin
  require 'pry-byebug'
rescue LoadError
  warn "pry-byebug not installed. Run `gem install pry-byebug`"
  puts "for `next`, `step`, and `continue` commands"
end

## Startup hooks

# Automatic SQL logging during Pry sessions.
# To turn off manually during a session, set `ActiveRecord::Base.logger = nil`.
if defined?(ActiveRecord)
  Pry.config.hooks.add_hook(:before_session, :enable_sql_logging) do
    unless Thread.current[:pry_ar_logger_enabled]
      Thread.current[:pry_old_ar_logger] = ActiveRecord::Base.logger
      ActiveRecord::Base.logger = Logger.new(STDOUT)
      Thread.current[:pry_ar_logger_enabled] = true
    end
  end

  Pry.config.hooks.add_hook(:after_session, :restore_sql_logging) do
    if Thread.current[:pry_ar_logger_enabled]
      ActiveRecord::Base.logger = Thread.current[:pry_old_ar_logger]
      Thread.current[:pry_ar_logger_enabled] = false
      Thread.current[:pry_old_ar_logger] = nil
    end
  end
end

## Custom methods

def copy(str)
  IO.popen('pbcopy', 'w') { |f| f << str.to_s }
  "Copied to clipboard!"
end
