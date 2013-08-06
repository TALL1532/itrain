    //
//  AdminScreenVC.m
//  Memory Training
//
//  Created by Andrew Battles on 8/22/12 modified by Thomas Deegan 2013
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "AdminScreenVC.h"
#import "LoggingSingleton.h"

@implementation AdminScreenVC

@synthesize delegate;										//---comm

- (IBAction)savePressed:(id)sender {
    [self saveSettings];
	
	UIAlertView *saveAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Settings Saved"
													   delegate:self 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil]; 
	
	[saveAlert show];
	[saveAlert release];
}

- (IBAction)clearStatePressed:(id)sender {
	UIAlertView *checkAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to clear the state for a new subject?" 
														delegate:self 
											   cancelButtonTitle:@"Cancel" 
											   otherButtonTitles:@"Clear State",nil]; 
		
	[checkAlert show];
	[checkAlert release];
}

- (IBAction)emailRecordsPressed:(id)sender{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	// Set subject line
	[picker setSubject:@"Adult Learning Lab iPad Log File"];
	
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"AdultLearningLab.ipad@gmail.com"];
	[picker setToRecipients:toRecipients];
	
	// Attach log to the email
    
    NSString* path = [NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],@"record.csv"];

	NSData *myData = [NSData dataWithContentsOfFile:path];
	[picker addAttachmentData:myData mimeType:@"text/plain" fileName:[NSString stringWithFormat:@"records-%@.csv",[LoggingSingleton getSubjectName]]];
	
	// Fill out the email body text
	NSString *emailBody = @"Log file attached.";
	[picker setMessageBody:emailBody isHTML:NO];
	if (picker != nil) {
		[self presentViewController:picker animated:YES completion:nil];
		[picker release];
	}
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
// Saving/loading state from GameSettings.txt

