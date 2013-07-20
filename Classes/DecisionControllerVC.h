//
//  DecisionControllerVC.h
//  Memory Training
//
//  Created by Andrew Battles on 7/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DecisionVC.h"
#import "ProperDataProtocol.h"

@protocol ProcessDataDelegate6 <NSObject>	//---comm
- (void)logIt:(NSString *)whatToLog;		//---comm
- (int)getTime;								//---comm
- (void)changeDecisionWordNum:(int)number;
- (int)getDecisionWordNum;
- (void)checkDoneForToday;
@end										//---comm


@interface DecisionControllerVC : UIViewController {
	
    IBOutlet UITextView *instructionsView;
    IBOutlet UIButton *startButton;
	
	DecisionVC *dvc;
	
	int wordCount;
	
	NSTimer *timerNoOne;
	NSInteger timeLeft;
	
	BOOL timeUp;
	
	id <ProcessDataDelegate6, ProperDataProtocol> delegate;		//---comm
    NSTimer* recoveryTimer;
    BOOL isRecovering;

}
- (IBAction)startPressed:(id)sender;

- (void)launchDecisionGame:(int)numWords;

- (void)startTimer:(int)time;
- (void)killTimer;
- (void)updateTimerNoOne:(NSTimer *) timer;

- (void)decisionTimeUp;

// delegate functions
- (void)decisionEnded:(int)nextNumWords;	
- (void)decisionQuit:(int)nextNumWords;

- (void)quitPressed;

- (void)logIt:(NSString *)whatToLog;		
- (void)timerFired:(NSTimer *)timer;

- (void)recover;


@property (retain) id delegate;				//---comm

@end
