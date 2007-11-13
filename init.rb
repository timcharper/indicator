require "indicator.rb"

ActionView::Base.send(:include, Indicator::InstanceMethods)
# install files
['/public/images'].each{|dir|
  source = File.join(directory,dir)
  dest = RAILS_ROOT + dir
  FileUtils.cp_r(Dir.glob(source+'/*.*'), dest)
} unless File.exists?(RAILS_ROOT + '/public/images/indicator.gif')
