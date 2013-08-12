//
//  AdminScreenVC.h
//  Memory Training
//
//  Created by Andrew Battles on 8/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewLog.h"
#import "SettingsManager.h"

#define SUBJECT_NAME @"k_subjectName"
#define CATEGORY_PRESENTATION_TIME @"k_categoryPresentationTime"
#define DECISION_PRESENTATION_TIME @"k_decisionWordTime"
#define DECISION_PRESENTATION_LETTER_TIME @"k_decisionLetterTime"
#define SENTENCE_PRESENTATION_TIME @"k_sentencePresentationTime"
#define TASK_TIME @"k_TaskTime"
#define CONTROL_GROUP_ON_BOOL @"k_control_group_is_on"
#define CONTROL_GROUP_REDUCTION_TIME_FLOAT @"k_control_group_reduction"
#define CONTROL_GROUP_NUM_WORDS_INT @"k_control_group_num_words"
#define CONTROL_GROUP_NUM_NEEDED_TO_ADVANCE_INT @"k_control_group_promote_threshhold"
#define CONTROL_GROUP_NUM_NEEDED_TO_DEMOTE_INT @"k_control_group_demote_threshhold"

#define CONTROL_GROUP_CATEGROY_DIFFICULTY_LEVEL_INT @"k_control_group_level_category"
#define CONTROL_GROUP_DECISION_DIFFICULTY_LEVEL_INT @"k_control_group_level_dec"
#define CONTROL_GROUP_SENTENCE_DIFFICULTY_LEVEL_INT @"k_control_group_level_sentence"




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
    
    IBOutlet UISwitch *controlGroupSwitch;
    IBOutlet UITextField* controlGroupReductionField;
    IBOutlet UITextField* controlGroupTotalNeededField;
    IBOutlet UITextField* controlGroupTotalNeededDemoteField;
    IBOutlet UITextField* controlGroupWordsPerRoundField;
    
    IBOutlet UITextField* controlGroupDiffIncrease;
    IBOutlet UITextField* controlGroupCategoryLevel;
    IBOutlet UITextField* controlGroupDecisionLevel;
    IBOutlet UITextField* controlGroupSentenceLevel;


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
