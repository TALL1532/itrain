    //
//  MainScreenVC.m
//  Memory Training
//
//  Created by Andrew Battles on 7/22/12 modified my Thomas Deegan 2013
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "MainScreenVC.h"
#import "LoggingSingleton.h"

@implementation MainScreenVC
- (IBAction)categoryPressed:(id)sender {
    [self launchCategoryGame];
}
- (IBAction)realFakePressed:(id)sender {
    [self launchDecisionGame];
}
- (IBAction)sentencesPressed:(id)sender {
    [self launchSentencesGame];
}


- (IBAction)playNextPressed:(id)sender {

	if (countForToday < 1) { //if this is the first for the day, set up the puzzles
		[self setupDay];
		[self updateDateLastPlayed];
	}
	
	if (countForToday < 3) { //if we havent played all three, play next
		[playNextButton setTitle:@"Play Next Game" forState:UIControlStateNormal];
		switch ([[todaysOrder objectAtIndex:countForToday] integerValue]) {
			case 0:
				[self launchCategoryGame];
				break;
			case 1:
				[self launchDecisionGame];
				break;
			case 2:
				[self launchSentencesGame];
				break;
			default:
				break;
		}
        [LoggingSingleton setRecoverySection:[NSNumber numberWithInt:countForToday]];
		countForToday++;
        
	}
	else {
		[self logIt:@"User attempted to play again in same day"];
		
		UIAlertView *wrongAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Wait until tomorrow to play again"
															delegate:self 
												   cancelButtonTitle:@"See you then!" 
												   otherButtonTitles:nil]; 
		
		[wrongAlert show];
		[wrongAlert release];
		
	}

}

- (void)mainScreenShown {
	
	[self logIt:@"----- Main screen shown"];
	BOOL readyToPlay = [self checkDate];
	
	if (readyToPlay) {
		[self resetSubjectDays];
		//NOTE: this is okay, will not reset count mid-round because the date will be the same
	}
}

- (void)setupDay {
	
	countForToday = 0;
	
	//create the array of numbers 
	int numArray[3] = {0,1,2};

	//shuffle the order to play
	int rando;
	int i;
	int a;
	int b;
	for (i = 0; i<3; i++) {
		rando = arc4random()%3;
		a = numArray[i];
		b = numArray[rando];
		
		numArray[i] = b;
		numArray[rando] = a;
	}
	
	//build the number array to keep order of puzzles
	todaysOrder = [[NSMutableArray alloc] init];
	[self logIt:@"----- Day's games reset. Order for today:"];
	for (i = 0; i<3; i++) {
		[todaysOrder addObject:[NSNumber numberWithInt:numArray[i]]];
		switch (numArray[i]) {
			case 0:
				[self logIt:[NSString stringWithFormat:@"----- Game %d: %@",i+1,@"Category"]];
				break;
			case 1:
				[self logIt:[NSString stringWithFormat:@"----- Game %d: %@",i+1,@"Decision"]];
				break;
			case 2:
				[self logIt:[NSString stringWithFormat:@"----- Game %d: %@",i+1,@"Sentence"]];
			break;
			default:
				break;
		}
	}
    
    //recovery stuff
    [LoggingSingleton setRecoverySections:todaysOrder];
}

- (void)resetSubjectDays {
	countForToday = 0;
	[todaysOrder release];
	instructionsView.text = @"Ready to start first game!";
	[playNextButton setTitle:@"Start!" forState:UIControlStateNormal];
}
		 
- (bool)checkDoneForToday {
	NSLog(@"checking count: %d",countForToday);
    switch (countForToday) {
		case 1:
			instructionsView.text = @"Ready for second round";
			break;
		case 2:
			instructionsView.text = @"Ready for third round";
			break;
		case 3:
			instructionsView.text = @"Done for Today!";
		default:
			break;
	}
    
	if (countForToday >= 3) {
		UIAlertView *doneAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Done For Today!" 
														   delegate:self 
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil]; 
		[doneAlert show]; 
		[doneAlert release]; 
		[playNextButton setTitle:@"Done For Today" forState:UIControlStateNormal];
        return true;
	}
	else {
		UIAlertView *doneAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Round Complete!" 
														   delegate:self 
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil]; 
		[doneAlert show]; 
		[doneAlert release];
        return false;
	}

	
}

- (void)launchCategoryGame {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:CONTROL_GROUP_ON_BOOL]){
        ControlGroupViewController* vc = [[ControlGroupViewController alloc] initWithNibName:@"ControlGroupViewController" bundle:nil];
        
        [self presentViewController:vc animated:YES completion:^{
            [vc startTask:category];
        }];
    }
    else{
        [self logIt:@"----- CATEGORY game launched"];
        
        
        
        ccvc = [[CategoryControllerVC alloc] initWithNibName:@"CategoryControllerVC" bundle:nil];
        [ccvc setDelegate:self];									//---comm
        
        //push control to CategoryControllerVC
        NSLog(@"MainScreenVC: push VC to CategoryControllerVC");
        [self.navigationController pushViewController:ccvc animated:NO];
        
        [ccvc release];
    }
    

}

