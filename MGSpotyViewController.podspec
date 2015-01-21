Pod::Spec.new do |s|
  s.name         = 'MGSpotyViewController'
  s.version      = '0.0.3'
  s.summary      = 'Beautiful viewController with a tableView and amazing effects like a viewController in the Spotify app.'
  s.homepage     = 'https://github.com/matteogobbi/MGSpotyViewController'
  s.license      = { :type => 'MIT',
                     :file => 'LICENSE' }
  s.author       = { 'Matteo Gobbi' => 'job@matteogobbi.com' }
  s.source       = { :git => 'https://github.com/matteogobbi/MGSpotyViewController.git',
                     :tag => '0.0.3' }
  s.platform     = :ios, '6.0'
  s.source_files = 'MGSpotyViewController/*.{h,m}', 'MGSpotyViewController/ImageEffects/*.{h,m}'
  s.frameworks   = 'CoreGraphics', 'UIKit'
  s.requires_arc = true
end
