//
//  AdminScreenVC.h
//  Memory Training
//
//  Created by Andrew Battles on 8/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewLog.h"

@protocol ProcessDataDelegate10 <NSObject>	//---comm
- (void)logIt:(NSString *)whatToLog;		//---comm
@end										//---comm

@interface AdminScreenVC : UIViewController <UITextFieldDelegate,MFMailComposeViewControllerDelegate> {
    IBOutlet UITextField *categoryWordsField;
    IBOutlet UITextField *dateField;
    IBOutlet UITextField *daysField;
    IBOutlet UITextField *decisionWordsField;
    IBOutlet UITextField *maxWordsField;
    IBOutlet UITextField *minWordsField;
    
    IBOutlet UITextField *categoryTime;
    IBOutlet UITextField *decisionWordTime;
    IBOutlet UITextField *decisionLetterTime;
    IBOutlet UITextField *sentenceTime;
    
    IBOutlet UIButton *saveButton;
    IBOutlet UITextField *sentenceWordsField;
    IBOutlet UITextField *tagField;
    IBOutlet UITextField *timeField;
    IBOutlet UITextField *daysPlayedField;
    IBOutlet UIButton *clearStateButton;

    IBOutlet UISwitch *mainMenuButtonsVisibleSwitch;
	ViewLog *viewLog;
	
	id <ProcessDataDelegate10> delegate;		//---comm
}
- (IBAction)savePressed:(id)sender;
- (IBAction)clearStatePressed:(id)sender;
- (IBAction)emailRecordsPressed:(id)sender;

- (void)saveSettings;
- (void)loadSettings;
- (NSString *)getDocumentsDirectory;

- (void)changeCategoryWords:(int)numWords;
- (void)changeDecisionWords:(int)numWords;
- (void)changeSentenceWords:(int)numWords;
- (void)changeDatePlayedLast:(NSString *)date;
- (void)incrementDaysPlayedSoFar;
- (void)clearStateForNewSubject;


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error;

// return new state info
- (NSString *)getTag;
- (float)getTimePerRound;
- (int)getMinWords;
- (int)getMaxWords;
- (int)getDaysToPlay;
- (int)getDaysPlayedSoFar;

- (int)getCategoryWords;
- (int)getDecisionWords;
- (int)getSentenceWords;
- (NSString *)getDateLastPlayed;

- (void)showLogPressed;
- (void)endLog;

+ (NSInteger)getVarForKey:(NSString*)key;
+ (BOOL)shouldShowMainMenuItems;
- (IBAction)switchToggled:(id)sender;

@property (retain) id delegate;				//---comm

@end
