    //
//  CategoryVC.m
//  Memory Training
//
//  Created by Andrew Battles on 7/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoryVC.h"
#import "AdminScreenVC.h"
#import "LoggingSingleton.h"

@implementation CategoryVC

@synthesize delegate;												//---comm

- (IBAction)inCategoryPressed:(id)sender {
    if(!buttonPressed){
        buttonPressed = true;
    
        [[self delegate] logIt:@"----- IN-CATEGORY pressed"];
        NSLog(@"bleh");
        [self buttonPressed:YES];
    }
}

- (IBAction)notCategoryPressed:(id)sender {
    if(!buttonPressed){
        buttonPressed = true;
        [[self delegate] logIt:@"----- NOT-IN-CATEGORY pressed"];
        NSLog(@"blah");

        [self buttonPressed:NO];
    }
}

- (void)buttonPressed:(BOOL)inCategory {
	
    [inCategoryButton setHidden:YES];
    [notCategoryButton setHidden:YES];
	//show the word again, in case it had been hidden
	//[thisWordView setHidden:NO];
	
    [[LoggingSingleton sharedSingleton].timeAverages addObject:[NSNumber numberWithDouble:[wordShown timeIntervalSinceNow]]];

	//disable the buttons until we're ready for the next word
	[inCategoryButton setEnabled:NO];
	[notCategoryButton setEnabled:NO];
	
	//show the indicator to tell if theyre correct
	UniChar specialChar; //indicates correct or not
	UIColor *textColor;	 //indicates correct or not
	int xPos;			 //puts above button pressed
	
	//initialize location, color, and text of correct-indicator
	if (inCategory) {
		xPos = 150;
		if ([[inCategoryTrack objectAtIndex:currentWordNum] intValue]) {
			specialChar = 0x2713; // check mark
			textColor = [UIColor colorWithRed:0.1 green:0.8 blue:0.1 alpha:1.0]; //dark green
			[correctChoiceTrack addObject:[NSNumber numberWithInt:1]];
			[[self delegate] logIt:@"----- Correct choice made"];
		}
		else {
			specialChar = 0x2718; // X-mark
			textColor = [UIColor redColor];
			[correctChoiceTrack addObject:[NSNumber numberWithInt:0]];
			[[self delegate] logIt:@"----- Incorrect choice made"];
		}
	}
	else {
		xPos = 490; 
		if ([[inCategoryTrack objectAtIndex:currentWordNum] integerValue] != 1) {
			specialChar = 0x2713; // check mark
			textColor = [UIColor colorWithRed:0.1 green:0.8 blue:0.1 alpha:1.0]; //dark green
			[correctChoiceTrack addObject:[NSNumber numberWithInt:1]];
			[[self delegate] logIt:@"----- Correct choice made"];
		}
		else {
			specialChar = 0x2718; // X-mark
			textColor = [UIColor redColor];
			[correctChoiceTrack addObject:[NSNumber numberWithInt:0]];
			[[self delegate] logIt:@"----- Incorrect choice made"];
		}
	}
	
	//set the varables above and show indicator for [delay] seconds
	NSString *specialString = [NSString stringWithCharacters:&specialChar length:1];
	correctIndicator.text = specialString;
	correctIndicator.textColor = textColor;
	correctIndicator.frame = CGRectMake(xPos, correctIndicator.frame.origin.y, 
										correctIndicator.frame.size.width, correctIndicator.frame.size.height);

	[correctIndicator setHidden:NO];
	float delay = 1.0;
	currentWordNum++;
	[self performSelector:@selector(displayNextWord) withObject:nil afterDelay:delay];
	
}

- (void)setNumOfWords:(int)numWords {
	wordsThisRound = numWords;
}

