//
//  AppDelegate.swift
//  TVideoRoom
//
//  Created by 张新华 on 16/6/2.
//  Copyright © 2016年 张新华. All rights reserved.
//

import UIKit
import NSLogger
import SDWebImage
import MJRefresh
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		Fabric.with([Crashlytics.self])
		Flurry.startSession("G5RPTXT453GYG8DK5BSD");
		window = UIWindow(frame: ScreenBounds)
		window!.makeKeyAndVisible();
		LoggerStart(LoggerGetDefaultLogger())
		LogMarker("strart");
		let manVc = MainTabBarController();
		manVc.adImage = UIImage(named: "LaunchImage");
		// let manVc = TChatViewControl();
		window?.rootViewController = manVc;
		let webView = UIWebView(frame: ScreenBounds);
		let agent = webView.stringByEvaluatingJavaScript(from: "navigator.userAgent");
		UserDefaults.standard.register(defaults: ["UserAgent": agent!]);
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

}

