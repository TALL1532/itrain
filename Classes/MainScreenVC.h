//
//  MainScreenVC.h
//  Memory Training
//
//  Created by Andrew Battles on 7/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewLog.h"
#import "CategoryControllerVC.h"
#import "DecisionControllerVC.h"
#import "SentenceControllerVC.h"
#import "ControlGroupViewController.h"
#import "AdminScreenVC.h"
#import "AlertPrompt.h"
#import "ProperDataProtocol.h"

@interface MainScreenVC : UIViewController <ProperDataProtocol>{
    IBOutlet UIButton *categoryButton;
    IBOutlet UIButton *realFakeButton; // seriously? -_-
    IBOutlet UIButton *sentencesButton;
    IBOutlet UITextView *instructionsView;
    IBOutlet UIButton *playNextButton;
	
	//ViewLog *viewLog;
	AdminScreenVC *asvc;
	CategoryControllerVC *ccvc;
	DecisionControllerVC *dcvc;
	SentenceControllerVC *scvc;
	
	int countForToday;
	NSMutableArray *todaysOrder;

}
- (IBAction)categoryPressed:(id)sender;
- (IBAction)realFakePressed:(id)sender;
- (IBAction)sentencesPressed:(id)sender;
- (IBAction)playNextPressed:(id)sender;

- (void)launchCategoryGame;
- (void)launchDecisionGame;
- (void)launchSentencesGame;

// tracking functions

- (void)mainScreenShown;
- (void)setupDay;
- (void)resetSubjectDays;
- (bool)checkDoneForToday;

- (BOOL)checkDate;

// delegate functions
- (NSString *)getTag;
- (int)getTime;
- (int)getCategoryWordNum;
- (int)getDecisionWordNum;
- (int)getSentenceWordNum;
- (NSString *)getCurrentDate;

- (int)getMaxWords;
- (int)getMinWords;

// settings functions
- (void)changeCategoryWordNum:(int)number;
- (void)changeDecisionWordNum:(int)number;
- (void)changeSentenceWordNum:(int)number;
- (void)updateDateLastPlayed;

//log functions
- (void)logIt:(NSString *)whatToLog;
- (NSString *)getDocumentsDirectory;
- (void)adminPressed;

- (void)recoverSession;


@end
