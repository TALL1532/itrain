//
//  RecallEntryVC.h
//  Memory Training
//
//  Created by Andrew Battles on 7/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProcessDataDelegate3 <NSObject>	//---comm
- (void)recallEnded:(int)numCorrect withTotalWords:(int)totalWords;
- (void)logIt:(NSString *)whatToLog;
@end										//---comm


@interface RecallEntryVC : UIViewController <UITextViewDelegate, UITextFieldDelegate> {
    IBOutlet UIButton *enterButton;
    IBOutlet UITextView *instructionsView;
	IBOutlet UIScrollView *entryScrollView;
	
	int numWords;
	NSMutableArray *textFieldArray;
	NSArray *correctAnswersArray;
	
	id <ProcessDataDelegate3> delegate;		//---comm
}
- (IBAction)enterPressed:(id)sender;

@property (assign) id delegate;				//---comm
@property (nonatomic, retain) NSArray *fields;
@property (nonatomic, retain) NSString *wordsName;

@end
