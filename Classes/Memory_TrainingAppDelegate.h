//
//  Memory_TrainingAppDelegate.h
//  Memory Training
//
//  Created by Andrew Battles on 7/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainScreenVC.h"

@interface Memory_TrainingAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *nav;
	MainScreenVC *vc;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

