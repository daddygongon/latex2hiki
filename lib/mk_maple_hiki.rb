# -*- coding: utf-8 -*-
require 'optparse'
require "latex2hiki/version"
require "latex2hiki/latex2hiki"
#require "latex2hiki/latex2hiki_new"
require 'fileutils'
require 'yaml'

module MkMapleHiki

  class Command
    def self.run(argv=[])
      new(argv).execute
    end

    def initialize(argv=[])
      @argv = argv
    end

    def execute
      @argv << '--help' if @argv.size==0
      banner = 'For making maple hiki'
      command_parser = OptionParser.new(banner) do |opt|
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
        opt.on('--hiki [NAME]','make hiki contents from NAME directory.') { |name|
          @src=read_src(name)
          name = name || './'
          make_hiki(name)
          exit
        }
      end
      command_parser.parse!(@argv)
      puts NKF.nkf("-w",Latex.new(File.read(ARGV[0])).to_hiki)
      exit
    end

    def read_src(name)
      file=File.read(File.join(name,'.latex2hiki_rc'))
      YAML.load(file)
    end

    def make_hiki(name)
      toc_file = File.join(name,"#{File.basename(name)}.tex")
      if File.exists?(toc_file) then
        toc=toc_file_base_proc(toc_file)
      else
#        dir_base_proc
      end
      print toc
    end

    def toc_file_base_proc(toc_file)
      lines = File.readlines(toc_file)
      parser=[]
      str_started=false
      lines.each{|line|
        elements=line.match(/^\\(\w+){([\w\/\.\(\))ぁ-んァ-ヴ一-龠ーｱ-ﾝﾟﾞ・ｰｬｭｮｧ-ｫｯ]+)}/u)
        next unless elements
#        p [str_started,elements]
        if !str_started
          if elements[2]!='document'
            next
          else
            str_started=!str_started
          end
        end
        parser << [elements[1],elements[2]]
      }

      toc="{{toc}}\n"
      parser.each{|elements|
        case elements[0]
        when 'chapter'
          toc << "\n!#{elements[1]}\n"
        when 'section'
          toc << "\n!!#{elements[1]}\n"
        when 'subsection','ChartElement','ChartElementTwo'
          toc << "\n!!!#{elements[1]}\n"
        when 'input'
          latex_txt= File.read(File.join(File.dirname(toc_file),elements[1]))
          converts = @src[:convert_specific_def]
          converts.each_pair{|key,val|
#            latex_txt.gsub!(key,val)
          }
#          p latex_txt
          hiki_txt = NKF.nkf("-w",Latex.new(latex_txt).to_hiki)
          toc << "\n#{hiki_txt}\n"
        end
      }
      return toc
    end

    def gather_figures(name)
      @src=read_src(name)
      extension = @src[:fig_extension] || '.eps'
      p file_names =File.join(name,'**',"\*#{extension}")
      files = Dir.glob(file_names)
      target = File.join(name,'figures')
      files.each{|file|
        next if File.dirname(file)==target
        FileUtils.cp(file,target,:verbose=>true)
      }
    end

    def init(name)
      puts name
      begin
        Dir.mkdir(name, 0777)
      rescue => err
        puts err
        exit
      end
      FileUtils.mkdir(File.join(name,'figures'),:verbose=>true)
      @src = {:fig_extension => '.eps',
        :local_site => '/Users/bob/Sites/new_ist_data/maple_hiki_data'}
      file=File.open(File.join(name,'.latex2hiki_rc'),'w')
      YAML.dump(@src,file)
      file.close
    end
  end
end
