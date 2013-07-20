//
//  CategoryVC.h
//  Memory Training
//
//  Created by Andrew Battles on 7/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecallEntryVC.h"
#import "FeedbackScreenVC.h"

@protocol ProcessDataDelegate2 <NSObject>	//---comm
- (void)categoryEnded:(int)nextNumWords;	//---comm
- (void)categoryQuit:(int)nextNumWords;		//---comm
- (void)logIt:(NSString *)whatToLog;		//---comm
@end										//---comm


@interface CategoryVC : UIViewController {
    IBOutlet UIButton *inCategoryButton;
    IBOutlet UIButton *notCategoryButton;
    IBOutlet UITextView *thisWordView;
    IBOutlet UILabel *correctIndicator;
	IBOutlet UILabel *categoryLabel;
	RecallEntryVC *revc;
	FeedbackScreenVC *fevc;
	
	NSMutableArray *wordsArray;
	NSMutableArray *inCategoryTrack;
	NSMutableArray *correctChoiceTrack;
	
	int currentWordNum;
	int wordsThisRound;
	bool buttonPressed;
	id <ProcessDataDelegate2> delegate;		//---comm
    
    NSDate* wordShown;
}
- (IBAction)inCategoryPressed:(id)sender;
- (IBAction)notCategoryPressed:(id)sender;

- (void)buttonPressed:(BOOL)inCategory;

- (void)startPuzzle:(int)categoryNum withWords:(int)numWords;
- (void)setNumOfWords:(int)numWords;

- (void)displayNextWord;
- (void)hideWordAfterWait:(NSNumber *)thisWordNum;

- (void)pushToRecall:(NSArray *)words;
- (void)recallEnded:(int)numCorrect withTotalWords:(int)totalWords;

- (void)feedbackEnded:(int)nextWordCount;

- (void)quitPressed;

- (void)logIt:(NSString *)whatToLog;


@property (retain) id delegate;				//---comm

@end
