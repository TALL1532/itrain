//
//  DecisionVC.h
//  Memory Training
//
//  Created by Andrew Battles on 7/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecallEntryVC.h"
#import "FeedbackScreenVC.h"

@protocol ProcessDataDelegate7 <NSObject>	//---comm
- (void)decisionEnded:(int)nextNumWords;	//---comm
- (void)decisionQuit:(int)nextNumWords;		//---comm
- (void)logIt:(NSString *)whatToLog;		//---comm
@end										//---comm

@interface DecisionVC : UIViewController {
    IBOutlet UILabel *correctIndicator;
    IBOutlet UITextView *letterDisplay;
    IBOutlet UIButton *notWordButton;
    IBOutlet UITextView *thisWordView;
    IBOutlet UIButton *wordButton;
	
	RecallEntryVC *revc;
	FeedbackScreenVC *fevc;
	
	NSMutableArray *wordsArray;
	NSMutableArray *inCategoryTrack;
	NSMutableArray *correctChoiceTrack;
	NSMutableArray *randomLettersArray;
	
	int currentWordNum;
	int wordsThisRound;
	
	bool buttonPressed;
	id <ProcessDataDelegate7> delegate;		//---comm

    NSDate* wordShown;
}

- (IBAction)notWordPressed:(id)sender;
- (IBAction)wordPressed:(id)sender;

- (void)buttonPressed:(BOOL)isWord;

- (void)startPuzzle:(int)categoryNum withWords:(int)numWords;
- (void)setNumOfWords:(int)numWords;

- (void)showNextLetter;
- (void)displayNextWord;
- (void)hideWord:(NSNumber*)word;
- (void)showWord;


- (void)pushToRecall:(NSArray *)letters;
- (void)recallEnded:(int)numCorrect withTotalWords:(int)totalWords;

- (void)feedbackEnded:(int)nextWordCount;

- (void)quitPressed;

- (void)logIt:(NSString *)whatToLog;		
+ (int)chooseUnusedWord:(bool)isWord withWordCap:(NSInteger)wordCap andNotWordCap:(NSInteger)notWordCap;

@property (retain) id delegate;				//---comm

@end
