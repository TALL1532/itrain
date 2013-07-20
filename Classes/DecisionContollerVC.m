    //
//  DecisionContollerVC.m
//  Memory Training
//
//  Created by Andrew Battles on 7/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DecisionContollerVC.h"


@implementation DecisionContollerVC

@synthesize delegate;

- (IBAction)startPressed:(id)sender {
    
	[self launchDecisionGame:wordCount];
}

- (void)launchDecisionGame:(int)numWords {
	[[self delegate] logIt:@"----- DECISION game launched"];
	
	//initialize a category puzzle
	dvc = [[DecisionVC alloc] initWithNibName:@"DecisionVC" bundle:nil];
	[dvc setDelegate:self];									//---comm
	
	//show the game
	[self.navigationController pushViewController:dvc animated:YES];
	
	//set up the number of words
	[dvc setNumOfWords:numWords];
	
	//pick a random category and start puzzle with it
//////////// THIS IS WHERE PROGRAM STARTUP LOGIC WILL GO /////////////////	
	int numCategories = 3; //three wordlists
	int randomCategory = random()%numCategories+1;
	[dvc startPuzzle:randomCategory:wordCount];
	
	[self startTimer:60];
	
}



//////////  Timer Functions //////////////////////////////////////////////

- (void)startTimer:(int)time {
	
	timerNoOne = nil; // ensures we never invalidate an already invalid Timer 
	
	// Create timer
	timerNoOne = [NSTimer scheduledTimerWithTimeInterval:1
												  target:self 
												selector:@selector(updateTimerNoOne:) 
												userInfo:nil 
												 repeats:YES];	
	//set time
	timeLeft = time;	
	//[pvc1 updateTime:timeLeft];
	
	timeUp = NO;
	
	[[self delegate] logIt:[NSString stringWithFormat:@"----- Category training started. Duration: %d seconds",time]];
	//[timerNoOne retain];
	
}

- (void)killTimer {
	[timerNoOne invalidate]; 
	timerNoOne = nil;
	//[timerNoOne release];
}

- (void)updateTimerNoOne:(NSTimer *) timer {
	
	if(timeLeft > 0) {
		
		timeLeft--;
		//[pvc1 updateTime:timeLeft];
	}
	
	else {
		
		[self killTimer];
		[[self delegate] logIt:@"----- Time up!"];
		
		timeUp = YES;
		//wait for the next DecisionVC before we quit everything
	}
}

- (void)categoryTimeUp {
	
	//pop the view controller and tell subject that theyre done for the day
	[self.navigationController popViewControllerAnimated:NO];
	
	[dvc release];
	
	UIAlertView *doneAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Done For Today!" 
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil]; 
	[doneAlert show]; 
	[doneAlert release]; 
}

//////////////////// Delegate Functions ////////////////////////

- (void)decisionEnded:(int)nextNumWords {
	[dvc release];
	NSLog(@"dvc released");
	
	if (timeUp) {
		[self categoryTimeUp];
	}
	else {
		//update the word count for the next puzzle if its within bounds
		if ((nextNumWords > 1) && (nextNumWords < 7)) {
			wordCount = nextNumWords;
		}
		
		[self launchDecisionGame:wordCount];
	}
}

- (void)decisionQuit:(int)nextNumWords {
	[dvc release];
	NSLog(@"decision quit");
	
	
}

////////////////////////// Startup //////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
	
	wordCount = 3;
	timeUp = NO;
	
	//load instructions into instructionView.text
	NSString *instructionsPath = [[NSBundle mainBundle] pathForResource:@"decisionInstructions" ofType:@"txt"];
	NSString *instructions = [NSString stringWithContentsOfFile:instructionsPath
													   encoding:NSUTF8StringEncoding
														  error:nil];
	instructionsView.text = instructions;
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"QUIT" 
											   style:UIBarButtonItemStylePlain
											   target:self
											   action:@selector(quitPressed)] autorelease];
	
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.title = @"Decision Game";
	
}

////////////////////////// SYSTEM /////////////////////////////////////////////

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
	//portrait only
	return ((interfaceOrientation != UIDeviceOrientationLandscapeLeft) &&
			(interfaceOrientation != UIDeviceOrientationLandscapeRight));
	
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
