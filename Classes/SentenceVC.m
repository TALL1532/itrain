    //
//  SentenceVC.m
//  Memory Training
//
//  Created by Andrew Battles on 8/2/12. Modified by Thomas Deegan on 22/01/13
//  Copyright 2012 ADLL All rights reserved.
//

#import "SentenceVC.h"
#import "AdminScreenVC.h"
#import "LoggingSingleton.h"

@implementation SentenceVC

@synthesize delegate;


- (IBAction)truePressed:(id)sender {
    if(!buttonPressed){
        buttonPressed = true;
        [[self delegate] logIt:@"----- TRUE pressed"];
        [self buttonPressed:YES];
    }
}

- (IBAction)falsePressed:(id)sender {
	if(!buttonPressed){
        buttonPressed = true;
        [[self delegate] logIt:@"----- FALSE pressed"];
        [self buttonPressed:NO];
    }
}

- (void)buttonPressed:(BOOL)trueSelected {
	NSNumber* asdf= [NSNumber numberWithDouble:[wordShown timeIntervalSinceNow]];
    [[LoggingSingleton sharedSingleton].timeAverages addObject:asdf];
	//disable the buttons until we're ready for the next word
	[trueButton setEnabled:NO];
	[falseButton setEnabled:NO];
	
	//show the indicator to tell if theyre correct
	UniChar specialChar; //indicates correct or not
	UIColor *textColor;	 //indicates correct or not
	int xPos;			 //puts above button pressed
	
	//initialize location, color, and text of correct-indicator
	if (trueSelected) {
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
	
	//show the indicator, then the next sentence
	[correctIndicator setHidden:NO];
	float delay = 1.0;
	currentWordNum++;
	[self performSelector:@selector(displayNextSentence) withObject:nil afterDelay:delay];
	
}

- (void)setNumOfWords:(int)numWords {
	wordsThisRound = numWords;
}

- (void)startPuzzle:(int)categoryNum withWords:(int)numWords {
	
	NSLog(@"categoryNum: %d, numWords: %d",categoryNum, numWords);
	
	//load the sentences into a true and false array
	NSString *truePath = [[NSBundle mainBundle] pathForResource:@"trueSentences" ofType:@"txt"];
	NSString *falsePath = [[NSBundle mainBundle] pathForResource:@"falseSentences" ofType:@"txt"];

	NSString *trueList = [NSString stringWithContentsOfFile:truePath 
													 encoding:NSUTF8StringEncoding 
														error:nil];
	NSString *falseList = [NSString stringWithContentsOfFile:falsePath 
													  encoding:NSUTF8StringEncoding 
														 error:nil];
	NSArray *trueArray = [trueList componentsSeparatedByCharactersInSet:
							[NSCharacterSet newlineCharacterSet]];
	NSArray *falseArray = [falseList componentsSeparatedByCharactersInSet:
							 [NSCharacterSet newlineCharacterSet]];
	
	NSLog(@"arrays loaded");
	
	//arrays loaded, pick sentences at random
	int numCategories = 2; //true and false
	int randoCat;
	int randoNum;
	int i;
	NSString *thisSentence;
	NSArray *currentSentenceWords;
	NSString *lastWord;
	
	correctChoiceTrack = [[NSMutableArray alloc] init];
	inCategoryTrack = [[NSMutableArray alloc] init];
	wordsArray = [[NSMutableArray alloc] init];
	sentenceArray = [[NSMutableArray alloc] init];
	
	//create another array to track words we've done so far
	NSMutableArray *randoTracker1 = [[NSMutableArray alloc] init];
	NSMutableArray *randoTracker2 = [[NSMutableArray alloc] init];

	for (i = 0; i<numWords; i++) {
        
		randoCat = arc4random()%numCategories;
		
		if (randoCat == 1) { //add a true sentence to the list
			[inCategoryTrack addObject:[NSNumber numberWithInt:1]];
			
			//pick a random word from the starting array and add it to the list for this round
		}
		else { //add a non-word to the list
			[inCategoryTrack addObject:[NSNumber numberWithInt:0]];
			
			//pick a random word from the starting array and add it to the list for this round
		}
		
		//set a repeat flag so we can use this while loop to check for repeated random numbers
		bool isRealRentence = randoCat;
		randoNum = [SentenceVC chooseUnusedSentence:isRealRentence withRealSentenceCap:[trueArray count] andFakeSentenceCap:[falseArray count]];
		
		//add the index to a list of "do not repeat"s
		if (isRealRentence) {
			thisSentence = [trueArray objectAtIndex:randoNum];
		}
		else {
			thisSentence = [falseArray objectAtIndex:randoNum];
		}

		
		//add the sentence for this round to the sentenceArray
		[sentenceArray addObject:thisSentence];
		
		//get the last word of the sentence and add it to the wordsArray
		//--------------------------------------------------------------
		//get whole sentence
		currentSentenceWords = [thisSentence componentsSeparatedByCharactersInSet:
								[NSCharacterSet whitespaceCharacterSet]];
		
		//extract last word
		lastWord = [currentSentenceWords objectAtIndex:currentSentenceWords.count-1]; 
		//NSLog(@"lastWord: %@",lastWord);
		
		//remove period from end
		lastWord = [lastWord stringByTrimmingCharactersInSet:[NSCharacterSet punctuationCharacterSet]];
		NSLog(@"lastWordTrimmed: %@",lastWord);
		
		//add trimmed word to array
		[wordsArray addObject:lastWord];
	}
	
	// log everything (sentences, words, & tracker
	[self logIt:@"----- Starting sentence game"];
	[self logIt:@"----- Sentences this round:"];
	for (i=0; i<numWords; i++) {
		[self logIt:[NSString stringWithFormat:@"----- %d: %@",i+1,[sentenceArray objectAtIndex:i]]];
	}
	[self logIt:@"----- Last words:"];
	for (i=0; i<numWords; i++) {
		[self logIt:[NSString stringWithFormat:@"----- Sentence %d: %@",i+1,[wordsArray objectAtIndex:i]]];
	}
	
	[self logIt:@"----- True/False:"];
	for (i=0; i<numWords; i++) {
		if ([[inCategoryTrack objectAtIndex:i] integerValue]) {
			[self logIt:[NSString stringWithFormat:@"----- Sentence %d: TRUE",i+1]];
		}
		else {
			[self logIt:[NSString stringWithFormat:@"----- Sentence %d: FALSE",i+1]];
		}
	}
	
	//now that we have the sentences, last words, order, and in-category tracker, display the first frame
	currentWordNum = 0;
	[self displayNextSentence];
	
	[randoTracker1 release];
	[randoTracker2 release];
	
}

- (void)displayNextSentence { 
	
	if (currentWordNum < wordsThisRound) {
        buttonPressed = false;
		[self logIt:[NSString stringWithFormat:@"----- Displaying next sentence, ending with: %@",[wordsArray objectAtIndex:currentWordNum]]];
		
        [wordShown release];
        wordShown = nil;
        wordShown = [[NSDate date] retain];
		//put the sentence on the display
		sentenceView.text = [sentenceArray objectAtIndex:currentWordNum];
		[correctIndicator setHidden:YES];
		[sentenceView setHidden:NO];
        
		[trueButton setEnabled:YES];
		[falseButton setEnabled:YES];
		
        [self performSelector:@selector(hideWordAfterWait:) withObject:[NSNumber numberWithInt:currentWordNum] afterDelay:([AdminScreenVC getVarForKey:@"k_sentencePresentationTime"] / (float)1000)];
		//now we wait for a user to press one of the buttons
	}
	else { //done with all words this round
		[self logIt:@"----- Done with round"];
		//thmakesSenseView.text = @"DONE";
		//[correctIndicator setHidden:YES];
		NSArray *words = [NSArray arrayWithArray:wordsArray];
		[self pushToRecall:words];
	}
}



- (void)hideWordAfterWait:(id)sentenceNum{
	// hides the word view if 5 seconds has passed without the user picking a category
	// -does this by comparing the wordnum when the method was called vs. the current wordnum
    if([NSNumber numberWithInt:currentWordNum] == (NSNumber *)sentenceNum) [sentenceView setHidden:YES];
    [self logIt:@"----- Hiding sentence after delay"];
}

///////////////////// Called after done with puzzle /////////////////////////////////////

- (void)pushToRecall:(NSArray *)words {
	revc = [[RecallEntryVC alloc] initWithNibName:@"RecallEntryVC" bundle:nil];
	[revc setDelegate:self];
	
	
	NSLog(@"SentenceVC: pushVC to recall");
	[self.navigationController pushViewController:revc animated:YES];
	[revc createFields:words ofTypes:@"word(s)"];
    [revc release];
    revc = nil;
}

- (void)recallEnded:(int)numCorrect withTotalWords:(int)totalWords {
	//NSLog(@"recallEnded. numCorrect:%d, totalWords:%d",numCorrect,totalWords);
	
	
	//initialize a feedback screen
	fevc = [[FeedbackScreenVC alloc] initWithNibName:@"FeedbackScreenVC" bundle:nil];
	[fevc setDelegate:self];
	
	//push view controller to feedback screen with results
	NSString *typeOfNum = @"word(s)";
	NSString *typeOfError = @"true/false";
	int numCorrectClass = 0; // correctChoiceTrack
	
	//check the classifications by adding up all the ones that were correct
	for (int i=0; i < correctChoiceTrack.count; i++) {
		numCorrectClass = numCorrectClass + [[correctChoiceTrack objectAtIndex:i] integerValue];
	}
	int numErrors = totalWords-numCorrectClass;
	
	
	//NSLog(@"CategoryVC: pushVC to feedback");
	[self.navigationController pushViewController:fevc animated:YES];
	//NSLog(@"about to display results");
	[fevc displayResults:numCorrect withTotal:totalWords withType:typeOfNum withErrors:numErrors andErrorType:typeOfError];
	[fevc release];
    fevc = nil;
}

- (void)feedbackEnded:(int)nextWordCount {
	//NSLog(@"feedbackEnded. nextWordCount:%d",nextWordCount);
	[self.navigationController popViewControllerAnimated:NO];
	[[self delegate] sentenceEnded:nextWordCount];
	
}

- (void)quitPressed {
	//NSLog(@"CategoryVC: quitPressed");
	[self logIt:@"----- QUIT pressed in Sentence game"];
	[self.navigationController popViewControllerAnimated:NO];
	[[self delegate] sentenceQuit:wordsThisRound];
}

- (void)logIt:(NSString *)whatToLog {
	
	[[self delegate] logIt:whatToLog];
}

+ (int)chooseUnusedSentence:(bool)makesSense withRealSentenceCap:(NSInteger)numRealSentence andFakeSentenceCap:(NSInteger)numFakeSentence
{
    //This method returns a category number between 0-49 that is an unused category which is persistent between applications cycles.
    NSMutableArray *usedSentences = [(NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:(makesSense ? @"__usedRealSentenceArray" : @"__usedFakeSentenceArray" ) ] mutableCopy];
    NSInteger numWords = (makesSense ? numRealSentence : numFakeSentence);
	NSInteger randomSentence = arc4random()%numWords;
    if([usedSentences count] == 0){
        //no array was initialized so make one
        [usedSentences release];//just to be safe
        usedSentences = nil;
        usedSentences = [[NSMutableArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:(makesSense ? @"__usedRealSentenceNum" : @"__usedFakeSentenceNum" )];
        for ( int i = 1 ; i <= numWords ; i ++ )
            [usedSentences addObject:[NSNumber numberWithBool:false]];
    }
    else{
        NSInteger usedNum = [[NSUserDefaults standardUserDefaults] integerForKey:(makesSense ? @"__usedRealSentenceNum" : @"__usedFakeSentenceNum" )];
        bool isFull = (usedNum == numWords);
        if(isFull){
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:(makesSense ? @"__usedRealSentenceNum" : @"__usedFakeSentenceNum" )];
            for ( int i = 1 ; i < numWords ; i ++ ) //reset the array to all false
                [usedSentences replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:false]];
        }else {
            [[NSUserDefaults standardUserDefaults] setInteger:(usedNum +1) forKey:(makesSense ? @"__usedRealSentenceNum" : @"__usedFakeSentenceNum" )];
        }
        
        //we will try 5 times to find a unused sentence, otherwise just use the first available one
        NSInteger tries = 5;
        NSInteger i =0;
        randomSentence = arc4random()%numWords;
        while(i < tries && [(NSNumber*)[usedSentences objectAtIndex:randomSentence] boolValue]){
            randomSentence = arc4random()%numWords;
        }
        if(i == tries){
            for(int j = 0; j < numWords; j++){
                if(![(NSNumber*)[usedSentences objectAtIndex:j] boolValue]){
                    randomSentence = j;
                    break;
                }
            }
        }
        
    }
    [usedSentences replaceObjectAtIndex:randomSentence withObject:[NSNumber numberWithBool:true]];
    
    [[NSUserDefaults standardUserDefaults] setObject:usedSentences forKey:(makesSense ? @"__usedRealSentenceArray" : @"__usedFakeSentenceArray" )];
    [usedSentences release];
    return randomSentence;
}



////////////////////// Load View (initialization) /////////////////////////////////////
- (void)viewDidLoad {
    [super viewDidLoad];
	buttonPressed = false;
    wordShown = nil;
	NSLog(@"SentenceVC: viewDidLoad");
	
	/*self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"QUIT" 
											   style:UIBarButtonItemStylePlain
											   target:self
											   action:@selector(quitPressed)] autorelease];
	*/
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.title = @"Sentence Game";
	
	[correctIndicator setHidden:YES];
	
    [[LoggingSingleton sharedSingleton] setCurrentCategory:@"Category"];
    [[LoggingSingleton sharedSingleton] setCurrentCategory:@"Sentence"];
    [[LoggingSingleton sharedSingleton] setTimeAverages:[[[NSMutableArray alloc] init] autorelease]];
	
}


//////////////////////////////////// SYSTEM ////////////////////////////////////////////////

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
	
	[sentenceArray release];
	[wordsArray release];
	[inCategoryTrack release];
	[correctChoiceTrack release];
	[wordShown release];
    [super dealloc];
}


@end
