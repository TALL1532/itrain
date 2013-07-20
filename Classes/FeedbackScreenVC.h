//
//  FeedbackScreenVC.h
//  Memory Training
//
//  Created by Andrew Battles on 7/26/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProcessDataDelegate4 <NSObject>	//---comm
- (void)feedbackEnded:(int)nextWordCount;
- (void)logIt:(NSString *)whatToLog;
@end


@interface FeedbackScreenVC : UIViewController {
    IBOutlet UILabel *congratsLabel;
    IBOutlet UITextView *correctClassLabel;
    IBOutlet UITextView *correctWordsView;
    IBOutlet UILabel *percentCorrectLabel;
    IBOutlet UIButton *readyForNextButton;
	
	int nextWordCount;
	
	id <ProcessDataDelegate4> delegate;		//---comm
}
- (IBAction)readyForNextPressed:(id)sender;

- (void)displayResults:(int)numCorrect withTotal:(int)numTotal withType:(NSString *)typeOfNum withErrors:(int)numErrors andErrorType:(NSString *)typeOfError;

@property (assign) id delegate;				//---comm

@end
