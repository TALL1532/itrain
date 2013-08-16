//
//  ControlFeedbackViewController.h
//  Memory Training
//
//  Created by Thomas Deegan on 8/5/13.
//
//

#define HIGH_SCORE @"k_highscore_control_group"
#import <UIKit/UIKit.h>
#import "FeedbackDelegate.h"

@interface ControlFeedbackViewController : UIViewController {
    id <FeedbackDelegate> _delegate;
    IBOutlet UILabel* _topTitle;
    IBOutlet UILabel* _correctScore;
    IBOutlet UILabel* _timeScore;
    IBOutlet UILabel* _totalScore;
    IBOutlet UILabel* _highScoreLabel;
}

@property (nonatomic, retain) id <FeedbackDelegate> delegate;

- (IBAction)continuePressed:(id)button;

- (void)setupFieldsWithNumCorrect:(NSInteger)correct numIncorrect:(NSInteger)incorrect averageTime:(NSTimeInterval)aveTime allowedTime:(NSTimeInterval)allowedTime levelAchieved:(NSInteger)level;
- (void)recognizeHighScore;
@end

