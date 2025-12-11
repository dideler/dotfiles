# By default, IRB only remembers the very last result in the _ variable.
# This enable access to older results via the __ variable.
# Example: __[5] returns the result of line 5.
require 'irb/ext/eval_history'
IRB.conf[:EVAL_HISTORY] = 20

class Object
  # Returns all local methods of an object in YAML form.
  #
  # Example:  Time.now.local_methods
  #
  # Also useful are #methods, #public_methods, #instance_methods,
  # `ls`, `show-method`, `show_source`, `show_doc`, `measure`.
  def local_methods
   y (methods - Object.instance_methods).sort
  end
end

begin
  require 'amazing_print'
  AmazingPrint.irb!  # Use ap as default formatter in irb and the Rails console
  AmazingPrint.rdbg! # Enables integration with ruby debug
rescue LoadError
  warn "amazing_print not installed. Run `gem install amazing_print`"
end

begin
  require 'hirb'
  Hirb.enable
rescue LoadError
  warn "hirb not installed. Run `gem install hirb`"
end

def copy(str)
  IO.popen('pbcopy', 'w') { |f| f << str.to_s }
  "Copied to clipboard!"
end

def bench(&block)
  require 'benchmark'
  Benchmark.realtime { block.call }
end