- (void)saveSettings {
	NSLog(@"saveSettings");
	NSString *directory = [self getDocumentsDirectory];
	NSString *settingsFileName = [NSString stringWithFormat:@"/GameSettings.txt"];
	NSString *filePath = [directory stringByAppendingString:settingsFileName];
	//NSLog(@"filePath is: %@",filePath);
	
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	[fileManager createFileAtPath:filePath contents:nil attributes:nil];
	
	NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];  //telling fileHandle what file write to
	[fileHandle truncateFileAtOffset:[fileHandle seekToEndOfFile]]; //setting aFileHandle to write at the end of the file
	
    // category: k_categoryPresentationTime, decision word: k_decisionWordTime, decision letter: k_decisionLetterTime, sentence: k_sentencePresentationTimes    
    [[NSUserDefaults standardUserDefaults] setObject:tagField.text forKey:SUBJECT_NAME];
    [[NSUserDefaults standardUserDefaults] setInteger:[categoryTime.text integerValue] forKey:CATEGORY_PRESENTATION_TIME];
    [[NSUserDefaults standardUserDefaults] setInteger:[decisionWordTime.text integerValue] forKey:DECISION_PRESENTATION_TIME];
    [[NSUserDefaults standardUserDefaults] setInteger:[decisionLetterTime.text integerValue] forKey:DECISION_PRESENTATION_LETTER_TIME];
    [[NSUserDefaults standardUserDefaults] setInteger:[sentenceTime.text integerValue] forKey:SENTENCE_PRESENTATION_TIME];
    [[NSUserDefaults standardUserDefaults] setInteger:[timeField.text floatValue] forKey:TASK_TIME];
    
    [[NSUserDefaults standardUserDefaults] setBool:controlGroupSwitch.on forKey:CONTROL_GROUP_ON_BOOL];

    [[NSUserDefaults standardUserDefaults] setFloat:[controlGroupReductionField.text floatValue] forKey:CONTROL_GROUP_REDUCTION_TIME_FLOAT];
    
    [[NSUserDefaults standardUserDefaults] setInteger:[controlGroupWordsPerRoundField.text integerValue] forKey:CONTROL_GROUP_NUM_WORDS_INT];
    
    [[NSUserDefaults standardUserDefaults] setInteger:[controlGroupTotalNeededField.text integerValue] forKey:CONTROL_GROUP_NUM_NEEDED_TO_ADVANCE_INT];

	//WHY... WHY!!!?!?!? note to self: try not to think about how the rest of the code is written
	//write each variable to the text file "ExpSettings.txt" so we can load them later
	int i; NSString *stringToWrite;
	for (i = 0; i <= 10; i++) {
		switch (i) {
			case 0:								//validity check
				stringToWrite = @"SETTINGS: tag,time,LL,HL,days,categoryWords,decisionWords,sentenceWords,dateLastPlayed,daysPlayedSoFar";
				NSLog(@"%@",stringToWrite);
				break;
			case 1:								//experiment tag
				stringToWrite = tagField.text;	//NSLog(@"%@",stringToWrite);	
				break;
			case 2:								//time
				stringToWrite = timeField.text;	//NSLog(@"%@",stringToWrite);
				break;
			case 3:								//min words per round
				stringToWrite = minWordsField.text; //NSLog(@"%@",stringToWrite);
				break;
			case 4:								//max words per round
				stringToWrite = maxWordsField.text; //NSLog(@"%@",stringToWrite);
				break;
			case 5:						 		//days to completion
				stringToWrite = daysField.text; //NSLog(@"%@",stringToWrite);
				break;
			case 6:								//category words
				stringToWrite = categoryWordsField.text; //NSLog(@"%@",stringToWrite);
				break;
			case 7:								//decision words
				stringToWrite = decisionWordsField.text; //NSLog(@"%@",stringToWrite);
				break;
			case 8:								//sentence words
				stringToWrite = sentenceWordsField.text; //NSLog(@"%@",stringToWrite);
				break;
			case 9:								//date last played
				stringToWrite = dateField.text; //NSLog(@"%@",stringToWrite);
				break;
			case 10:							//days played so far
				stringToWrite = daysPlayedField.text; //NSLog(@"%@",stringToWrite);
			default:
				NSLog(@"default case called in save settings iteration: %d",i);
				break;
		}
		//stringToWrite = whatToLog;
		[fileHandle writeData:[stringToWrite dataUsingEncoding:NSUTF8StringEncoding]]; //actually write the data
		
		[fileHandle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]]; //add carriage return
		
	}
	
	[fileHandle synchronizeFile]; //adding this makes sure the file is stored!
	
	[fileManager release];
	//NSLog(@"settings saved");
	
}