- (void)startPuzzle:(int)categoryNum withWords:(int)numWords {
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"category-data" ofType:@"plist"];
    NSArray * contentArray = [NSArray arrayWithContentsOfFile:plistPath];
	
	self.navigationItem.title = [NSString stringWithFormat:@"%d Words",numWords];
    
    NSString *titleString = [(NSDictionary*)[contentArray objectAtIndex:categoryNum] objectForKey:@"title"]; //TODO: check what values come here!
    [categoryLabel setText:[NSString stringWithFormat:@"Category: %@",titleString]];
    
    NSMutableArray *wrongCategories = [[NSMutableArray alloc] init];
	NSInteger notInCatIndex;
    for(int i =0; i< 3; i++){
        notInCatIndex = arc4random()%[contentArray count];
        while(notInCatIndex == categoryNum){
            notInCatIndex = arc4random()%[contentArray count];
        }
        [wrongCategories addObject:[NSNumber numberWithInt:notInCatIndex]];
    }
    NSString *content = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: [(NSDictionary*)[contentArray objectAtIndex:categoryNum] objectForKey:@"filename"] ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    NSArray * inCategory = [content componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
    
    NSArray * notInCategory = [[[NSArray alloc] init] autorelease];
    for(int i = 0; i < [wrongCategories count]; i++){
        NSString *contentwrong = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: [(NSDictionary*)[contentArray objectAtIndex: [(NSNumber*)[wrongCategories objectAtIndex:i] integerValue]] objectForKey:@"filename"] ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
                                  

        notInCategory = [notInCategory arrayByAddingObjectsFromArray: [contentwrong componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]]];
    }
	[wrongCategories release];
    wrongCategories = nil;
    
	correctChoiceTrack = [[NSMutableArray alloc] init];
	inCategoryTrack = [[NSMutableArray alloc] init];
	wordsArray = [[NSMutableArray alloc] init];
	
	for (int i=0; i<numWords; i++) {
		//first, pick if the word is going to be in the category or not by a random binary choice
		NSInteger categoryDecider = arc4random()%2;
		[inCategoryTrack addObject:[NSNumber numberWithInt:categoryDecider]];
        NSString *wordToAdd;
        do{
            if(categoryDecider){
                wordToAdd = [inCategory objectAtIndex:arc4random()%[inCategory count]];
            }
            else{
                wordToAdd = [notInCategory objectAtIndex:arc4random()%[notInCategory count]];
            }
        }while ([wordsArray indexOfObject:wordToAdd] != NSNotFound);
        [wordsArray addObject:wordToAdd];
    }

	NSLog(@"for loop exited");
	// log everything (words & category tracker)
	[self logIt:@"----- Starting category game"];
	[self logIt:[NSString stringWithFormat:@"----- Category: %@",titleString]];
	[self logIt:@"----- Words this round:"];
	for (int i=0; i<numWords; i++) {
		if ([[inCategoryTrack objectAtIndex:i] integerValue]) {
			[self logIt:[NSString stringWithFormat:@"----- Word %d: %@ -- IN-category",i+1,[wordsArray objectAtIndex:i]]];
		}
		else {
			[self logIt:[NSString stringWithFormat:@"----- Word %d: %@ -- NOT-in-category",i+1,[wordsArray objectAtIndex:i]]];
		}
	}
	
	//now that we have the words, order, and in-category tracker, display the first frame
	currentWordNum = 0;
	[self displayNextWord];
}

- (void)displayNextWord { 
    
	if (currentWordNum < wordsThisRound) {
        [inCategoryButton setHidden:NO];
        [notCategoryButton setHidden:NO];
        [thisWordView setHidden:NO];
        buttonPressed = false;
		[self logIt:[NSString stringWithFormat:@"----- Displaying next word: %@",[wordsArray objectAtIndex:currentWordNum]]];
		
        [wordShown release];
        wordShown = nil;
        wordShown = [[NSDate date] retain];
		//put the word on the display
		thisWordView.text = [wordsArray objectAtIndex:currentWordNum];
		[correctIndicator setHidden:YES];
		
		[inCategoryButton setEnabled:YES];
		[notCategoryButton setEnabled:YES];

		//set up a call to hide the word if user hasnt pressed anything for five seconds
		NSNumber *thisWordNum = [NSNumber numberWithInt:currentWordNum];
		[self performSelector:@selector(hideWordAfterWait:) withObject:thisWordNum afterDelay:([AdminScreenVC getVarForKey:@"k_categoryPresentationTime"] / (float)1000)];
		//now we wait for a user to press one of the buttons
	}
	else { //done with all words this round
		[self logIt:@"----- Done with round"];
		//thisWordView.text = @"DONE";
		//[correctIndicator setHidden:YES];
		NSArray *words = [NSArray arrayWithArray:wordsArray];
		[self pushToRecall:words];
	}
}
		 
