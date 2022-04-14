
# Minds SDK

This SDK is available under two formats that should be maintained to contain the same sources: a swift package which provides an open-source solution and an XCFramework which can be distributed as a closed-source solution.

## Alternative 1: Swift Package

A Swift package can be used to ship open-source software. The Swift Package is available on GitHub:
https://github.com/mindsdigital/minds-sdk-mobile-ios on the **main branch**.

### Sample app

The sample app for the swift package solution can be found on https://github.com/mindsdigital/minds-sdk-mobile-ios-sample-app on the **main branch**.

After cloning the repo, you need to import the SDK and the Alamofire packages. Open the project in XCode, then navigate to *File -> Add Packages* and then, one by one, add:
* https://github.com/mindsdigital/minds-sdk-mobile-ios
* https://github.com/Alamofire/Alamofire 

## Alternative 2: XCFramework

An XCFramework can be used to ship closed-source software. The framework solution is available on Github: https://github.com/mindsdigital/minds-sdk-mobile-ios on the **framework branch**.

### Building the XCFramework

Firstly, open the project in XCode, select the target and set *Build Libraries for Distribution* to *Yes* and *Skip Install* to *No*.

Then, open a Terminal and navigate to the SDK project, on the same level as MindsSDK.xcodeproj.

Run the following commands, in the specified order:
```
xcodebuild archive -scheme MindsSDK -archivePath ".archives/ios.xcarchive" -sdk iphoneos -SKIP_INSTALL=NO
```

```
xcodebuild -create-xcframework -framework .archives/ios.xcarchive/Products/Library/Frameworks/MindsSDK.framework -output ./builds/MindsSDK.xcframework
```

You will then find the SDK build in the *builds* folder.

### Sample app

The sample app for the XCFramework solution can be found on https://github.com/mindsdigital/minds-sdk-mobile-ios-sample-app on the **framework branch**.

After cloning the repo, you need to import the Alamofire package. Open the project in XCode, then navigate to *File -> Add Packages* and then add:
* https://github.com/Alamofire/Alamofire 

To link the XCFramework to the sample project, follow the below steps:
* Open the sample project in XCode
* Select MindsSDKSampleApp.xcodeproj (the top-most item in the left panel)
* Select *<target-name> -> General*
* Find the *Frameworks, Libraries, and Embedded Content* section.
* Click on the plus button, select *Add Files...* and open the *MindsSdk.xcframework* project located in *<sdk-path>/builds*.


