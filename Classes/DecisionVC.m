    //
//  DecisionVC.m
//  Memory Training
//
//  Created by Andrew Battles on 7/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "DecisionVC.h"
#import "AdminScreenVC.h"
#import "LoggingSingleton.h"


@implementation DecisionVC

@synthesize delegate;


- (IBAction)wordPressed:(id)sender {
    if(!buttonPressed){
        buttonPressed = true;
        [[self delegate] logIt:@"----- WORD pressed"];
        [self buttonPressed:YES];
    }
}
- (IBAction)notWordPressed:(id)sender {
    if(!buttonPressed){
        buttonPressed = true;
        [[self delegate] logIt:@"----- NON-WORD pressed"];
        [self buttonPressed:NO];
    }
}

- (void)buttonPressed:(BOOL)inCategory {
	
	
	//disable the buttons until we're ready for the next word
	[wordButton setEnabled:NO];
	[notWordButton setEnabled:NO];
	
    [[LoggingSingleton sharedSingleton].timeAverages addObject:[NSNumber numberWithDouble:[wordShown timeIntervalSinceNow]]];

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
	
	//set the variables above and show indicator for [delay] seconds
	NSString *specialString = [NSString stringWithCharacters:&specialChar length:1];
	correctIndicator.text = specialString;
	correctIndicator.textColor = textColor;
	correctIndicator.frame = CGRectMake(xPos, correctIndicator.frame.origin.y, 
										correctIndicator.frame.size.width, correctIndicator.frame.size.height);
	
	[correctIndicator setHidden:NO];
	float delay = 1.0;
	
	[self performSelector:@selector(showNextLetter) withObject:nil afterDelay:delay];
	
}

- (void)startPuzzle:(int)categoryNum withWords:(int)numWords {
	
	//NSLog(@"categoryNum: not used, numWords: %d",categoryNum,numWords);
	
	self.navigationItem.title = [NSString stringWithFormat:@"%d Letters",numWords];
	
	NSString *titleString = @"Word";
	
	[wordButton setTitle:[NSString stringWithFormat:@"%@",titleString] forState:UIControlStateNormal];
	[notWordButton setTitle:[NSString stringWithFormat:@"Not a %@",titleString] forState:UIControlStateNormal];
	
	//load the real words into an array
	
	NSString *realWordsPath = [[NSBundle mainBundle] pathForResource:@"decisionWords" ofType:@"txt"];
	NSString *realWordsList = [NSString stringWithContentsOfFile:realWordsPath 
													  encoding:NSUTF8StringEncoding 
														 error:nil];
	
	//NSString *realWordsTrimmed = [realWordsList stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSArray *realWordsArray = [realWordsList componentsSeparatedByCharactersInSet:
							 [NSCharacterSet newlineCharacterSet]];

	NSString *nonWordsPath = [[NSBundle mainBundle] pathForResource:@"non-words" ofType:@"txt"];
	NSString *nonWordsList = [NSString stringWithContentsOfFile:nonWordsPath 
														encoding:NSUTF8StringEncoding 
														   error:nil];
	
	//NSString *nonWordsTrimmed = [nonWordsList stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSArray *nonWordsArray = [nonWordsList componentsSeparatedByCharactersInSet:
							   [NSCharacterSet newlineCharacterSet]];
	
    
	
	//array loaded, pick numbers at random
	correctChoiceTrack = [[NSMutableArray alloc] init];
	inCategoryTrack = [[NSMutableArray alloc] init];
	wordsArray = [[NSMutableArray alloc] init];
	
	int numCategories = 2; //real word and non-word
	int randoCat;
	int randoNum;
	int randoLetter;
	int i;
	//create another array to track words we've done so far
	NSMutableArray *randoTracker1 = [[NSMutableArray alloc] init];	//in-category words
	NSMutableArray *randoTracker2 = [[NSMutableArray alloc] init];	//not-in-category words
	NSMutableArray *randoTracker3 = [[NSMutableArray alloc] init];	//letters
	NSUInteger indexCheck = 10001;
	NSNumber *randoNSNum;
	BOOL repeat;
	
	NSArray *lettersArray = [[NSArray alloc] initWithObjects:@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",
							 @"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z",nil];
	
	for (i=0; i<numWords; i++) {
		randoCat = arc4random()%numCategories;
		
		if (randoCat == 1) { //for a real word from the array to the list
			[inCategoryTrack addObject:[NSNumber numberWithInt:1]];
			
            randoNum = [DecisionVC chooseUnusedWord:YES withWordCap:[realWordsArray count] andNotWordCap:[nonWordsArray count]];
			[wordsArray addObject:[realWordsArray objectAtIndex:randoNum]];
			
		}
		else { //add a non-word to the list
			[inCategoryTrack addObject:[NSNumber numberWithInt:0]];
			
            randoNum = [DecisionVC chooseUnusedWord:NO withWordCap:[realWordsArray count] andNotWordCap:[nonWordsArray count]];

			[wordsArray addObject:[nonWordsArray objectAtIndex:randoNum]];
		}
	}
	
	//build an array of random letters for subject to remember
	randomLettersArray = [[NSMutableArray alloc] init];
	for (int k = 0; k<numWords; k++) {
		//set a repeat flag so we can use this while loop to check for repeated random numbers
		repeat = YES;
		
		while (repeat) {
			//get a random letter
			randoLetter = arc4random()%26;
			
			//now perform some NSNumber gymnastics so we dont get any repeats
			randoNSNum = [NSNumber numberWithInt:randoLetter];
			
			indexCheck = [randoTracker3 indexOfObject:randoNSNum];
			NSLog(@"indexCheck: %u",indexCheck);
			if (indexCheck < 10000) { //if its not in the repeat tracker, the index will be the NSUInteger upper limit
				NSLog(@"repeated letter");
			}
			else {
				repeat = NO;
				NSLog(@"not-repeat: %d",randoNum);
			}
			
		}
		NSString *letter = [lettersArray objectAtIndex:randoLetter];
		NSLog(@"letter to add: %@",letter);
		[randomLettersArray addObject:letter];
		[randoTracker3 addObject:randoNSNum];
	}
	
	// log everything (words, letters, and tracker)
	[self logIt:@"----- Starting decision game"];
	[self logIt:@"----- Words this round:"];
	for (i=0; i<numWords; i++) {
		if ([[inCategoryTrack objectAtIndex:i] integerValue]) {
			[self logIt:[NSString stringWithFormat:@"----- Word %d: %@ -- REAL",i+1,[wordsArray objectAtIndex:i]]];
		}
		else {
			[self logIt:[NSString stringWithFormat:@"----- Word %d: %@ -- NON-WORD",i+1,[wordsArray objectAtIndex:i]]];
		}
	}
	[self logIt:@"----- Letters this round:"];
	for (i=0; i<numWords; i++) {
		[self logIt:[NSString stringWithFormat:@"----- Letter %d: %@",i+1,[randomLettersArray objectAtIndex:i]]];
	}
	
	
	//now that we have the words, order, array of random letters to show, and in-category tracker, display the first frame
	currentWordNum = 0;
	[self displayNextWord];
	
	[lettersArray release];
	[randoTracker1 release];
	[randoTracker2 release];
	[randoTracker3 release];
}

