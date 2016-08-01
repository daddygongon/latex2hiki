lines = File.readlines(ARGV[0])

lines.each{|line|
#  if md=line.match(/\{\{(.+?)\}\}/) then
  if md=line.match(/\{\{.+?\}\}/) then
    p line
    p line.gsub!(/\{\{\{(.+?)\}\}\}/){|text|
      "\{#{$1}\}"
    }
    p line.gsub!(/\{\{(.+?)\}\}/){|text|
      "\{#{$1}\}"
    }
  end
}
