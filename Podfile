# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'Qareeb' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Qareeb

    pod 'AlamofireObjectMapper' 
    pod 'Alamofire'
    pod 'ObjectMapper'    
    pod 'SVProgressHUD'
    pod 'IQKeyboardManagerSwift'
    pod 'GooglePlaces'
    pod 'GooglePlacePicker'
    pod 'GoogleMaps'
    pod 'GoogleSignIn'
    pod 'Cosmos'
    pod 'Kingfisher'
    pod 'SwiftKVC'
    pod 'DropDown' , '2.3.4'
    pod 'CheckoutKit', '~>3.0.6'
    pod 'ImageSlideshow/Alamofire'

    pod 'Fabric'
    pod 'Crashlytics'
    
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
    
#    pod 'LiveChat', '~> 2.0.11'

    pod 'FBSDKLoginKit'
    pod 'FBSDKShareKit'
    pod 'FBSDKCoreKit'
    pod 'FBSDKMarketingKit'

    pod "MIBadgeButton-Swift", :git => 'https://github.com/mustafaibrahim989/MIBadgeButton-Swift.git', :branch => 'master'
    
    pod 'OneSignal', '>= 2.6.2', '< 3.0'

  
#  target 'QareebTests' do
#    inherit! :search_paths
#    # Pods for testing
#  end


  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
          end
      end
  end
#  target 'QareebUITests' do
#    inherit! :search_paths
#    # Pods for testing
#  end


end
target 'OneSignalNotificationServiceExtension' do
    use_frameworks!
    pod 'OneSignal', '>= 2.6.2', '< 3.0'
end
