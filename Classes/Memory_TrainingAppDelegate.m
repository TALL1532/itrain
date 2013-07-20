//
//  Memory_TrainingAppDelegate.m
//  Memory Training
//
//  Created by Andrew Battles on 7/22/12 modified by Thomas Deegan
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Memory_TrainingAppDelegate.h"
#import "LoggingSingleton.h"

@implementation Memory_TrainingAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSInteger currentSession = [[NSUserDefaults standardUserDefaults] integerForKey:@"k_sessionNumber"] +1;
    [[NSUserDefaults standardUserDefaults] setInteger:currentSession forKey:@"k_sessionNumber"];
    vc = [[MainScreenVC alloc] initWithNibName:@"MainScreenVC" bundle:nil];
	
	
	nav = [[UINavigationController alloc] initWithRootViewController:vc];
	nav.navigationController.title = @"Startup Screen";
	[[self window] addSubview:[nav view]];  
    
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
   
    //need to write the buffered application records to a file
    NSLog(@"NOT  KILLING APPLICATION!");
    [[LoggingSingleton sharedSingleton] writeBufferToFile];
    //should add a push notification to remind the user to continue their progress if they havent done anything for more than 2 day
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil) return;
    localNotif.fireDate = [[NSDate date] dateByAddingTimeInterval:60*60*24*2];//
    localNotif.timeZone = [NSTimeZone defaultTimeZone];

    NSLog(@"Local notification pushed");
    
    //setup inactive timer    
    localNotif.alertBody = [NSString stringWithFormat:@"You haven't completed a test in over 2 days! Click here to begin."];
    localNotif.alertAction = NSLocalizedString(@"Start Application", nil);
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
	[vc logIt:@"----- Program closed"];
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
	[vc logIt:@"----- Program Opened"];
	[vc mainScreenShown];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[LoggingSingleton sharedSingleton] writeBufferToFile];
    //should add a push notification to remind the user to continue their progress if they havent done anything for more than 2 day
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil) return;
    localNotif.fireDate = [[NSDate date] dateByAddingTimeInterval:60*60*24*2];//
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    NSLog(@"Local notification pushed");
    
    //came to app delegate so the app didnt crash, therefore was a valid exit
    [LoggingSingleton setRecoveryValidExit:YES];
    localNotif.alertBody = [NSString stringWithFormat:@"You haven't completed a test in over 2 days! Click here to begin."];
    localNotif.alertAction = NSLocalizedString(@"Start Application", nil);
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    [localNotif release];
    NSLog(@"KILLING APPLICATION!");
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