- (void)hideWordAfterWait:(NSNumber *)thisWordNum {
	// hides the word view if 5 seconds has passed without the user picking a category
	// -does this by comparing the wordnum when the method was called vs. the current wordnum
	if (currentWordNum == [thisWordNum integerValue]) {
		[thisWordView setHidden:YES];
		[self logIt:@"----- Hiding word after 5s delay"];
	}
}

- (void)pushToRecall:(NSArray *)words {
	revc = [[RecallEntryVC alloc] initWithNibName:@"RecallEntryVC" bundle:nil];
    revc.wordsName = @"word(s)";
    revc.fields = words;
	[revc setDelegate:self];
	
	
	NSLog(@"CategoryVC: pushVC to recall");
	[self.navigationController pushViewController:revc animated:YES];
}

- (void)recallEnded:(int)numCorrect withTotalWords:(int)totalWords {
	
	[revc release];
	
	//initialize a feedback screen
    //check the classifications by adding up all the ones that were correct
    int numCorrectClass = 0; // correctChoiceTrack
    for (int i=0; i < correctChoiceTrack.count; i++) {
        numCorrectClass = numCorrectClass + [[correctChoiceTrack objectAtIndex:i] integerValue];
    }
    int numErrors = totalWords-numCorrectClass;

	fevc = [[[FeedbackScreenVC alloc] initWithNibName:@"FeedbackScreenVC" bundle:nil] autorelease];
    fevc.numCorrect = numCorrect;
    fevc.numTotal = totalWords;
    fevc.type = @"word(s)";
    fevc.typeOfError = @"classification";
    fevc.numErrors = numErrors;
	[fevc setDelegate:self];
	
	//push view controller to feedback screen with results
	[self.navigationController pushViewController:fevc animated:YES];
}

- (void)feedbackEnded:(int)nextWordCount {
	//NSLog(@"feedbackEnded. nextWordCount:%d",nextWordCount);
	[self.navigationController popViewControllerAnimated:NO];
	[fevc release];
	[[self delegate] categoryEnded:nextWordCount];
	
	
}

- (void)quitPressed {
	//NSLog(@"CategoryVC: quitPressed");
	[self logIt:@"----- QUIT pressed in Category game"];
	[self.navigationController popViewControllerAnimated:NO];
	[[self delegate] categoryQuit:wordsThisRound];
}

- (void)logIt:(NSString *)whatToLog {
	
	[[self delegate] logIt:whatToLog];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	NSLog(@"CategoryVC: viewDidLoad");
    [super viewDidLoad];
    wordShown = nil;
    buttonPressed = false;
    [[LoggingSingleton sharedSingleton] setCurrentCategory:@"Category"];
    [[LoggingSingleton sharedSingleton] setTimeAverages:[[[NSMutableArray alloc] init] autorelease]];
	/*self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"QUIT" 
											   style:UIBarButtonItemStylePlain
											   target:self
											   action:@selector(quitPressed)] autorelease];*/
	
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.title = @"Category Game";
	
	[correctIndicator setHidden:YES];
	
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
	NSLog(@"categoryVC: dealloc");
	//[revc release];
	//[fevc release];
	[wordsArray release];
	[inCategoryTrack release];
	[correctChoiceTrack release];
    [wordShown release];
    wordShown = nil;
    [super dealloc];
}



@end