- (void)loadSettings {
	NSLog(@"loadSettings");
	NSString *directory = [self getDocumentsDirectory];
	NSString *settingsFileName = [NSString stringWithFormat:@"/GameSettings.txt"];
	NSString *filePath = [directory stringByAppendingString:settingsFileName];
	
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	
    [mainMenuButtonsVisibleSwitch setOn:[AdminScreenVC shouldShowMainMenuItems]];
    
    tagField.text = [NSString stringWithFormat:@"%@", [LoggingSingleton getSubjectName]];
    
    categoryTime.text =[NSString stringWithFormat:@"%d",[AdminScreenVC getVarForKey:CATEGORY_PRESENTATION_TIME]];
    decisionWordTime.text = [NSString stringWithFormat:@"%d",[AdminScreenVC getVarForKey:DECISION_PRESENTATION_TIME]];
    decisionLetterTime.text = [NSString stringWithFormat:@"%d",[AdminScreenVC getVarForKey:DECISION_PRESENTATION_LETTER_TIME]];
    sentenceTime.text = [NSString stringWithFormat:@"%d",[AdminScreenVC getVarForKey:SENTENCE_PRESENTATION_TIME]];
    timeField.text = [NSString stringWithFormat:@"%d",[AdminScreenVC getVarForKey:TASK_TIME]];
    
    controlGroupSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:CONTROL_GROUP_ON_BOOL];
    controlGroupReductionField.text = [NSString stringWithFormat:@"%f",[SettingsManager getFloatWithKey:CONTROL_GROUP_REDUCTION_TIME_FLOAT orWriteAndReturn:0.95]];
                                     
    
    controlGroupTotalNeededField.text = [NSString stringWithFormat:@"%d", [SettingsManager getIntegerWithKey:CONTROL_GROUP_NUM_NEEDED_TO_ADVANCE_INT orWriteAndReturn:15]];
    controlGroupWordsPerRoundField.text = [NSString stringWithFormat:@"%d", [SettingsManager getIntegerWithKey:CONTROL_GROUP_NUM_WORDS_INT orWriteAndReturn:20]];
    
	if(![fileManager fileExistsAtPath:filePath]) {
		//file isnt there, do nothing
		NSLog(@"no settings file detected");
	}
	
	else {
		//load the variables from ExpSettings into a string array
		NSLog(@"loading settings");
		NSString *textFromFile = [NSString stringWithContentsOfFile:filePath
														   encoding:NSUTF8StringEncoding 
															  error:nil];
		
		//NSLog(@"%@",textFromFile);
		NSArray *variableArray = [textFromFile componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
		
		//load the variables into their respective fields
		//updated to use NSUSerDefaults. see above    tagField.text = [variableArray objectAtIndex:1];
        //timeField.text = [variableArray objectAtIndex:2];			//NSLog(@"time: %@",timeField.text);
		minWordsField.text = [variableArray objectAtIndex:3];		//NSLog(@"minWords: %@",minWordsField.text);
		maxWordsField.text = [variableArray objectAtIndex:4];		//NSLog(@"maxWords: %@",maxWordsField.text);
		daysField.text = [variableArray objectAtIndex:5];			//NSLog(@"days: %@",daysField.text);
		categoryWordsField.text = [variableArray objectAtIndex:6];	//NSLog(@"categoryWords: %@",categoryWordsField.text);
		decisionWordsField.text = [variableArray objectAtIndex:7];	//NSLog(@"decisionWords: %@",decisionWordsField.text);
		sentenceWordsField.text = [variableArray objectAtIndex:8];	//NSLog(@"sentenceWords: %@",sentenceWordsField.text);
		dateField.text = [variableArray objectAtIndex:9];			//NSLog(@"date: %@",dateField.text);
		daysPlayedField.text = [variableArray objectAtIndex:10];	//NSLog(@"daysSoFar: %@",daysPlayedField.text);
	}
	[fileManager release];
}

// Showing log
- (void)showLogPressed {
	
	//initialize ViewLog
	viewLog = [[ViewLog alloc] initWithNibName:@"ViewLog" bundle:nil];
	[viewLog setDelegate:self];									//---comm
	
	[self.navigationController pushViewController:viewLog animated:NO];
	[viewLog displayLogContents];
}

- (void)endLog {
	[viewLog release];
}


- (NSString *)getDocumentsDirectory {  
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
	return [paths objectAtIndex:0];  
}

// Returning state

- (NSString *)getTag {		// *** used by ViewLog too***
	return tagField.text;
}

- (float)getTimePerRound {
	NSString *timeString = timeField.text;
	return [timeString floatValue];
}

- (int)getMinWords {
	NSString *minString = minWordsField.text;
	return [minString integerValue];
}

- (int)getMaxWords {
	NSString *maxString = maxWordsField.text;
	return [maxString integerValue];
}

- (int)getDaysToPlay {
	NSString *daysString = daysField.text;
	return [daysString integerValue];
}

- (int)getDaysPlayedSoFar {
	NSString *daysPlayedString = daysPlayedField.text;
	return [daysPlayedString integerValue];
}

- (int)getCategoryWords {
	NSString *wordString = categoryWordsField.text;
	return [wordString integerValue];
}

