#!/usr/bin/env ruby

require 'csv'
file = ARGV[0]
hash = {}
h = Hash.new { |hash, key| hash[key] = [] }
count=0

text = File.open(file, "r:utf-8").read
#text.gsub!(/\r\n?/, "\n")

book_name = ""
b_chp = ""
b_chp_ver=""

b_chp_ver_t = ""

  directory_name = "output_folder"
  Dir.mkdir(directory_name) unless File.exists?(directory_name)

  output_name = "#{directory_name}/#{File.basename(file, '.*')}.text"
  output = File.open(output_name, 'w')

  text.each_line do |line|
    line.split("\r").each_with_index do |l, i|
      if l.include? ("\\id")
        book_name = l.partition(" ").last.gsub("\n", "")
      end
      if l.include? ("\\c")
        chapter = l.gsub!(/\\c\s+/, "\t").gsub("\n", "")
        b_chp = book_name + chapter
      end
      if l.include? ("\\v")
        n = l
        v = l
        ver_number = n.gsub!(/\\v\s+/, "\t").partition(" ").first
        ver_text = v.sub(/\s*[\w']+\s+/, " ").insert(0, "\t")

        b_chp_ver_t = b_chp + ver_number + ver_text #ver_text[ver_text.index(' ')+1 .. -1].gsub("\n", "")
        puts b_chp_ver_t
      end
    output << b_chp_ver_t
    end
  end
output.close
