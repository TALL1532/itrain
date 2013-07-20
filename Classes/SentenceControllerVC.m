    //
//  SentenceControllerVC.m
//  Memory Training
//
//  Created by Andrew Battles on 8/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SentenceControllerVC.h"
#import "LoggingSingleton.h"

@implementation SentenceControllerVC

@synthesize delegate;

- (IBAction)startPressed:(id)sender {
	
	[[self delegate] logIt:@"----- START pressed"];
    [self launchSentenceGame:wordCount];
	
	int startTime = isRecovering? [[LoggingSingleton getRecoverySectionTimeLeft] integerValue ]: [[self delegate] getTime];
	[self startTimer:startTime];
}

- (void)launchSentenceGame:(int)numWords {
	[[self delegate] logIt:[NSString stringWithFormat:@"----- Sentence game launched. Words: %d",numWords]];
	[[self delegate] changeSentenceWordNum:numWords];
	
	//initialize a category puzzle
	svc = [[SentenceVC alloc] initWithNibName:@"SentenceVC" bundle:nil];
	[svc setDelegate:self];									//---comm
	[svc view];
    
	//show the game
	[self.navigationController pushViewController:svc animated:YES];
	
	//set up the number of words
	[svc setNumOfWords:numWords];
	
	//pick a random category and start puzzle with it
	
	//////////// GAME STARTUP LOGIC /////////////////	
	int numCategories = 2; //true or false
	int randomCategory = arc4random()%numCategories+1;
	
	[svc startPuzzle:randomCategory withWords:wordCount];
	[svc release];
		
}


//////////  Timer Functions //////////////////////////////////////////////

- (void)startTimer:(int)time {
	
	[timerNoOne invalidate];
	timerNoOne = nil; // ensures we never invalidate an already invalid Timer 
	
	// Create timer
	timerNoOne = [NSTimer scheduledTimerWithTimeInterval:1
												  target:self 
												selector:@selector(updateTimerNoOne:) 
												userInfo:nil 
												 repeats:YES];	
	//set time
	timeLeft = time;		
	timeUp = NO;
	
	[[self delegate] logIt:[NSString stringWithFormat:@"----- Sentence training started. Duration: %d seconds",time]];
	
}

- (void)killTimer {
	NSLog(@"killTimer");
	[timerNoOne invalidate]; 
	timerNoOne = nil;
}

- (void)updateTimerNoOne:(NSTimer *) timer {
    [LoggingSingleton setRecoveryTime:[NSDate date]];
    [LoggingSingleton setRecoverySectionTimeLeft:[NSNumber numberWithInt:timeLeft]];
	if(timeLeft > 0) {
		
		timeLeft--;
	}
	
	else {
        [self killTimer];
		[[self delegate] logIt:@"----- Time up!"];
		
		timeUp = YES;
		//wait for the next SentenceVC before we quit everything
	}
}

- (void)sentenceTimeUp {
	[recoveryTimer invalidate];
	[[self delegate] logIt:@"----- Training finished"];
	
	//pop the view controller back to main screen
	[self.navigationController popViewControllerAnimated:NO];
	[[self delegate] checkDoneForToday];
		
}

/////////////// Delegate Functions ///////////////////////////

- (void)sentenceEnded:(int)nextNumWords {

	if (timeUp) {
		[self sentenceTimeUp];
		if ((nextNumWords > [delegate getMinWords]-1) && (nextNumWords < [delegate getMaxWords]+1)) {
			[[self delegate] changeSentenceWordNum:nextNumWords];
		}
	}
	else {
		//update the word count for the next puzzle if its within bounds
		if ((nextNumWords > [delegate getMinWords]-1) && (nextNumWords < [delegate getMaxWords]+1)) {
			wordCount = nextNumWords;
			[[self delegate] changeSentenceWordNum:nextNumWords];
		}
		[LoggingSingleton sharedSingleton].currentTrial++;
		[self launchSentenceGame:wordCount];
	}
}

- (void)sentenceQuit:(int)nextNumWords {
	[svc release];
	if (!timeUp) {
		[self killTimer];
	}
	[self.navigationController popViewControllerAnimated:NO];
	[[self delegate] checkDoneForToday];
}


- (void)quitPressed {
	
	[self logIt:@"----- QUIT pressed in Sentence start screen"];
	[self.navigationController popViewControllerAnimated:NO];
	[svc release];
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
//    [startButton sendActionsForControlEvents: UIControlEventTouchUpInside];
    //[svc recover];
}
////////////////////////// Startup //////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    isRecovering = false;
    recoveryTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];

	wordCount = [[self delegate] getSentenceWordNum];
	timeUp = NO;
	
	//load instructions into instructionView.text
	NSString *instructionsPath = [[NSBundle mainBundle] pathForResource:@"sentenceInstructions" ofType:@"txt"];
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
