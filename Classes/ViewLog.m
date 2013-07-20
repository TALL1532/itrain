    //
//  ViewLog.m
//  Span Task
//
//  Created by Andrew Battles on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewLog.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@implementation ViewLog

@synthesize delegate;												//---comm

- (IBAction)emailLogPressed:(id)sender {
    
	NSLog(@"Sending email");
	expTag = [[self delegate] getTag];
	
	
    NSString *directory = [self getDocumentsDirectory];
	NSString *logFileName = [NSString stringWithFormat:@"/%@-log.txt",expTag];
	NSString *filePath = [directory stringByAppendingString:logFileName];
		
	//NSString *audioPath = [directory stringByAppendingString:@"/audio1.caf"];
	
	//Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	// Set subject line
	[picker setSubject:@"Adult Learning Lab iPad Log File"];
	
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:@"AdultLearningLab.ipad@gmail.com"]; 
	[picker setToRecipients:toRecipients];
	
	// Attach log to the email
	NSData *myData = [NSData dataWithContentsOfFile:filePath];
	[picker addAttachmentData:myData mimeType:@"text/plain" fileName:logFileName];
	
	/*
	int i;
	NSData *audioData;
	NSString *audioName;
	// Attach PRAC audio data to email
	for (i=1; i<4; i++) {
		audioName = [NSString stringWithFormat:@"%@-PR-audio%d.caf",expTag,i];
		filePath = [directory stringByAppendingString:[NSString stringWithFormat:@"/%@",audioName]];
		audioData = [NSData dataWithContentsOfFile:filePath];
		[picker addAttachmentData:audioData mimeType:@"audio/caf" fileName:audioName];
	}
	
	// Attach CT audio data to email
	for (i=1; i<25; i++) {
		audioName = [NSString stringWithFormat:@"%@-CT-audio%d.caf",expTag,i];
		filePath = [directory stringByAppendingString:[NSString stringWithFormat:@"/%@",audioName]];
		audioData = [NSData dataWithContentsOfFile:filePath];
		[picker addAttachmentData:audioData mimeType:@"audio/caf" fileName:audioName];
	}
	
	// Attach RI audio data to email
	for (i=1; i<25; i++) {
		audioName = [NSString stringWithFormat:@"%@-RI-audio%d.caf",expTag,i];
		filePath = [directory stringByAppendingString:[NSString stringWithFormat:@"/%@",audioName]];
		audioData = [NSData dataWithContentsOfFile:filePath];
		[picker addAttachmentData:audioData mimeType:@"audio/caf" fileName:audioName];
	}
	
	// Attatch TLOG audio data to email
	for (i = 1; i<4;i++) {
		switch(i) {
		case 1:
			audioName = [NSString stringWithFormat:@"%@-PR-TLOG.caf",expTag];
			break;
		case 2:
			audioName = [NSString stringWithFormat:@"%@-CT-TLOG.caf",expTag];
			break;
		case 3:
			audioName = [NSString stringWithFormat:@"%@-RI-TLOG.caf",expTag];
			break;
		}
	filePath = [directory stringByAppendingString:[NSString stringWithFormat:@"/%@",audioName]];
	audioData = [NSData dataWithContentsOfFile:filePath];
	[picker addAttachmentData:audioData mimeType:@"audio/caf" fileName:audioName];
	}
	*/
	
	// Fill out the email body text
	NSString *emailBody = @"Log file attached.";
	[picker setMessageBody:emailBody isHTML:NO];
	if (picker != nil) {
		[self presentViewController:picker animated:YES completion:nil];
		[picker release];
	}
	/*
	[self presentModalViewController:picker animated:YES];
    [picker release];
	*/
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error { 
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			NSLog(@"Compose cancelled");
			break;
		case MFMailComposeResultSaved:
			NSLog(@"Compose saved");
			break;
		case MFMailComposeResultSent:
			NSLog(@"Compose sent");
			break;
		case MFMailComposeResultFailed:
			NSLog(@"Compose failed");
			break;
			
		default:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
			[alert release];
		}
			
			break;
	}
	[self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)clearLogPressed:(id)sender {
	
	
	UIAlertView *checkAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to clear the log and delete any audio files for this subject?" 
													   delegate:self 
											  cancelButtonTitle:@"Cancel" 
											   otherButtonTitles:@"Clear Log",nil]; 
	
	[checkAlert show];
	[checkAlert release];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        //NSLog(@"cancel");
    }
    else if (buttonIndex == 1)
    {
		
        NSString *directory = [self getDocumentsDirectory];
		NSString *logFileName = [NSString stringWithFormat:@"/%@-log.txt",expTag];
		NSString *filePath = [directory stringByAppendingString:logFileName];
		
		NSFileManager *fileManager = [[NSFileManager alloc] init];
		
		[fileManager removeItemAtPath:filePath  error:nil];
		
		[self displayLogContents];
		[fileManager release];
//		[self deleteAudioFiles];
    }
}
/*
- (void)deleteAudioFiles {
	
	//initialize necessary filenames and file manager
	expTag = [[self delegate] getTag];
	NSString *directory = [self getDocumentsDirectory];
	NSString *filePath;
	NSString *audioName;
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	
	int i;
	// Delete PRAC audio 
	for (i=1; i<4; i++) {
		audioName = [NSString stringWithFormat:@"%@-PR-audio%d.caf",expTag,i];
		filePath = [directory stringByAppendingString:[NSString stringWithFormat:@"/%@",audioName]];
		[fileManager removeItemAtPath:filePath error:nil];
	}
	
	// Attach CT audio data to email
	for (i=1; i<25; i++) {
		audioName = [NSString stringWithFormat:@"%@-CT-audio%d.caf",expTag,i];
		filePath = [directory stringByAppendingString:[NSString stringWithFormat:@"/%@",audioName]];
		[fileManager removeItemAtPath:filePath error:nil];
	}
	
	// Attach RI audio data to email
	for (i=1; i<25; i++) {
		audioName = [NSString stringWithFormat:@"%@-RI-audio%d.caf",expTag,i];
		filePath = [directory stringByAppendingString:[NSString stringWithFormat:@"/%@",audioName]];
		[fileManager removeItemAtPath:filePath error:nil];
	}
	
	// Attatch TLOG audio data to email
	for (i = 1; i<4;i++) {
		switch(i) {
			case 1:
				audioName = [NSString stringWithFormat:@"%@-PR-TLOG.caf",expTag];
				break;
			case 2:
				audioName = [NSString stringWithFormat:@"%@-CT-TLOG.caf",expTag];
				break;
			case 3:
				audioName = [NSString stringWithFormat:@"%@-RI-TLOG.caf",expTag];
				break;
		}
		filePath = [directory stringByAppendingString:[NSString stringWithFormat:@"/%@",audioName]];
		[fileManager removeItemAtPath:filePath error:nil];
	}
	
}*/

