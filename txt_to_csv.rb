require 'csv'

CSV.open("query.csv","a+") do |csv|
  # puts File.read(File.expand_path("../query.txt",__FILE__)).split("\n")[0].class

  File.read(File.expand_path("../query.txt",__FILE__)).split("\n").each do |line|
    item = line.split(": ")
    csv << [item[0],item[1]]
  end
end