- (void)launchDecisionGame {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:CONTROL_GROUP_ON_BOOL]){
        ControlGroupViewController* vc = [[ControlGroupViewController alloc] initWithNibName:@"ControlGroupViewController" bundle:nil];
        
        [self presentViewController:vc animated:YES completion:^{
            [vc startTask:decision];
        }];
    }
    else{
        [self logIt:@"----- DECISION game launched"];
        
        dcvc = [[DecisionControllerVC alloc] initWithNibName:@"DecisionControllerVC" bundle:nil];
        [dcvc setDelegate:self];									//---comm
        
        //push control to CategoryControllerVC
        NSLog(@"MainScreenVC: push VC to DecisionControllerVC");
        [self.navigationController pushViewController:dcvc animated:NO];
        
        [dcvc release];
    }
}

- (void)launchSentencesGame; {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:CONTROL_GROUP_ON_BOOL]){
        ControlGroupViewController* vc = [[ControlGroupViewController alloc] initWithNibName:@"ControlGroupViewController" bundle:nil];
        
        [self presentViewController:vc animated:YES completion:^{
            [vc startTask:sentence];
        }];
    }
    else{
        [self logIt:@"----- SENTENCES game launched"];
        
        scvc = [[SentenceControllerVC alloc] initWithNibName:@"SentenceControllerVC" bundle:nil];
        [scvc setDelegate:self];									//---comm
        
        //push control to CategoryControllerVC
        NSLog(@"MainScreenVC: push VC to SentenceControllerVC");
        [self.navigationController pushViewController:scvc animated:NO];
        
        [scvc release];
    }
}

- (BOOL)checkDate { 
	
	NSString *currentDate = [self getCurrentDate];
	NSLog(@"Current date: %@",currentDate);
	
	NSString *dateLastPlayed = [asvc getDateLastPlayed];
	NSLog(@"Last Played: %@",dateLastPlayed);
	
	BOOL readyToPlay = [dateLastPlayed caseInsensitiveCompare:currentDate];
	
	if (readyToPlay) {
		NSLog(@"OK to play");
	}
	else {
		NSLog(@"Not today");
	}
	return readyToPlay;
	
}

//////////// ADMIN FUNCTIONS //////////////////

- (void)changeCategoryWordNum:(int)number {
	[asvc changeCategoryWords:number];
	NSLog(@"Telling admin to change category words to %d",number);
}

- (void)changeDecisionWordNum:(int)number {
	[asvc changeDecisionWords:number];
	NSLog(@"Telling admin to change decision words to %d",number);
}

- (void)changeSentenceWordNum:(int)number {
	[asvc changeSentenceWords:number];
	NSLog(@"Telling admin to change sentence number to %d",number);
}

- (void)updateDateLastPlayed {
	//get today's date
	NSString *todaysDate = [self getCurrentDate];
	
	[asvc changeDatePlayedLast:todaysDate];
	[asvc incrementDaysPlayedSoFar];
	
}

- (NSString *)getCurrentDate {
	NSDateFormatter *date_formatter=[[NSDateFormatter alloc]init];
	[date_formatter setDateFormat:@"yyyy-MM-dd"];
	
	NSString *readDate = [date_formatter stringFromDate:[NSDate date]];
	
	[date_formatter release];
	return readDate;
}

- (void)adminPressed {
	//ask for password ("reading")
	AlertPrompt *prompt = [AlertPrompt alloc];
    prompt = [prompt initWithTitle:@"Enter Password" message:@"Password" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"Enter"];
    [prompt show];
    [prompt release];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex != [alertView cancelButtonIndex]) {
        NSString *entered = [(AlertPrompt *)alertView enteredText];
        NSLog(@"Password entry: %@",entered);
		
		
		NSComparisonResult isPassword = [entered caseInsensitiveCompare:@"61801"];
		
		if (!isPassword) {
			//push to admin screen
			[self.navigationController pushViewController:asvc animated:NO];
			[self logIt:@"----- Admin screen accessed"];
		}
		else {
			UIAlertView *wrongAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Incorrect Password"
																delegate:self 
													   cancelButtonTitle:@"Cancel" 
													   otherButtonTitles:nil]; 
			
			[wrongAlert show];
			[wrongAlert release];
			[self logIt:[NSString stringWithFormat:@"Attemped to access admin screen. Entry: %@",entered]];
		}
		
    }
}

- (void)recoverSession
//This was added as a failsafe in case the app crashes (which it tends to do once in a while). Obviously not an optimal solution but it works for the time being
{
    NSLog(@"hello");
    todaysOrder = [LoggingSingleton getRecoverySections];
    countForToday = [[LoggingSingleton getRecoverySection] integerValue];
    
    int session = [[todaysOrder objectAtIndex:countForToday] integerValue];
    if(session == 0){
        [self launchCategoryGame];
        [ccvc view];
        [ccvc recover];
    }else if(session == 1){
        [self launchDecisionGame];
        [dcvc view];
        [dcvc recover];
    }else if(session == 2){
        [self launchSentencesGame];
        [scvc view];
        [scvc recover];
    }
}
///////////// DELEGATE FUNCTIONS //////////////////////////////

