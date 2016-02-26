# -*- coding: utf-8 -*-

class Latex < String

  def initialize(output)
  end

  def to_hiki(text)
  section = []
  text.split("\n").each do |line|
    case line
    when /^Start(\w+)/
      section.push $1
      next
    when /^End(\w+)/
      section.pop
      next
    end
    p section

    case section
    when ["CharMetrics"]
#      next unless line =~ /^CH?\s/
      p line
      p name           = line[/\bN\s+(\.?\w+)\s*;/, 1]
      p glyp_width     = line[/\bWX\s+(\d+)\s*;/, 1].to_i
      p bounding_boxes = line[/\bB\s+([^;]+);/, 1].to_s.rstrip
    else
      p line
    end
  end
end

  end
end
