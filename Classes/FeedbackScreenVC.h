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
	
	NSInteger nextWordCount;
	
	id <ProcessDataDelegate4> delegate;		//---comm
}
- (IBAction)readyForNextPressed:(id)sender;

@property (assign) id delegate;				//---comm

@property (nonatomic, assign) NSInteger numCorrect;
@property (nonatomic, assign) NSInteger numTotal;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, assign) NSInteger numErrors;
@property (nonatomic, retain) NSString *typeOfError;

@end
