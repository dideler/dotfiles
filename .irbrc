# encoding: utf-8

# Note: not necessary to load 'rubygems' explicitly since Ruby 1.9.

STDOUT.sync = true  # Do not buffer output.

class String

  # Extend String class instead of adding colorize dependency.
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def pink
    colorize(35)
  end

end

def success(msg)
  puts msg.green
end

def error(msg)
  warn msg.red
end

class Object
  # Returns all local methods of an object in YAML form.
  #
  # Example:  Time.now.local_methods
  #
  # Note: also useful are Object.methods and Object.instance_methods
  def local_methods
   y (methods - Object.instance_methods).sort
  end
end

begin
  print 'Loading Brice... '
  require 'brice'
  Brice.init
  success '✓'
rescue LoadError => err
  error "#{err}"
  begin
    print 'Loading Wirble instead... '
    require 'wirble'
    Wirble.init
    Wirble.colorize  # Enable colours
    success '✓'
  rescue LoadError => err
    error "#{err}"
  end
end

begin
  print 'Loading AwesomePrint... '
  require 'awesome_print'
  AwesomePrint.irb!
  success '✓'
rescue LoadError => err
  error "#{err}"
end

begin
  print 'Loading Hirb... '
  require 'hirb'
  Hirb.enable
  success '✓'
rescue LoadError => err
  error "#{err}"
end
