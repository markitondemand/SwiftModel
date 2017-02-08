Pod::Spec.new do |s|
  s.name = 'MDSwiftModel'
  s.version = '0.1'
  s.license = 'Proprietary'
  s.summary = 'Simple Model object loading framework for Swift projects'
  s.homepage = 'https://stash.mgmt.local/projects/IOSLIB/repos/mdswiftmodel/'
  s.authors = { 'Michael Leber' => 'michael.leber@ihsmarkit.com', 'Drew Christensen' => 'andrew.christensen@ihsmarkit.com' }
  s.source = { :git => 'ssh://git@stash.mgmt.local/ioslib/mdswiftmodel.git', :tag => s.version }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/*.swift'

#   s.ios.framework  = 'UIKit'
end