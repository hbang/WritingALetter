//
//  AppDelegate.m
//  WritingALetterTest
//
//  Created by Adam D on 12/08/2014.
//  Copyright (c) 2014 HASHBANG Productions. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
	[self.window makeKeyAndVisible];
	
	return YES;
}

@end
