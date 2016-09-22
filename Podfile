# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

target 'CoreStoreSectionedListTestCase' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'CoreStore', '2.1.0'

end

# Copy acknowledgements to the Settings.bundle
post_install do | installer |
  require 'fileutils'

  # Work around pods that haven't been explicitly updated for swift 2.3
  # See: http://stackoverflow.com/a/38466703/171144
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '2.3'
    end
  end

end
