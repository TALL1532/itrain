    //
//  DecisionControllerVC.m
//  Memory Training
//
//  Created by Andrew Battles on 7/30/12 modified by Thomas Deegan on 3/11/2013
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DecisionControllerVC.h"
#import "LoggingSingleton.h"

@implementation DecisionControllerVC

@synthesize delegate;

- (IBAction)startPressed:(id)sender {
    
	[[self delegate] logIt:@"----- START pressed"];
	[self launchDecisionGame:wordCount];
	
	int startTime = isRecovering? [[LoggingSingleton getRecoverySectionTimeLeft] integerValue ]: [[self delegate] getTime];
	[self startTimer:startTime];
    
}

- (void)launchDecisionGame:(int)numWords {
	[[self delegate] logIt:[NSString stringWithFormat:@"----- Decision game launched. Words: %d",numWords]];
	[[self delegate] changeDecisionWordNum:numWords];
	
	//initialize a category puzzle
	dvc = [[DecisionVC alloc] initWithNibName:@"DecisionVC" bundle:nil];
	[dvc setDelegate:self];
    [dvc view];
	
	[self.navigationController pushViewController:dvc animated:YES];
	
	//set up the number of words
	[dvc setNumOfWords:numWords];
	
	//pick a random category and start puzzle with it
	
	//////////// GAME STARTUP LOGIC /////////////////
	int numCategories = 3; //three wordlists
	int randomCategory = arc4random()%numCategories+1;
	
	[dvc startPuzzle:randomCategory withWords:wordCount];
    
    [dvc release];
	//show the game
	
}


//////////  Timer Functions //////////////////////////////////////////////

- (void)startTimer:(int)time {
	
	[timerNoOne invalidate];
	timerNoOne = nil; // ensures we never invalidate an already invalid Timer 
	
	// Create timer
	timerNoOne = [NSTimer scheduledTimerWithTimeInterval:1.0
												  target:self 
												selector:@selector(updateTimerNoOne:) 
												userInfo:nil 
												 repeats:YES];	
	//set time
	timeLeft = time;	
	//[pvc1 updateTime:timeLeft];
	
	timeUp = NO;
	
	[[self delegate] logIt:[NSString stringWithFormat:@"----- Decision training started. Duration: %d seconds",time]];
	//[timerNoOne retain];
	
}

- (void)killTimer {
	NSLog(@"killTimer");
	
	[timerNoOne invalidate];
	timerNoOne = nil;
	//[timerNoOne release];
}

- (void)updateTimerNoOne:(NSTimer *) timer {
    [LoggingSingleton setRecoveryTime:[NSDate date]];
    [LoggingSingleton setRecoverySectionTimeLeft:[NSNumber numberWithInt:timeLeft]];
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

- (void)decisionTimeUp {
    
    [recoveryTimer invalidate];

	[[self delegate] logIt:@"----- Training finished"];
	
	//pop the view controller back to main screen
	[self.navigationController popViewControllerAnimated:NO];
	[[self delegate] checkDoneForToday];
		
}

//////////////////// Delegate Functions ////////////////////////

- (void)decisionEnded:(int)nextNumWords {

	
	if (timeUp) {
		[self decisionTimeUp];
		if ((nextNumWords > [delegate getMinWords]-1) && (nextNumWords < [delegate getMaxWords]+1)) {
			[[self delegate] changeDecisionWordNum:nextNumWords];
		}
	}
	else {
		//update the word count for the next puzzle if its within bounds
		if ((nextNumWords > [delegate getMinWords]-1) && (nextNumWords < [delegate getMaxWords]+1)) {
			wordCount = nextNumWords;
			[[self delegate] changeDecisionWordNum:nextNumWords];
		}
		[LoggingSingleton sharedSingleton].currentTrial++;
		[self launchDecisionGame:wordCount];
	}
}

- (void)decisionQuit:(int)nextNumWords {
	[dvc release];
	if (!timeUp) {
		[self killTimer];
	}
	[self.navigationController popViewControllerAnimated:NO];
	[[self delegate] checkDoneForToday];
}

- (void)quitPressed {
	[self logIt:@"----- QUIT pressed in Decision start screen"];
	[self.navigationController popViewControllerAnimated:NO];
	[dvc release];
	[[self delegate] checkDoneForToday];
}

- (void)logIt:(NSString *)whatToLog {
	
	[[self delegate] logIt:whatToLog];
}

- (void)timerFired:(NSTimer *)timer{
}

- (void)recover{
    isRecovering = true;
    [self performSelector:@selector(startPressed:)];

    ///[startButton sendActionsForControlEvents: UIControlEventTouchUpInside];
    //[svc recover];
}
////////////////////////// Startup //////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    isRecovering = false;
    recoveryTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];

	wordCount = [[self delegate] getDecisionWordNum];
	timeUp = NO;
	
	//load instructions into instructionView.text
	NSString *instructionsPath = [[NSBundle mainBundle] pathForResource:@"decisionInstructions" ofType:@"txt"];
	NSString *instructions = [NSString stringWithContentsOfFile:instructionsPath
													   encoding:NSUTF8StringEncoding
														  error:nil];
	instructionsView.text = instructions;
	
	/*self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"QUIT" 
											   style:UIBarButtonItemStylePlain
											   target:self
											   action:@selector(quitPressed)] autorelease];
     */
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.title = @"Instructions";
	
    [LoggingSingleton sharedSingleton].currentTrial = 0;
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
