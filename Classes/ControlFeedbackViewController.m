//
//  ControlFeedbackViewController.m
//  Memory Training
//
//  Created by Thomas Deegan on 8/5/13.
//
//

#import "ControlFeedbackViewController.h"
#import "ControlGroupViewController.h"

@implementation ControlFeedbackViewController

@synthesize delegate = _delegate;

- (IBAction)continuePressed:(UIViewController*)button{
    [_delegate FeedbackControllerContinuePressed:self];
}

- (void)setupFieldsWithNumCorrect:(NSInteger)correct numIncorrect:(NSInteger)incorrect averageTime:(NSTimeInterval)aveTime allowedTime:(NSTimeInterval)allowedTime levelAchieved:(NSInteger)level{
    _topTitle.text = @"Finished Round!";
    _timeScore.text = [NSString stringWithFormat:@"%.02f/%.02f average reaction time", aveTime, allowedTime /1000];
    _correctScore.text = [NSString stringWithFormat:@"%d/%d answers correct", correct, incorrect];
    _totalScore.text = [NSString stringWithFormat:@"Level Achieved: %d",level];
}
- (void)recognizeHighScore{
    _highScoreLabel.hidden = NO;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_delegate FeedbackControllerDoneLoading:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
