use_frameworks! # Add this if you are targeting iOS 8+ or using Swift
#使用My.xcworkspace 不用生成新的
workspace 'TWork.xcworkspace'
xcodeproj 'TVideoRoom/TVideoRoom.xcodeproj'
# 该Target属于的工程
target :TVideoRoom do
xcodeproj 'TVideoRoom/TVideoRoom.xcodeproj'
pod 'SwiftyJSON', :git => 'https://github.com/SwiftyJSON/SwiftyJSON.git'
pod 'CryptoSwift'
pod 'NSLogger/NoStrip'
pod 'SVProgressHUD'
pod 'SDWebImage'
pod 'Alamofire', '~> 3.4'
pod 'MJRefresh'
pod 'Fabric'
pod 'Crashlytics'
end

target :TNetServer do
xcodeproj 'TNetServer/TNetServer.xcodeproj'
pod 'BBSZLib'
pod 'CocoaAsyncSocket', '7.4.3'
end