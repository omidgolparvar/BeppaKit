Pod::Spec.new do |s|
  s.name                  = 'BeppaKit'
  s.version               = '2.6.0'
  s.summary               = 'یه بپا بذارین برای اپ‌تون!!'
  s.description           = <<-DESC
                            Written in Swift.
                            یه بپا بذارین برای اپ‌تون!!
                            DESC
  s.homepage              = 'https://github.com/omidgolparvar/BeppaKit'
  s.license               = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author                = { 'Omid Golparvar' => 'iGolparvar@gmail.com' }
  s.source                = { :git => "https://github.com/omidgolparvar/BeppaKit.git", :tag => s.version.to_s }
  s.swift_version         = '4.2'
  s.platform              = :ios, '10.3'
  s.requires_arc          = true
  s.ios.deployment_target = '10.3'
  s.pod_target_xcconfig   = { 'SWIFT_VERSION' => '4.2' }

  s.source_files          = [
    'BeppaKit/*.{h,swift}',
    'BeppaKit/**/*.swift'
  ]
  s.resources = [
    'BeppaKit/Assets.xcassets',
    'BeppaKit/Main.storyboard'
  ]
  s.public_header_files   = 'BeppaKit/*.h'

  s.libraries  = "z"

end
