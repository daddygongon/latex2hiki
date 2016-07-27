# -*- coding: utf-8 -*-
require 'kconv'

class Latex < String

  def initialize(input)
    @input = input
    @f = ""
  end

  def to_hiki
    section = []
    @input.split("\n").each do |line|
      case line
      when /^\\(\w+)/
        section.push $1
        next
      when /^End(\w+)/
        section.pop
        next
      end
      p section[-1]

      case section[-1]
      when ["author"]
        @f << line
        cont = line.match(/\\(\w+)\{(\w+)\}/)
        p cont
        @f <<  cont
        @f << cont[2]
        exit
      else
#        @f << section[-1]
      end
    end
    return @f
  end
end
