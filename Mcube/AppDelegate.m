//
//  AppDelegate.m
//  Mcube
//
//  Created by Schubert Cardozo on 08/02/14.
//  Copyright (c) 2014 Schubert Cardozo. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "ArtistListViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [Parse setApplicationId:@"rtXmpWUjbxjSNVejzk17KdwO2dx8fgT9TAolbBG4"
                  clientKey:@"bAhSfcVzD3580kXgk7DH4DFrphIH0AH1vOSWNUnR"];

    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] ;
    
    
    UITabBarController *mainTabBar = [[UITabBarController alloc] init];
    [mainTabBar setDelegate:self];
    
    ArtistListViewController *artistViewController = [[ArtistListViewController alloc] init];
    
    UINavigationController *artistNavigation = [[UINavigationController alloc] initWithRootViewController:artistViewController];
    UINavigationController *gigsNavigation = [[UINavigationController alloc] init];
    gigsNavigation.title = @"Gigs";

    [mainTabBar setViewControllers:@[artistNavigation, gigsNavigation]];
    self.window.rootViewController = mainTabBar;
    
    
    [self.window makeKeyAndVisible];
    
    [[UITabBar appearance] setTintColor:[UIColor grayColor]];
    [[UITabBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    [[UINavigationBar appearance] setTintColor:[UIColor darkGrayColor]];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