- (int)getDecisionWords {
	NSString *wordString = decisionWordsField.text;
	return [wordString integerValue];
}

- (int)getSentenceWords {
	NSString *wordString = sentenceWordsField.text;
	return [wordString integerValue];
}

- (NSString *)getDateLastPlayed {
	return [NSString stringWithFormat:@"%@",dateField.text];
}

// These cases are so the main screen can change the number of words and call "save" without having to load this screen
- (void)changeCategoryWords:(int)numWords {
	categoryWordsField.text = [NSString stringWithFormat:@"%d",numWords];
	[self saveSettings];
}
- (void)changeDecisionWords:(int)numWords {
	decisionWordsField.text = [NSString stringWithFormat:@"%d",numWords];
	[self saveSettings];
}
- (void)changeSentenceWords:(int)numWords {
	sentenceWordsField.text = [NSString stringWithFormat:@"%d",numWords];
	[self saveSettings];
}

- (void)changeDatePlayedLast:(NSString *)date {
	dateField.text = date;
	[self saveSettings];
}

- (void)incrementDaysPlayedSoFar {
	int daysSoFar = [daysPlayedField.text integerValue];
	daysSoFar++;
	daysPlayedField.text = [NSString stringWithFormat:@"%d",daysSoFar];
	[self saveSettings];
}

- (void)clearStateForNewSubject {
	categoryWordsField.text = @"3";
	decisionWordsField.text = @"3";
	sentenceWordsField.text = @"3";
	dateField.text = @"UNPLAYED";
	daysPlayedField.text = @"0";
	[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"k_sessionNumber"];
    NSFileManager *fileMgr = [[NSFileManager defaultManager] retain];
    NSError * error;
    if ([fileMgr removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],@"record.csv"] error:&error] != YES)
        NSLog(@"Unable to delete file: %@", [error localizedDescription]);
    [fileMgr release];
    fileMgr = nil;
    
	[self saveSettings];
	
	[[self delegate] logIt:@"State cleared. Ready for new subject"];
	
	UIAlertView *wrongAlert = [[UIAlertView alloc] initWithTitle:nil message:@"State cleared. MAKE SURE TO email and clear the log"
														delegate:self 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil]; 
	
	[wrongAlert show];
	[wrongAlert release];
}

// detect if user has changed subject name and should therefore clear the state

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	if (textField.tag == 1) { //if finished editing the subject tag (means new subject)
		UIAlertView *checkAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want to clear the state for the new subject?" 
															delegate:self 
												   cancelButtonTitle:@"Cancel" 
												   otherButtonTitles:@"Clear State",nil]; 
		
		[checkAlert show];
		[checkAlert release];
	}
}

//by Thomas Deegan      
// category: k_categoryPresentationTime, decision word: k_decisionWordTime, decision letter: k_decisionLetterTime, sentence: k_sentencePresentationTime
+ (NSInteger)getVarForKey:(NSString*)key{
    NSInteger toReturn = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    if(toReturn == 0){
        [[NSUserDefaults standardUserDefaults] setInteger:2000 forKey:key];
        toReturn = 2000;
    }
    return toReturn;
}

+ (BOOL)shouldShowMainMenuItems{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"k_showMainMenuItems"];
}

- (IBAction)switchToggled:(id)sender{
    [[NSUserDefaults standardUserDefaults] setBool:((UISwitch*)sender).on forKey:@"k_showMainMenuItems"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        //NSLog(@"cancel");
    }
    else if (buttonIndex == 1)
    {
		[self clearStateForNewSubject];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self loadSettings];
	
	//self.navigationItem.hidesBackButton = YES;
	self.navigationItem.title = @"Administrator Interface";
	
	//put "Show Log" button in top right corner
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"Show Log" 
											   style:UIBarButtonItemStylePlain
											   target:self
											   action:@selector(showLogPressed)] autorelease];
	
	[self.navigationController popViewControllerAnimated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
	[self loadSettings];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
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

- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
@end
