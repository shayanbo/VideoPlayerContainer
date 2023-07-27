Pod::Spec.new do |s|
  s.name = 'VideoPlayerContainer'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Flexible and Extendable VideoPlayer for SwiftUI'
  s.homepage = 'https://github.com/MickeyHub/VideoPlayerContainer'
  s.authors = { 'Yanbo Sha' => 'yanbo.sha@gmail.com' }
  s.source = { :git => 'git@github.com:MickeyHub/VideoPlayerContainer.git', :tag => s.version }

  s.ios.deployment_target = '16.0'
  s.osx.deployment_target = '13.0'

  s.swift_versions = ['5']

  s.source_files = 'Source/**/*.swift'
end
