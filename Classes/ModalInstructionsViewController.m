//
//  ModalInstructionsViewController.m
//  Memory Training
//
//  Created by Thomas Deegan on 8/11/13.
//
//

#import "ModalInstructionsViewController.h"
#define padding 10.0
@interface ModalInstructionsViewController ()

@end

@implementation ModalInstructionsViewController

@synthesize delegate = _delegate;

-(void)donePressed:(id)sender{
    [_delegate doneWithInstructions:self];
    [self dismissViewControllerAnimated:NO completion:nil];

}
-(void)setText:(NSString *)instructons{
    _instructions.text = instructons;
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
    _instructions = [[UITextView alloc] initWithFrame:CGRectMake(padding, padding, 540 - 2* padding, 620 - 40.0 - 3*padding)];
    _instructions.text = @"NO INSTRUCTIONS PROVIDED";
    _instructions.font = [UIFont fontWithName:@"Arial" size:20.0];
    [self.view addSubview:_instructions];
    [_instructions release];
    
    UIButton* doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [doneButton setTitle:@"Got It!" forState:UIControlStateNormal];
    doneButton.frame = CGRectMake( padding, 620.0 - 40.0 - padding, 70.0, 40.0);
    [doneButton addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.93 green:0.94 blue:0.95 alpha:1.0]];
    [self.view addSubview:doneButton];
    [doneButton release];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