- (void)showNextLetter {
	
	//hide everything other than the letter to display
	[thisWordView setHidden:YES];
	[wordButton setHidden:YES];
	[notWordButton setHidden:YES];
	[correctIndicator setHidden:YES];
	
	[letterDisplay setHidden:NO];
	
	//show letter for 800ms
	NSString *letter = [randomLettersArray objectAtIndex:currentWordNum];
	[self logIt:[NSString stringWithFormat:@"----- Displaying next letter: %@",letter]];
	
	letterDisplay.text = letter;
	currentWordNum++;
	[self performSelector:@selector(displayNextWord) withObject:nil afterDelay:([AdminScreenVC getVarForKey:@"k_decisionLetterTime"] / (float)1000)];
}
- (void)hideWord:(NSNumber*)word{
    if(word == [NSNumber numberWithInt:currentWordNum])
        thisWordView.hidden = YES;
}
- (void)showWord {
    thisWordView.hidden = NO;
}
- (void)displayNextWord { 
	
	if (currentWordNum < wordsThisRound) {
        
            buttonPressed = false;
        //[self showWord];
		[self logIt:[NSString stringWithFormat:@"----- Displaying next word: %@",[wordsArray objectAtIndex:currentWordNum]]];
		[wordShown release];
        wordShown = nil;
        wordShown = [[NSDate date] retain];
		//put the word on the display
		thisWordView.text = [wordsArray objectAtIndex:currentWordNum];
		
		
		[wordButton setEnabled:YES];
		[notWordButton setEnabled:YES];
		
		[wordButton setHidden:NO];
		[notWordButton setHidden:NO];
		[thisWordView setHidden:NO];
		[letterDisplay setHidden:YES];
        
        //NSString* currWord = [[wordsArray objectAtIndex:currentWordNum] retain];
        [self performSelector:@selector(hideWord:) withObject:[NSNumber numberWithInt:currentWordNum] afterDelay:([AdminScreenVC getVarForKey:@"k_decisionWordTime"] / (float)1000)];
		//now we wait for a user to press one of the buttons
	}
	else { //done with all words this round
		[self logIt:@"----- Done with round"];
		//thisWordView.text = @"DONE";
		//[correctIndicator setHidden:YES];
		NSArray *words = [NSArray arrayWithArray:randomLettersArray];
		[self pushToRecall:words];
	}
}

