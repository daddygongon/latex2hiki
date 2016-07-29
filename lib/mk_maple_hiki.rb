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
      @scale = 80
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
        opt.on('--figures [NAME]','gather and convert figures in NAME dir.') { |name|
          name = name || './'
#          gather_figures(name)
          convert_figures(name)
          exit
        }
        opt.on('--scale [VAL]%','set scale for convert figures.') { |val|
          @scale = val.to_i
        }
        opt.on('--hiki [NAME]','make hiki contents from NAME directory.') { |name|
          name = name || './'
          @src=read_src(name)
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
      if name=='./'
        toc_file = File.join(File.basename(Dir.pwd()),tex)
      else
        toc_file = File.join(name,"#{File.basename(name)}.tex")
      end

      if File.exists?(toc_file) then
        toc=toc_file_base_proc(toc_file)
      else
#        dir_base_proc
      end
      hiki_file = File.join(@src[:local_site],'text',File.basename(name))
      File.write(hiki_file, toc)
      FileUtils.chmod(0666,hiki_file,:verbose=>true)
    end

    def toc_file_base_proc(toc_file)
      lines = File.readlines(toc_file)
      parser=[]
      str_started=false
      lines.each{|line|
        elements=line.match(/^\\(\w+){([\w\/\.\(\):ぁ-んァ-ヴ一-龠ーｱ-ﾝﾟﾞ・ｰｬｭｮｧ-ｫｯ]+)}/u)
        next unless elements
        if !str_started
          if elements[2]!='document'
            next
          else
            str_started=!str_started
          end
        end
        parser << [elements[1],elements[2]]
      }
#      p parser
      converts = @src[:convert_specific_def]
      level = @src[:level]
      text="{{toc}}\n"
      parser.each{|elements|
        tt=""
        case elements[0]
        when 'chapter'
          level.times{ tt << '!' }
          text << "\n#{tt}#{elements[1]}\n"
        when 'section'
          (level+1).times{ tt << '!' }
          p [tt,elements[1]]
          text << "\n#{tt}#{elements[1]}\n"
        when 'subsection'#,'ChartElement','ChartElementTwo'
          (level+2).times{ tt << '!' }
          text << "\n#{tt}#{elements[1]}\n"
        when 'input'
          p elements[1]
          latex_txt= File.read(File.join(File.dirname(toc_file),elements[1]))
          converts.each_pair{|key,val|
#            latex_txt.gsub!(key,val)
          }
#          hiki_txt = NKF.nkf("-w",Latex.new(latex_txt,:level=>level).to_hiki)
          hiki_txt = NKF.nkf("-w",Latex.new(latex_txt).to_hiki)
          text << "\n#{hiki_txt}\n"
        end
      }
      return text
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

    def convert_figures(name)
      @src=read_src(name)
      extension = @src[:fig_extension] || '.eps'
      p file_dir =File.join(name,'figures')
      files = Dir.entries(file_dir)
      p target_dir = File.join(@src[:local_site],'cache','attach',File.basename(name))
      FileUtils.mkdir_p(target_dir,:verbose=>true)
      files.each{|file|
        next if File.extname(file) != extension
        p source = File.join(file_dir,file)
        p name = File.basename(file,extension)
        p target = File.join(target_dir,name+'.png')
        p command = "convert #{source} -resize #{@scale}\% #{target}"
        system command
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
