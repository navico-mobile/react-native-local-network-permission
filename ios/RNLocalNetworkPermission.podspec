
Pod::Spec.new do |s|
  s.name         = "RNLocalNetworkPermission"
  s.version      = "1.0.0"
  s.summary      = "RNLocalNetworkPermission"
  s.description  = <<-DESC
                  RNLocalNetworkPermission
                   DESC
  s.homepage     = "https://github.com/navico-mobile/react-native-local-network-permission"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "bruce.li" => "ljb_iss@hotmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/author/RNLocalNetworkPermission.git", :tag => "master" }
  s.source_files  = "RNLocalNetworkPermission/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"
  #s.dependency "others"

end

  