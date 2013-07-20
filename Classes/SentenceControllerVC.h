//
//  SentenceControllerVC.h
//  Memory Training
//
//  Created by Andrew Battles on 8/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SentenceVC.h"
#import "ProperDataProtocol.h"

@protocol ProcessDataDelegate8 <NSObject>	//---comm
- (void)logIt:(NSString *)whatToLog;		//---comm
- (int)getTime;								//---comm
- (int)getSentenceWordNum;
- (void)changeSentenceWordNum:(int)number;
- (void)checkDoneForToday;
@end										//---comm


@interface SentenceControllerVC : UIViewController {
    IBOutlet UITextView *instructionsView;
    IBOutlet UIButton *startButton;
	
	SentenceVC *svc;
	
	int wordCount;
	
	NSTimer *timerNoOne;
	NSInteger timeLeft;
	
	BOOL timeUp;
	
	id <ProcessDataDelegate8,ProperDataProtocol> delegate;		//---comm
    NSTimer* recoveryTimer;
    BOOL isRecovering;

	
}
- (IBAction)startPressed:(id)sender;

- (void)launchSentenceGame:(int)numWords;

- (void)startTimer:(int)time;
- (void)killTimer;
- (void)updateTimerNoOne:(NSTimer *) timer;

- (void)sentenceTimeUp;

// delegate functions
- (void)sentenceEnded:(int)nextNumWords;	
- (void)sentenceQuit:(int)nextNumWords;

- (void)quitPressed;

- (void)logIt:(NSString *)whatToLog;
- (void)timerFired:(NSTimer *)timer;

- (void)recover;


@property (retain) id delegate;				//---comm

@end
