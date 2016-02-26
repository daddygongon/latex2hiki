require 'optparse'
require "latex2hiki/version"
require "latex2hiki/latex2hiki"

module Latex2hiki
  # Your code goes here...
  class Command
    def self.run(argv=[])
      new(argv).execute
    end

    def initialize(argv=[])
      @argv = argv
      @pre=@head=@post=nil
      @listings=false
    end

    def execute
      @argv << '--help' if @argv.size==0
      command_parser = OptionParser.new do |opt|
        opt.on('-v', '--version','show program Version.') { |v|
          opt.version = Latex2hiki::VERSION
          puts opt.ver
        }
      end
      command_parser.parse!(@argv)
      exit
    end
  end
end