- (void)pushToRecall:(NSArray *)words {
	revc = [[RecallEntryVC alloc] initWithNibName:@"RecallEntryVC" bundle:nil];
	[revc setDelegate:self];
	
	
	NSLog(@"CategoryVC: pushVC to recall");
	[self.navigationController pushViewController:revc animated:YES];
    
    
	[revc createFields:words ofTypes:@"letter(s)"];
    [revc release];
}

- (void)recallEnded:(int)numCorrect withTotalWords:(int)totalWords {
	//NSLog(@"recallEnded. numCorrect:%d, totalWords:%d",numCorrect,totalWords);
	
	//initialize a feedback screen
	fevc = [[FeedbackScreenVC alloc] initWithNibName:@"FeedbackScreenVC" bundle:nil];
	[fevc setDelegate:self];
	
	//push view controller to feedback screen with results
	NSString *typeOfNum = @"letter(s)";
	NSString *typeOfError = @"word choice";
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
	
}

- (void)feedbackEnded:(int)nextWordCount {
	//NSLog(@"feedbackEnded. nextWordCount:%d",nextWordCount);
	[self.navigationController popViewControllerAnimated:NO];
	[[self delegate] decisionEnded:nextWordCount];
}


- (void)quitPressed {
	//NSLog(@"CategoryVC: quitPressed");
	[self logIt:@"----- QUIT pressed in Decision game"];
	[self.navigationController popViewControllerAnimated:NO];
	[[self delegate] decisionQuit:wordsThisRound];
}

- (void)logIt:(NSString *)whatToLog {
	
	[[self delegate] logIt:whatToLog];
}

////////////////////////// Loading View /////////////////////////////////

- (void)setNumOfWords:(int)numWords {
	wordsThisRound = numWords;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    wordShown = nil;
    buttonPressed = false;
	NSLog(@"DecisionVC: viewDidLoad");
	
	/*self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"QUIT" 
											   style:UIBarButtonItemStylePlain
											   target:self
											   action:@selector(quitPressed)] autorelease];
	*/
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.title = @"Decision Game";
	[correctIndicator setHidden:YES];
    [[LoggingSingleton sharedSingleton] setCurrentCategory:@"Decision"];
    [[LoggingSingleton sharedSingleton] setTimeAverages:[[[NSMutableArray alloc] init] autorelease]];
    
	
}

///////////////////////////// SYSTEM ///////////////////////////////////////

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
	[randomLettersArray release];
	[wordsArray release];
	[inCategoryTrack release];
	[correctChoiceTrack release];
    [wordShown release];
    [super dealloc];
}
+ (int)chooseUnusedWord:(bool)isWord withWordCap:(NSInteger)wordCap andNotWordCap:(NSInteger)notWordCap
{
    //This method returns a category number between 0-49 that is an unused category which is persistent between applications cycles.
    NSMutableArray *usedWords = [(NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:(isWord ? @"__usedWordsArray" : @"__usedNotWordsArray" ) ] mutableCopy];
    NSInteger numWords = (isWord ? wordCap : notWordCap);
	NSInteger randomWord = arc4random()%numWords;
    if([usedWords count] == 0){
        //no array was initialized so make one
        [usedWords release];
        usedWords = nil;
        usedWords = [[NSMutableArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:(isWord ? @"__usedWordsNum" : @"__usedNotWordsNum" )];
        for ( int i = 1 ; i <= numWords ; i ++ )
            [usedWords addObject:[NSNumber numberWithBool:false]];
    }
    else{
        NSInteger usedNum = [[NSUserDefaults standardUserDefaults] integerForKey:(isWord ? @"__usedWordsNum" : @"__usedNotWordsNum" )];
        BOOL isFull = (usedNum == numWords);
        if(isFull){
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:(isWord ? @"__usedWordsNum" : @"__usedNotWordsNum" )];
            for ( int i = 1 ; i < numWords ; i ++ ) //reset the array to all false
                [usedWords replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:false]];
        }else {[[NSUserDefaults standardUserDefaults] setInteger:(usedNum +1) forKey:(isWord ? @"__usedWordsNum" : @"__usedNotWordsNum" )];}
        
        //we will try 5 times to find a unused word, otherwise just use the next available one
        NSInteger tries = 5;
        NSInteger i =0;
        randomWord = arc4random()%numWords;
        while(i < tries && [(NSNumber*)[usedWords objectAtIndex:randomWord] boolValue]){
            randomWord = arc4random()%numWords;
            i++;
        }
        if(i == tries){
            for(int j = 0; j < numWords; j++){
                if(![(NSNumber*)[usedWords objectAtIndex:j] boolValue]){
                    randomWord = j;
                    break;
                }
            }
        }
        
    }
    [usedWords replaceObjectAtIndex:randomWord withObject:[NSNumber numberWithBool:true]];
    
    [[NSUserDefaults standardUserDefaults] setObject:usedWords forKey:(isWord ? @"__usedWordsArray" : @"__usedNotWordsArray" )];
    [usedWords release];
    return randomWord;
}



@end
