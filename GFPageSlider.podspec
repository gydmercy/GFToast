Pod::Spec.new do |s|
  s.name         = "GFToast"
  s.version      = "1.0.0"
  s.summary      = ""
  s.homepage     = "https://github.com/gydmercy/GFToast"
  s.license      = "MIT"
  s.author       = { "Mercy" => "bluegyd@vip.qq.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/gydmercy/GFToast.git", :tag => s.version }
  s.source_files  = "GFToast/*.{h,m}"
  s.requires_arc  = true

end