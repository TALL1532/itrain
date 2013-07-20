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

//- (void)startPuzzle:(int)words;
- (void)createFields:(NSArray *)words ofTypes:(NSString *)type;

- (void)quitPressed;

@property (assign) id delegate;				//---comm

@end
