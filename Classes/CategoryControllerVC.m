    //
//  CategoryControllerVC.m
//  Memory Training
//
//  Created by Andrew Battles on 7/29/12 Modified by Thomas Deegan 04/09/2013.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryControllerVC.h"
#import "LoggingSingleton.h"

@implementation CategoryControllerVC

@synthesize delegate;

- (IBAction)startPressed:(id)sender {
	
	[[self delegate] logIt:@"----- START pressed"];
	
    [self launchCategoryGame:wordCount];
	
	int startTime = isRecovering? [[LoggingSingleton getRecoverySectionTimeLeft] integerValue ]: [[self delegate] getTime];
	[self startTimer:startTime];
}

+ (int)chooseCategory {
    //This method returns a category number between 0-48 that is an unused category which is persistent between applications cycles.
    NSMutableArray *usedCats = [(NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"__usedCategoryArray" ] mutableCopy];
    int numCategories = 49; //50 wordlists
	int randomCategory = arc4random()%numCategories;
    if([usedCats count] == 0){
        //no array was initialized so make one
        NSMutableArray *newUsed = [[NSMutableArray alloc] init];
        for ( int i = 1 ; i <= numCategories ; i ++ )
            [newUsed addObject:[NSNumber numberWithBool:false]];
        usedCats = [newUsed mutableCopy];
        [newUsed release];
    }
    else{
        bool isFull = true;
        for(int i = 0; i < numCategories; i++){
            if(![(NSNumber*)[usedCats objectAtIndex:i] boolValue]){
                isFull = false;
                break;
            }
        }
        if(isFull){
            for ( int i = 1 ; i < numCategories ; i ++ )
                [usedCats replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:false]];
        }
        //find an unused category and use it
        randomCategory = arc4random()%numCategories;
        while([(NSNumber*)[usedCats objectAtIndex:randomCategory] boolValue]){
            randomCategory = arc4random()%numCategories;
        }
        [usedCats replaceObjectAtIndex:randomCategory withObject:[NSNumber numberWithBool:true]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:usedCats forKey:@"__usedCategoryArray" ];
    [usedCats release];
    return randomCategory;
}
- (void)launchCategoryGame:(int)numWords {
	[[self delegate] logIt:[NSString stringWithFormat:@"----- Category game launched. Words: %d",numWords]];
	
	//initialize a category puzzle
	cvc = [[CategoryVC alloc] initWithNibName:@"CategoryVC" bundle:nil];
	[cvc setDelegate:self];									//---comm
	[cvc view];
	//show the category game
	[self.navigationController pushViewController:cvc animated:YES];

	//set up the number of words
	[cvc setNumOfWords:numWords];
	
	//pick a random category and start puzzle rwith it
	NSLog(@"about to start puzzle in controller");
	[cvc startPuzzle:[CategoryControllerVC chooseCategory] withWords:wordCount];
    [cvc release];
	//
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
	//[pvc1 updateTime:timeLeft];
	
	timeUp = NO;
	
	[[self delegate] logIt:[NSString stringWithFormat:@"----- Category training started. Duration: %d seconds",time]];
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
		//wait for the next CategoryVC before we quit everything
	}
}

- (void)categoryTimeUp {
    [recoveryTimer invalidate];

	[[self delegate] logIt:@"----- Training finished"];
	
	//pop the view controller back to main screen
	[self.navigationController popViewControllerAnimated:NO];
	[[self delegate] checkDoneForToday];
	
}

/////////////// Delegate Functions ///////////////////////////

- (void)categoryEnded:(int)nextNumWords {
	
	if (timeUp) {
		[self categoryTimeUp];
		if ((nextNumWords > [delegate getMinWords]-1) && (nextNumWords < [delegate getMaxWords]+1)) {
			[[self delegate] changeCategoryWordNum:nextNumWords];
		}
	}
	else {
		//update the word count for the next puzzle if its within bounds
		if ((nextNumWords > [delegate getMinWords]-1) && (nextNumWords < [delegate getMaxWords]+1 )) {
			wordCount = nextNumWords;
			[[self delegate] changeCategoryWordNum:nextNumWords];
		}
		[LoggingSingleton sharedSingleton].currentTrial++;
		[self launchCategoryGame:wordCount];
	}
}

- (void)categoryQuit:(int)nextNumWords {
	[cvc release];
	if (!timeUp) {
		[self killTimer];
	}
	[self.navigationController popViewControllerAnimated:NO];
	[[self delegate] checkDoneForToday];
}

- (void)quitPressed {
	[self logIt:@"----- QUIT pressed in Category start screen"];
	[self.navigationController popViewControllerAnimated:NO];
	[cvc release];
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

}
//////////////////// SYSTEM ////////////////////////////

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    isRecovering = false;
    recoveryTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
	wordCount = [[self delegate] getCategoryWordNum];
	
	//load instructions into instructionView.text
	NSString *instructionsPath = [[NSBundle mainBundle] pathForResource:@"categoryInstructions" ofType:@"txt"];
	NSString *instructions = [NSString stringWithContentsOfFile:instructionsPath
													   encoding:NSUTF8StringEncoding
														  error:nil];
	instructionsView.text = instructions;
	
	/*self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"QUIT" 
											   style:UIBarButtonItemStylePlain
											   target:self
											   action:@selector(quitPressed)] autorelease];*/
	
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.title = @"Instructions";
    
    [LoggingSingleton sharedSingleton].currentTrial = 1;
	
}

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
