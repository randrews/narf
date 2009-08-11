task :default => :gem

task :clean do
  files=Dir["**/*~"]
  puts "Removing #{files.size} Emacs temp file#{(files.size==1?'':'s')}"
  files.each do |tmp|
    FileUtils.rm tmp
  end

  puts "Removing built gem"
  `rm -f jam-*.gem`
end

task :gem do
  `rm -f narf-*.gem`
  `gem build narf.gemspec`
end

task :install=>:gem do
  `gem install --force narf-*.gem`
end
