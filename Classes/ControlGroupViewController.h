//
//  ControlGroupViewController.h
//  Memory Training
//
//  Created by Thomas Deegan on 7/23/13.
//
//

#define category @"CATEGORY_TASK"
#define decision @"DECISION_TASK"
#define sentence @"SENTENCE_TASK"

#import <UIKit/UIKit.h>
#import "CategoryControllerVC.h"
#import "DecisionVC.h"
#import "SentenceVC.h"
#import "AdminScreenVC.h"
#import "ControlFeedbackViewController.h"
#import "FeedbackDelegate.h"
#import "ModalInstructionsViewController.h"
#import "LoggingSingleton.h"

@interface ControlGroupViewController : UIViewController <FeedbackDelegate, ModalInstructionControlGroup> {
    NSMutableArray* _inCategroyTrack;
    NSMutableArray* _wordTrack;
    NSInteger _numWords;
    NSString* _currentTask;
    
    NSInteger _currentWord;
    NSInteger _currentBlock;
    NSInteger _currentTrial;
    
    
    NSMutableArray* _speedRecords;
    NSInteger _totalCorrect;
    
    NSDate* revealTime;
    NSTimeInterval _timePerWord;
    
    BOOL _hasPressedButton;
        
    NSTimeInterval _timeForTask;
    NSDate * _startTime;
    
    
    IBOutlet UIView* countDown;
    IBOutlet UILabel* content;
    IBOutlet UILabel* categoryLabel;
    IBOutlet UILabel* levelIndicatorLabel;
    IBOutlet UIButton* yesButton;
    IBOutlet UIButton* noButton;
    IBOutlet UIImageView* wrong;
    IBOutlet UIImageView* right;
}

@property (nonatomic, retain) id <ProperDataProtocol> delegate;

- (void)startTask:(NSString*)task;
- (IBAction)yesPressed:(id)sender;
- (IBAction)noPressed:(id)sender;
+ (NSMutableArray*)shuffle:(NSMutableArray*)array;
+ (NSTimeInterval)getTimeForWordInTask:(NSString*)task;
+ (NSInteger)getTaskLevel:(NSString*)task;
+ (void)increaseLevelForWordInTask:(NSString*)task;
+ (void)decreaseLevelForWordInTask:(NSString*)task;
+ (bool)checkHighScoreByLevel:(NSInteger)level andTask:(NSString*)task;

@end

