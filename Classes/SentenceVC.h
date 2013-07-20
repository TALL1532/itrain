//
//  SentenceVC.h
//  Memory Training
//
//  Created by Andrew Battles on 8/2/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecallEntryVC.h"
#import "FeedbackScreenVC.h"

@protocol ProcessDataDelegate9 <NSObject>	//---comm
- (void)sentenceEnded:(int)nextNumWords;	//---comm
- (void)sentenceQuit:(int)nextNumWords;		//---comm
- (void)logIt:(NSString *)whatToLog;		//---comm
@end

@interface SentenceVC : UIViewController {
    IBOutlet UILabel *correctIndicator;
    IBOutlet UIButton *falseButton;
    IBOutlet UITextView *sentenceView;
    IBOutlet UIButton *trueButton;
	
	RecallEntryVC *revc;
	FeedbackScreenVC *fevc;
	
	NSMutableArray *sentenceArray;
	NSMutableArray *wordsArray;
	NSMutableArray *inCategoryTrack;
	NSMutableArray *correctChoiceTrack;
	
	int currentWordNum;
	int wordsThisRound;
	bool buttonPressed;
	id <ProcessDataDelegate9> delegate;		//---comm
	
    NSDate* wordShown;
}
- (IBAction)falsePressed:(id)sender;
- (IBAction)truePressed:(id)sender;

- (void)buttonPressed:(BOOL)trueSelected;

- (void)startPuzzle:(int)categoryNum withWords:(int)numWords;
- (void)setNumOfWords:(int)numWords;

- (void)displayNextSentence;
- (void)hideWordAfterWait:(id)sentenceNum;

- (void)pushToRecall:(NSArray *)words;
- (void)recallEnded:(int)numCorrect withTotalWords:(int)totalWords;

- (void)feedbackEnded:(int)nextWordCount;

- (void)quitPressed;

- (void)logIt:(NSString *)whatToLog;		
+ (int)chooseUnusedSentence:(bool)makesSense withRealSentenceCap:(NSInteger)numRealSentence andFakeSentenceCap:(NSInteger)numFakeSentence;
@property (retain) id delegate;				//---comm

@end
