//
//  CategoryControllerVC.h
//  Memory Training
//
//  Created by Andrew Battles on 7/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryVC.h"
#import "ProperDataProtocol.h"

@protocol ProcessDataDelegate5 <NSObject>	//---comm
- (void)logIt:(NSString *)whatToLog;		//---comm
- (int)getTime;								//---comm
- (int)getCategoryWordNum;
- (void)checkDoneForToday;
- (void)changeCategoryWordNum:(int)number;
@end										//---comm

@interface CategoryControllerVC : UIViewController {
    IBOutlet UITextView *instructionsView;
    IBOutlet UIButton *startButton;

	CategoryVC *cvc;
	
	int wordCount;
	
	NSTimer *timerNoOne;
	NSInteger timeLeft;
	    
	BOOL timeUp;
	
	id <ProcessDataDelegate5, ProperDataProtocol> delegate;		//---comm
    
    NSTimer* recoveryTimer;
    BOOL isRecovering;
	
}
- (IBAction)startPressed:(id)sender;

- (void)launchCategoryGame:(int)numWords;

- (void)startTimer:(int)time;
- (void)killTimer;
- (void)updateTimerNoOne:(NSTimer *) timer;

- (void)categoryTimeUp;
// delegate functions

+ (int)chooseCategory;
- (void)categoryEnded:(int)nextNumWords;
- (void)categoryQuit:(int)nextNumWords;

- (void)quitPressed;

- (void)logIt:(NSString *)whatToLog;
- (void)timerFired:(NSTimer *)timer;

- (void)recover;

@property (retain) id delegate;				//---comm

@end
