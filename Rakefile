require 'nanoc3/tasks'
require 'fileutils'

task :default => ["create:article"]

namespace :deploy do
  desc "Fully deploy the website"
  task :full do
    dir = File.dirname(__FILE__)
    FileUtils.rm_rf(Dir.glob(File.join(dir, 'output/*')), :secure => true)
    Rake::Task['deploy:update'].invoke
  end
  
  desc "Deploy the website. No items are deleted."
  task :update do
    Dir.chdir(File.dirname(__FILE__)) do
      system("nanoc3", "compile")
    end
  end
end

namespace :create do
  desc "Creates a new article"
  task :article do
    $KCODE = 'UTF8'
    require 'active_support/core_ext'
    require 'active_support/multibyte'
    
    title = ENV['title'] || read("Title")
    @created_at = Time.now
    path, filename, full_path = calc_path(title)
    
    if File.exists?(full_path)
      $stderr.puts "[error] Exists #{full_path}"
      exit 1
    end

    template = <<-TEMPLATE
---
title: "#{title.titleize}"
tags: [lang:en]
created_at: #{@created_at.strftime("%Y-%m-%d %H:%M:%S %Z")}
updated_at: #{@created_at.strftime("%Y-%m-%d %H:%M:%S %Z")}
author: Holger Just

kind: article
publish: true
---

TODO: Add content to @#{full_path}@.
TEMPLATE

    FileUtils.mkdir_p(path)  unless File.exists?(path)
    File.open(full_path, 'w') { |f| f.write(template) }
    $stdout.puts "[ok] Edit #{full_path}"
    system(ENV['EDITOR'], full_path) if ENV['EDITOR']
  end

  
  def read(question)
    print "#{question}: "
    $stdin.readline.strip
  end

  def calc_path(title)
    ymd = @created_at.strftime('%Y-%m-%d')
    path = "content/articles/#{@created_at.year}/"
    filename = "#{ymd}-#{title.parameterize("-")}.textile"
    [path, filename, File.join(path, filename)]
  end
  
end