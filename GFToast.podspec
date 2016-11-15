Pod::Spec.new do |s|
  s.name         = "GFToast"
  s.version      = "1.0"
  s.summary      = "A simple message box on the iOS platform, mainly imitate the Android Toast."
  s.homepage     = "https://github.com/gydmercy/GFToast"
  s.license      = "MIT"
  s.author             = { "Mercy" => "gyd0915@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/gydmercy/GFToast.git", :tag => s.version }
  s.source_files  = "GFToast/*.{h,m}"
  s.requires_arc = true

end
