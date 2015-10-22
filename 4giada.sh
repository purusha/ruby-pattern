#!/usr/bin/env ruby

rows_duplicated = []
results = []

file_name = "cause_2014.csv"
#file_name = "data.csv"

File.open(file_name).read.each_line do |line|
  line.strip!
  #puts "line is (#{line})"
  #puts "rows_duplicated is #{rows_duplicated.join('-')}"

  current_line = line.split(",")
  current_line.shift
  #puts "if is #{!rows_duplicated.index(line)}"

  if (!rows_duplicated.index(line))
    #puts "> #{current_line.join(',').strip}"

    IO.popen("grep '#{current_line.join(',').strip}' #{file_name}") do |line3|
      lines_grep = line3.read
      #puts ">> #{lines_grep}"
      #puts "#" * 100

      count = lines_grep.to_s.scan(/\n/).length  
      #puts ">>> #{count} "

      if (count > 1)
        results << lines_grep << "-" * 100
        lines_grep.split(/\n/).each { |e| rows_duplicated << e }
      end
    end

#    IO.popen("grep '#{current_line.join(',').strip}' #{file_name} | wc -l") do |line3|
#      if (line3.readlines.to_s.strip.to_i > 1)
#        IO.popen("grep '#{current_line.join(',').strip}' #{file_name}").readlines.each do |line2|
#          results << line2
#          ids_duplicated << line2.split(",").shift
#        end     
#        results << "-"
#      end
#    end

  end
end


puts results
