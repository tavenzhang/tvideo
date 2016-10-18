use_frameworks! # Add this if you are targeting iOS 8+ or using Swift
#使用My.xcworkspace 不用生成新的
workspace 'TVideoRoom.xcworkspace'
xcodeproj 'TVideoRoom/TVideoRoom.xcodeproj'
# 该Target属于的工程
target :TVideoRoom do
xcodeproj 'TVideoRoom/TVideoRoom.xcodeproj'
pod 'SwiftyJSON'
pod 'SnapKit'
pod 'CryptoSwift'
pod 'Alamofire'
pod 'NSLogger/NoStrip'
pod 'SVProgressHUD'
pod 'SDWebImage'
pod 'MJRefresh'
pod 'Fabric'
pod 'Crashlytics'
pod 'BBSZLib'
pod 'CocoaAsyncSocket'
end

target :TAmf3Socket do
xcodeproj 'TNetServer/TNetServer.xcodeproj'
pod 'BBSZLib'
pod 'CocoaAsyncSocket'
end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
