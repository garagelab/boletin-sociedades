task :convert do
  sh "dos2unix -f dataset/*"

  Dir["dataset/*"].each do |path|
    sh "cp #{path} #{path}.tmp"
    sh "iconv -f iso-8859-1 -t utf-8 #{path}.tmp > #{path}"
    sh "rm #{path}.tmp"
  end
end

task :names do
  require "redis"
  require "json"

  r = Redis.connect

  File.open("names.json") do |io|
    io.each_line do |line|
      line = JSON.parse(line)

      next if line["str"] =~ /^[[:alpha:]]$/

      r.zadd("names", line["cnt_name"] || 0, line["str"])
      r.zadd("last_names", line["cnt_last_name"] || 0, line["str"])
    end
  end
end

task :load_boletines do
  require_relative 'lib/parser'
  require_relative 'lib/model'
  
  bdb = BoletinDB.new(File.dirname(__FILE__) + "/db")

  Dir["dataset/*"].each do |fname|
    STDERR.puts "Parsing #{fname}"

    File.open(fname) do |f|
      cnt = 0
      Parser.parse(f) do |sociedad|
        bdb.store_sociedad(sociedad)
        cnt += 1
      end
      STDERR.puts "  parsed #{cnt} records"
    end
  end

end

task :test do
  Dir["test/**/*.rb"].each { |p| require_relative p }
end

task default: :test
