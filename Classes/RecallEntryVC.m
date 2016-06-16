    //
//  RecallEntryVC.m
//  Memory Training
//
//  Created by Andrew Battles on 7/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "RecallEntryVC.h"
#import "LoggingSingleton.h"

@implementation RecallEntryVC

@synthesize delegate;												//---comm

- (IBAction)enterPressed:(id)sender {
    [[self delegate] logIt:@"----- ENTER pressed on recall screen"];
	
	UITextField *field;
	int rightAnswers = 0;
	NSString *enteredWord;
	NSString *correctWord;
	NSComparisonResult isSameWord;
	for (int i = 0; i<textFieldArray.count; i++) {
		//get the value of each text field
		field = [textFieldArray objectAtIndex:i];
		
		//compare that value to the correct answer
		enteredWord = [field.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		//NSLog(@"entrylength: %d",enteredWord.length);
		if (enteredWord.length > 0) {
			correctWord = [correctAnswersArray objectAtIndex:i];
			isSameWord = [enteredWord caseInsensitiveCompare:correctWord];
			if (isSameWord == NSOrderedSame) {
				[[self delegate] logIt:[NSString stringWithFormat:@"----- Entry %d: %@ -- CORRECT",i+1,field.text]];
				rightAnswers++;
			}
			else {
				[[self delegate] logIt:[NSString stringWithFormat:@"----- Entry %d: %@ -- INCORRECT",i+1,field.text]];
			}

		}
	}    
	[self.navigationController popViewControllerAnimated:NO];
	[[self delegate] recallEnded:rightAnswers withTotalWords:textFieldArray.count];
}

- (void)createFields {
	instructionsView.text = [NSString stringWithFormat:@"Now enter the %@ in the order they appeared.", self.wordsName];
	
	CGFloat yPos;
	UITextField *textField;
	UILabel *label;
    
    
	
	textFieldArray = [[NSMutableArray alloc] init];
	
    entryScrollView.contentSize = CGSizeMake(entryScrollView.frame.size.width, self.fields.count*90 + 30);
	for (int i = 0; i< self.fields.count; i++) {
		
		//get the y position for this button and label
		yPos = 20+i*90;
	
		textField = [[UITextField alloc] initWithFrame:CGRectMake(100, yPos, 400, 70)];
		textField.borderStyle = UITextBorderStyleRoundedRect;
		textField.font = [UIFont boldSystemFontOfSize:40];
		//textField.placeholder = @"Typewriter";
		textField.autocorrectionType = UITextAutocorrectionTypeNo;
		textField.keyboardType = UIKeyboardTypeDefault;
		textField.returnKeyType = UIReturnKeyDone;
		//textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		//textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		textField.delegate = self;
		textField.tag = i;
		[entryScrollView addSubview:textField];
		[textFieldArray addObject:textField];
		[textField release];
	
		label = [[UILabel alloc] initWithFrame:CGRectMake(20, yPos, 80, 70)];
		label.font = [UIFont boldSystemFontOfSize:40];
		label.text = [NSString stringWithFormat:@"%d.",i+1];
		label.backgroundColor = [UIColor colorWithRed:255/255.0 green:224/255.0 blue:155/255.0 alpha:0.0];
		[entryScrollView addSubview:label];
		[label release];
        
	}
    
	[[self delegate] logIt:@"----- Showing recall screen"];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	
	[[self delegate] logIt:[NSString stringWithFormat:@"----- Began entering word %d",textField.tag+1]];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	
	[[self delegate] logIt:[NSString stringWithFormat:@"----- Done entering word %d",textField.tag+1]];
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.hidesBackButton = YES;
	self.navigationItem.title = @"End Of Set";
	
    [self createFields];
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
    
	[textFieldArray release];
	[correctAnswersArray release];
    [super dealloc];
}


@end
