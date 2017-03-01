#!/usr/bin/env ruby

Dir.glob("**/*.usfm") do |file_name|
  book_name = ""
  b_chp = ""
  b_chp_ver_t = ""
  file = file_name

  text = File.open(file, "r:utf-8").read
  directory_name = "output_folder"
  Dir.mkdir(directory_name) unless File.exists?(directory_name)

  output_name = "#{directory_name}/#{File.basename(file, '.*')}.tab"
  output = File.open(output_name, 'w')

  text.each_line do |line|
    puts line
    line.split("\r").each_with_index do |l, i|
      if l.include? ("\\id ")  
        book_name = l.partition(" ").last.gsub("\n", "").to_s.partition(" ").first
        break
      elsif l.include? ("\\c ") 
        chapter = l.gsub!(/\\c\s+/, "\t").to_s.gsub("\n", "")
        b_chp = book_name + chapter
        break
      elsif l.include? ("\\v ")
        n = l
        v = l
        ver_number = n.gsub!(/\\v\s+/, "\t").partition(" ").first
        ver_text = v.sub(/\s*[\w']+\s+/, " ").insert(0, "\t")
        b_chp_ver_t = b_chp + ver_number + ver_text
        output << b_chp_ver_t << "\n"
      end
    end
  end
  output.close
end
