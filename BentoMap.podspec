Pod::Spec.new do |s|
  s.name             = 'BentoMap'
  s.version          = '0.3.0'
  s.summary          = 'Map Clustering for Swift.'

  s.description      = <<-DESC
A library to handle storing map annotations in a Quadtrees, and for returning
clusters of annotations to allow easy grouping of map items based on proximity.
                       DESC

  s.homepage         = 'https://github.com/Raizlabs/BentoMap'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Michael Skiba' => 'mike.skiba@raizlabs.com', 'Rob Visentin' => 'rob.visentin@raizlabs.com' }
  s.source           = { :git => 'https://github.com/Raizlabs/BentoMap.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ateliercw'

  s.ios.deployment_target = '9.0'

  s.source_files = 'BentoMap/**/*'

  s.frameworks   = 'Foundation', 'MapKit'

end