- (NSString *)getTag {		
	NSString *tag = [asvc getTag];
	return tag;
}

- (int)getTime {	//returns time-to-play in seconds
	float minutes = [asvc getTimePerRound];
					 
	NSLog(@"time: %f seconds",minutes*60);
	return minutes*60;
	
}

- (int)getCategoryWordNum {
	int num = [asvc getCategoryWords];
	return num;
}

- (int)getDecisionWordNum {
	int num = [asvc getDecisionWords];
	return num;
}

- (int)getSentenceWordNum {
	int num = [asvc getSentenceWords];
	return num;
}

- (int)getMaxWords{
    return [asvc getMaxWords];
}
- (int)getMinWords{
    return [asvc getMinWords];
}

///////// LOG FUNCTIONS /////////////////////////

- (void) logIt:(NSString *)whatToLog {
	
	NSString *expTag = [self getTag];
	NSLog(@"To-Log recieved: %@",whatToLog);
	
	NSString *directory = [self getDocumentsDirectory];
	NSString *logFileName = [NSString stringWithFormat:@"/%@-log.txt",expTag];
	NSString *filePath = [directory stringByAppendingString:logFileName];
	//NSLog(@"filePath is: %@",filePath);
	
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	if(![fileManager fileExistsAtPath:filePath]) {
		NSLog(@"Log file does not exist. Creating...");
		[fileManager createFileAtPath:filePath contents:nil attributes:nil];
	}
	else {
		//NSLog(@"Log file already exists");
	}
	
	NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];  //telling fileHandle what file write to
	
	NSDateFormatter *date_formatter=[[NSDateFormatter alloc]init];
	[date_formatter setDateFormat:@"MM.dd.yyyy - HH:mm:ss.SSS "];
	
	NSString *readDate = [date_formatter stringFromDate:[NSDate date]];
	
	[fileHandle truncateFileAtOffset:[fileHandle seekToEndOfFile]]; //setting aFileHandle to write at the end of the file
	
	NSString *stringToWrite = readDate;
	[fileHandle writeData:[stringToWrite dataUsingEncoding:NSUTF8StringEncoding]]; //write date
	
	stringToWrite = whatToLog;
	[fileHandle writeData:[stringToWrite dataUsingEncoding:NSUTF8StringEncoding]]; //actually write the data
	
	[fileHandle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]]; //add carriage return
	//[fileHandle closeFile];
	
	[fileHandle synchronizeFile]; //adding this makes sure the file is stored!
	
	[fileManager release];
	[date_formatter release];
}

- (NSString *)getDocumentsDirectory {  
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
	return [paths objectAtIndex:0];  
}


- (void)viewDidAppear:(BOOL)animated {
    [[LoggingSingleton sharedSingleton] writeBufferToFile];
	// check to see if we're ready to start a new day
	[self mainScreenShown];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [realFakeButton setHidden:[AdminScreenVC shouldShowMainMenuItems]];
    [categoryButton setHidden:[AdminScreenVC shouldShowMainMenuItems]];
    [sentencesButton setHidden:[AdminScreenVC shouldShowMainMenuItems]];    
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Memory Training";
    
	
	//put "Show Log" button in top right corner
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"Admin Interface" 
											   style:UIBarButtonItemStylePlain
											   target:self
											   action:@selector(adminPressed)] autorelease];
	
    NSString *defaultPrefsFile = [[NSBundle mainBundle] pathForResource:@"defaults" ofType:@"plist"];
    NSDictionary *defaultPreferences = [NSDictionary dictionaryWithContentsOfFile:defaultPrefsFile];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPreferences];
    
	//initilize an administrator screen
	asvc = [[AdminScreenVC alloc] initWithNibName:@"AdminScreenVC" bundle:nil];
	[asvc setDelegate:self];
    [asvc view];
	//[asvc loadSettings];
	//push/pop view controller to asvc so all fields get initialized
	//[self.navigationController pushViewController:asvc animated:NO];
	
	[self mainScreenShown];
    
    //[[NSUserDefaults standardUserDefaults] synchronize];
    NSDate* approxCrashTime = [LoggingSingleton getRecoveryTime];
    BOOL validExit = [LoggingSingleton getRecoveryValidExit];
    
    
    
    
    
    if(!validExit && approxCrashTime != nil && fabs([approxCrashTime timeIntervalSinceNow]) < 60){
        [self recoverSession];
        UIAlertView *recoveryAlert = [[UIAlertView alloc] initWithTitle:nil message: [NSString stringWithFormat:@"Your application recovered from a crash, please report this error to study conductor.  ### %s ::: %@ ::: %s", (validExit ? "true" : "false"), approxCrashTime, (fabs([approxCrashTime timeIntervalSinceNow]) < 60 ? "true" : "false")]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [recoveryAlert show];
        [recoveryAlert release];
    }
    [LoggingSingleton setRecoveryValidExit:NO];
}

////////////// SYSTEM ///////////////////////////////

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
	[asvc release];
}


@end
