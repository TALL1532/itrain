    //
//  FeedbackScreenVC.m
//  Memory Training
//
//  Created by Andrew Battles on 7/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "FeedbackScreenVC.h"
#import "LoggingSingleton.h"

@implementation FeedbackScreenVC

@synthesize delegate;												//---comm

- (IBAction)readyForNextPressed:(id)sender {
	[[self delegate] logIt:@"----- READY FOR NEXT SET pressed in feedback"];
	
	[self.navigationController popViewControllerAnimated:NO];
    [[self delegate] feedbackEnded:nextWordCount];
}

- (void)displayResults:(NSInteger)numCorrect withTotal:(NSInteger)numTotal withType:(NSString *)typeOfNum withErrors:(NSInteger)numErrors andErrorType:(NSString *)typeOfError{
	//NSLog(@"FeedbackScreenVC: displayResults");
	
	NSInteger numTotalCorrect = numCorrect + (numTotal-numErrors);
	
	float fractionCorrect = numTotalCorrect/1.0/(numTotal*2); //divide by 1.0 to keep a float value
	NSLog(@"fractionCorrect: %f",fractionCorrect);
	
	
	//fill out the fields
	NSString *congrats;
	if (((numTotal-numCorrect) < 1) && (numErrors < 1)) { //if all correct
		congrats = [NSString stringWithFormat:@"Nice Job!"];
		nextWordCount = numTotal+1;
	}
	else {
		if ((numCorrect+1 >= numTotal) && (numErrors <= 1))  { //if they only missed one of either 
			congrats = [NSString stringWithFormat:@"Almost!"];
			nextWordCount = numTotal;
		}
		else {
			congrats = [NSString stringWithFormat:@"Whoops"];
			nextWordCount = numTotal-1;
		}
	}
	congratsLabel.text = congrats;
	
	NSString *feedbackText = [NSString stringWithFormat:@"You remembered %ld %@ correctly out of %ld",numCorrect,typeOfNum,numTotal];
	correctWordsView.text = feedbackText;
	
	NSInteger percentCorrect = fractionCorrect*100;
	percentCorrectLabel.text = [NSString stringWithFormat:@"%ld%%",percentCorrect];
	
	NSString *classFeedbackText = [NSString stringWithFormat:@"You made %ld %@ error(s) this set",numErrors,typeOfError];
	correctClassLabel.text = classFeedbackText;
	
	[[self delegate] logIt:@"----- Displaying results:"];
	[[self delegate] logIt:[NSString stringWithFormat:@"----- %ld/%ld %@ correct",numCorrect,numTotal,typeOfNum]];
	[[self delegate] logIt:[NSString stringWithFormat:@"----- %ld %@ error(s)",numErrors,typeOfError]];
    
    NSDateFormatter *date_formatter=[[NSDateFormatter alloc] init];
	[date_formatter setDateFormat:@"MM.dd.yyyy - HH:mm:ss.SSS "];
	
	NSString *readDate = [date_formatter stringFromDate:[NSDate date]];
    [date_formatter release];
	[[LoggingSingleton sharedSingleton] storeTrialDataWithName:[LoggingSingleton getSubjectName] task:[LoggingSingleton sharedSingleton].currentCategory sessionNumber:[LoggingSingleton getSessionNumber] date:readDate trial:[LoggingSingleton sharedSingleton].currentTrial taskAccuracy:1.0-(numErrors/(float)numTotal) averageReactionTime:0 memoryAccuracy:numCorrect/(float)numTotal andSpanLevel:numTotal];  //zeroes will be set in the singleton
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSLog(@"FeedbackScreenVC: viewDidLoad");
	self.navigationItem.title = @"Feedback Screen";
	self.navigationItem.hidesBackButton = YES;
	
    [self displayResults:self.numCorrect withTotal:self.numTotal withType:self.type withErrors:self.numErrors andErrorType:self.typeOfError];
}



- (BOOL)shouldAutorotateToNSIntegererfaceOrientation:(UIInterfaceOrientation)NSIntegererfaceOrientation {
    
	//portrait only
	return ((NSIntegererfaceOrientation != UIDeviceOrientationLandscapeLeft) &&
			(NSIntegererfaceOrientation != UIDeviceOrientationLandscapeRight));
	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
