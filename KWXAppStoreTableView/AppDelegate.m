//
//  AppDelegate.m
//  tile
//
//  Created by Michael Hurni on 20/10/2018.
//  Copyright © 2018 Michael Hurni. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = ViewController.new;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
