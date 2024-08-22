Pod::Spec.new do |spec|
  spec.name         = 'Module'
  spec.version      = '1.0.0'
  spec.license      = { :type => 'BSD' }
  spec.homepage     = 'https://github.com/dubydu/add-to-app'
  spec.authors      = { 'Doo Bui' => 'dubydu97@gmail.com' }
  spec.summary      = 'Flutter Module for iOS and OS X.'
  spec.source       = { :git => 'git@github.com:dubydu/add-to-app.git', tag: '1.0.0-rc.1' }
  spec.vendored_frameworks   = 'flutter_module/public/*.xcframework'
  spec.preserve_path = 'flutter_module/public/*'
end
