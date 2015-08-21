//
//  AppDelegate.m
//  MGSpotyView
//
//  Created by Daniele Bogo on 21/08/2015.
//  Copyright (c) 2015 Daniele Bogo. All rights reserved.
//

#import "AppDelegate.h"
#import "MGSpotyViewController.h"
#import "MGViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MGViewController *spotyViewController = [[MGViewController alloc] initWithMainImage:[UIImage imageNamed:@"example"]];
    
    [self.window setRootViewController:spotyViewController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end