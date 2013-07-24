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

@interface ControlGroupViewController : UIViewController {
    NSMutableArray* _inCategroyTrack;
    NSMutableArray* _wordTrack;
    NSInteger _numWords;
    NSString* _currentTask;
    
    int _currentWord;
    
    NSMutableArray* _speedRecords;
    int _totalCorrect;
    
    NSDate* revealTime;
    NSTimeInterval _timePerWord;
    
    BOOL _hasPressedButton;
    
    IBOutlet UIView* countDown;
    IBOutlet UILabel* content;
    IBOutlet UILabel* categoryLabel;
    IBOutlet UIButton* yesButton;
    IBOutlet UIButton* noButton;
    IBOutlet UIImageView* wrong;
    IBOutlet UIImageView* right;
}
-(void)startTask:(NSString*)task;
- (IBAction)yesPressed:(id)sender;
- (IBAction)noPressed:(id)sender;
+(NSMutableArray*)shuffle:(NSMutableArray*)array;
@end