- (void)backToMenuPressed {
	
	NSLog(@"BACK TO MENU Pressed");
	self.navigationItem.rightBarButtonItem = nil;
	[self.navigationController popViewControllerAnimated:NO];
	//[self release];
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.title = @"Log";
	
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
											  initWithTitle:@"Back To Admin Screen" 
											  style:UIBarButtonItemStylePlain
											  target:self
											  action:@selector(backToMenuPressed)] autorelease];
	
	[self displayLogContents];
    [super viewDidLoad];
}

- (void)displayLogContents {
	
	expTag = [[self delegate] getTag];
	tagView.text = expTag;
	
	
	NSString *directory = [self getDocumentsDirectory];
	NSString *logFileName = [NSString stringWithFormat:@"/%@-log.txt",expTag];
	NSString *filePath = [directory stringByAppendingString:logFileName];
	
	NSLog(@"filePath: %@\n",filePath);
	
	NSFileManager *fileManager = [[NSFileManager alloc] init];
	
	if(![fileManager fileExistsAtPath:filePath]) {
		logView.text = @"Log Deleted";
	}
	
	else {
		//NSLog(@"Displaying log file");
		NSString *textFromFile = [NSString stringWithContentsOfFile:filePath
														   encoding:NSUTF8StringEncoding 
															  error:nil];
		logView.text = textFromFile; 
	}
	[fileManager release];
}

- (NSString *)getDocumentsDirectory {  
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
	//NSLog(@"%@",[paths objectAtIndex:0]);
	
	return [paths objectAtIndex:0];  
}  


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
	NSLog(@"View to unload");
	[self.navigationController popViewControllerAnimated:NO];
	NSLog(@"popped");
	[self release];
	NSLog(@"released");
    [super viewDidUnload];
	NSLog(@"unloaded");
		
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	NSLog(@"ViewLog: Dealloc");
    [super dealloc];
}



@end
