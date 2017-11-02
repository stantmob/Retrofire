# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'Retrofire' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for retrofire
    pod 'Alamofire', '~> 4.4.0'
    pod 'SwiftyJSON'

  target 'RetrofireTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick'
    pod 'Nimble'
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.0'
    end
  end
end
