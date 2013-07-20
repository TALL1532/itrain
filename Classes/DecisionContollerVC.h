//
//  DecisionContollerVC.h
//  Memory Training
//
//  Created by Andrew Battles on 7/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DecisionVC.h"

@protocol ProcessDataDelegate6 <NSObject>	//---comm
- (void)logIt:(NSString *)whatToLog;		//---comm
@end										//---comm


@interface DecisionContollerVC : UIViewController {

    IBOutlet UITextView *instructionsView;
    IBOutlet UIButton *startButton;

	DecisionVC *dvc;
	
	int wordCount;
	
	NSTimer *timerNoOne;
	NSInteger timeLeft;
	
	BOOL timeUp;
	
	
	id <ProcessDataDelegate6> delegate;		//---comm

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

@property (retain) id delegate;				//---comm

@end
