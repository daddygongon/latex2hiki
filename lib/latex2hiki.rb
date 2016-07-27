require 'optparse'
require "latex2hiki/version"
#require "latex2hiki/latex2hiki"
require "latex2hiki/latex2hiki_new"
require 'fileutils'

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
        opt.on('--init [NAME]','initialize NAME directory.') { |name|
          name = name || './'
          init(name)
          exit
        }
        opt.on('--figures [NAME]','gather NAME directory.') { |name|
          name = name || './'
          gather_figures(name)
          exit
        }
      end
      command_parser.parse!(@argv)
      puts NKF.nkf("-w",Latex.new(File.read(ARGV[0])).to_hiki)
      exit
    end

    def gather_figures(name)
      file_names =File.join(name,'**','*.eps')
      files = Dir.glob(file_names)
      target = File.join(name,'figures')
      files.each{|file|
        FileUtils.cp(file,target,:verbose=>true)
      }
    end

    def init(name)
      puts name
      if Dir.entries('.').include?(name)
        print "#{name} exists. rm -rf first.\n"
        exit
      else
        system "bundle gem #{name}"
      end
      ['lib','bin','spec'].each{|dir|
        FileUtils.rm_r(File.join(name,dir),:verbose=>true)
      }
      FileUtils.mkdir(File.join(name,'figures'),:verbose=>true)
    end
  end
end
