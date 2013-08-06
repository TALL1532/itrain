//
//  FeedbackDelegate.h
//  Memory Training
//
//  Created by Thomas Deegan on 8/6/13.
//
//

#import <Foundation/Foundation.h>
@class ControlFeedbackViewController;
@protocol FeedbackDelegate <NSObject>
- (void)FeedbackControllerContinuePressed:(ControlFeedbackViewController*)sender;
- (void)FeedbackControllerDoneLoading:(ControlFeedbackViewController*)sender;
@end
