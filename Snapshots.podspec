Pod::Spec.new do |s|
  s.name             = "Snapshots"
  s.version          = "1.0.3"
  s.summary          = "Snapshots SDK for validating against serialised states"
  s.homepage         = "https://github.com/rndm-com/Snapshots.git"
  s.license          = 'BSD'
  s.source           = { :git => 'https://github.com/rndm-com/Snapshots.git', :tag => '1.0.3' }
  s.platform         = :ios, '11.0'
  s.author           = { "Paul Napier" => "info@rndm.com" }
  s.requires_arc     = true
  s.module_name      = 'Snapshots'
  s.source_files     = "Source/**/*.swift"
  s.framework        = 'XCTest'
end


