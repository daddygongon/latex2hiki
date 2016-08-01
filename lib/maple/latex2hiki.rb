#!/usr/local/bin/ruby
# -*- coding: utf-8 -*-
require "stringio"
require 'kconv'
require "strscan"
require "uri"

class Latex < String

  def initialize(output)
    @text = NKF.nkf("-w",output)
    @text.gsub!(/\r\n?/,'\n')
    @text.gsub!(/\\%/,'%')
    @text.gsub!("。","．")
    @text.gsub!("、","，")
  end

  def strip_hiki
    ifHIKI = true
    output = ''
    @text.each_line {|line1|
      case line1
      when /\\ifHIKI/
        ifHIKI = true
      when /\\else/
        ifHIKI = false
      when /\\fi/
        ifHIKI = true
      else
        if ifHIKI==true then
          output << line1
        end
      end
    }
    @text = output
  end

  def strip_document
    is_document = false
    is_include_document = false
    output = ''
    @text.each_line{|line|
      case line
      when /\\begin\{document\}/
        is_document = true
        is_include_document = true
      when /\\end\{document\}/
        is_document = false
      else
        if is_document==true then
          output << line
        end
      end
    }
    if is_include_document==true then
      @text = output
    end
  end

  def to_hiki
    roman_num=["","i)","ii)","iii)","iv)","v)","vi)","vii)","viii)","ix)","x)"]
    alpha_num=["","a)","b)","c)","d)","e)","f)","g)","h)","i)","j)"]
    strip_document()
    strip_hiki()
    output=''
    item_number=Array.new(3,1)
    is_enumerate=0
    is_quote_eq, is_quote, is_itemize, is_table = false, false, false, false
    @text.each_line {|nline|
      line=nline.gsub(/\\verb\|(.+?)\|/){|matched|
        $&[6..-2]
      }

      line.gsub!(/\\fbox\{(.+?)\}/,"[ XXX ]")
      line.gsub!(/\\displaystyle/,'')

      case line
      when /\\label\{(.*)\}/

      when /\\section\{(.*)\}/
        output << "\n!#{$1} \n"
      when /\\section\*\{(.*)\}/
        output << "\n!#{$1} \n"
      when /\\subsection\{(.*)\}/
        output << "\n!!#{$1} \n"
      when /\\subsubsection\{(.*)\}/
        output << "\n!!!#{$1} \n"
      when /\\paragraph\{(.*)\}/
        output <<  "\n!!!!#{$1} \n"
      when /\\item\[(.*)\](.*)/
        output << ":"+$1+":"+$2.chomp+"\n"
      when /\\item(.*)/
        if is_enumerate==1 then
          output << "# "+$1.chomp+"\n"
        elsif is_enumerate==2 then
          output << "# "+$1.chomp+"\n"
        elsif is_enumerate==3 then
          output << "# "+$1.chomp+"\n"
        elsif is_itemize then
          output << "* "+$1+"\n"
        end

      when /\\begin\{MapleInput\}/
        output << "<<<maple\n"
      when /\\end\{MapleInput\}/
        output << ">>>\n"
      when /\\begin\{MapleError\}/
        output << "<<<maple\n"
      when /\\end\{MapleError\}/
        output << ">>>\n"


      when /\\begin\{quote\}/
        is_quote = true
      when /\\end\{quote\}/
        is_quote = false

      when /\\begin\{description\}/
      when /\\end\{description\}/
      when /\\begin\{verbatim\}/
        output << "<<<\n"
      when /\\end\{verbatim\}/
        output << ">>>\n"
      when /\\begin\{enumerate\}/
        is_enumerate += 1
      when /\\begin\{itemize\}/
        is_itemize = true
      when /\\end\{enumerate\}/
        item_number[is_enumerate]=1
        is_enumerate -= 1
      when /\\end\{itemize\}/
        is_itemize = false



      when /\\begin\{MapleOutput\}/,/\\begin\{MapleOutputGather\}/,/\\begin\{gather\}/ then
        output << "\$\$\n"
        is_quote_eq = true
      when /\\end\{MapleOutput\}/,/\\end\{MapleOutputGather\}/,/\\end\{gather\}/ then
        output << "\$\$\n"
        is_quote_eq = false
#      when /\\notag/ then
#        output << $`+"\n"
#        output << 

      when /\\MaplePlot\{(.*)\}\{(.*)\}/
        target=File::basename($2,".eps")+".png"
        output << "||{{attach_view(#{target},#{$target_dir})}}||\n"

      when /\\begin\{tabular\}/
        is_table = true
      when /\\end\{tabular\}/
        is_table = false
      when /\\begin\{table\}/
      when /\\end\{table\}/
      when /\\begin\{center\}/
      when /\\end\{center\}/
      when /\\caption\{(.*)\}/
#        output << "'''"+$1+"'''\n"
        output << "!!!caption:"+$1+"\n"

      when /\\begin\{equation\*\}/
        is_quote_eq = true
        if is_quote then
          output << "\"\"\$\$\n"
        else
          output << "\n\$\$\n"
        end
      when /\\end\{equation\*\}/ 
        is_quote_eq = false
        output << "\$\$\n"
      when /\\begin\{equation\}/
        is_quote_eq = true
        if is_quote then
          output << "\"\"\$\$\n"
        else
          output << "\$\$\n"
        end
      when /\\end\{equation\}/
        is_quote_eq = false
        output << "\$\$\n"
      when /\\pagebreak/
      when /\\begin\{(.+)\}/
        if is_quote_eq then
          output << line.lstrip
        end
      when /\\end\{(.+)\}/
        if is_quote_eq then
          output << line.lstrip
        end
      else
        if is_table then
          next if ((line==nil) or (line=~/^\\hline/))
          line.gsub!(/\&/,"||")
          line.gsub!(/\\\\/,"")
          line.gsub!(/\\hline/,"")
          output << "||"+line

        elsif is_quote then
          if is_quote_eq then
            output << line.lstrip
          else
            output << "\"\""+line
          end
        else
          if is_quote_eq then
            output << line.lstrip
          else
            output << line
          end
        end
      end
    }
    return output
  end
end

if __FILE__ == $0
  $target_dir=File::dirname(ARGV[0])
#  puts NKF.nkf("-e",Latex.new(File.read(ARGV[0])).to_hiki)
  puts NKF.nkf("-w",Latex.new(File.read(ARGV[0])).to_hiki)
end
