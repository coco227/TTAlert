Pod::Spec.new do |s|
  s.name         = "TTAlert"
  s.version      = "0.0.1"
  s.ios.deployment_target = '7.0'
  s.summary      = "This is a custom alert view."
  s.homepage     = "https://github.com/coco227/TTAlert"
  s.license      = "MIT"
  s.author             = { "tao" => "tchkzzt@live.com" }
  s.social_media_url   = "http://my.oschina.net/227/blog"
  s.source       = { :git => "https://github.com/coco227/TTAlert.git", :tag => s.version }
  s.source_files  = "TTAlert"
  s.requires_arc = true
end