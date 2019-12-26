#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_vod'
  s.version          = '0.0.7'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  #s.source       = { :git => "git://github.com/kelp404/CocoaSecurity.git" }
  #s.static_framework = true
  #s.source_files  = "CocoaSecurity", "CocoaSecurity/*.{h,m}"
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  #s.dependency 'AliyunOSSiOS'
  #s.dependency 'CocoaSecurity'
  s.frameworks = "CoreTelephony", "SystemConfiguration", "Foundation"

  s.ios.vendored_frameworks = 'Frameworks/*.framework'
  s.vendored_frameworks = 'QCloudCore.framework','QCloudCOSXML.framework'
  s.vendored_libraries = 'lib/libmtasdk.a'
  s.libraries = "c++"

  s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-ObjC'}
  #s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.ios.deployment_target = '8.0'

end
