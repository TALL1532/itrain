//
//  ControlFeedbackViewController.m
//  Memory Training
//
//  Created by Thomas Deegan on 8/5/13.
//
//

#import "ControlFeedbackViewController.h"

@implementation ControlFeedbackViewController

@synthesize delegate = _delegate;

- (IBAction)continuePressed:(UIViewController*)button{
    [_delegate FeedbackControllerContinuePressed:self];
}

- (void)setupFieldsWithNumCorrect:(NSInteger)correct numIncorrect:(NSInteger)incorrect averageTime:(NSTimeInterval)aveTime andAllowedTime:(NSTimeInterval)allowedTime{
    _topTitle.text = @"Finished Round!";
    _timeScore.text = [NSString stringWithFormat:@"%.02f/%.02f average time", aveTime, allowedTime];
    _correctScore.text = [NSString stringWithFormat:@"%d/%d answers correct", correct, incorrect];
    _totalScore.text = @"hmmm there must be some way to combine these";
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
