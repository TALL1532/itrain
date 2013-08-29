//
//  ControlGroupViewController.m
//  Memory Training
//
//  Created by Thomas Deegan on 7/23/13.
//
//

#import "ControlGroupViewController.h"

@interface ControlGroupViewController ()
@end


@implementation ControlGroupViewController
-(void)showInstructions:(NSString*)task{
    ModalInstructionsViewController* instructions =  [[ModalInstructionsViewController alloc] init];
    instructions.delegate = self;
    instructions.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:instructions animated:YES completion:nil];
    NSString *instructionsPath = @"nothing :(";

    if([task isEqualToString: category]){
        instructionsPath = [[NSBundle mainBundle] pathForResource:@"controlGroupInstructionsCategory" ofType:@"txt"];
    }
    if([task isEqualToString: decision]){
        instructionsPath = [[NSBundle mainBundle] pathForResource:@"controlGroupInstructionsDecision" ofType:@"txt"];
    }
    if([task isEqualToString: sentence]){
        instructionsPath = [[NSBundle mainBundle] pathForResource:@"controlGroupInstructionsSentence" ofType:@"txt"];
    }
	NSString *instructionsText = [NSString stringWithContentsOfFile:instructionsPath
													   encoding:NSUTF8StringEncoding
														  error:nil];
    
    [instructions setText:instructionsText];
}
-(void)doneWithInstructions:(id)controller{
    NSLog(@"DONE WITH INSTRUCTIONS!");
    [self nextRound];
    //[(ModalInstructionsViewController*) controller release];
}
-(NSMutableArray*)generateContentFor:(NSString*)task{
    NSMutableArray* truthArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < _numWords; i++){
        [truthArray addObject:[NSNumber numberWithBool: arc4random()%2 ? YES : NO]];
    }
    _inCategroyTrack = [ControlGroupViewController shuffle:truthArray];
    truthArray = nil;
    
    if([task isEqualToString:category]){
        int categoryNumber = [CategoryControllerVC chooseCategory];
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"category-data" ofType:@"plist"];
        NSArray * contentArray = [NSArray arrayWithContentsOfFile:plistPath];
        categoryLabel.text = [NSString stringWithFormat:@"Category: %@",[(NSDictionary*)[contentArray objectAtIndex:categoryNumber] objectForKey:@"title"]];
        NSMutableArray *wrongCategories = [[NSMutableArray alloc] init];
        NSInteger notInCatIndex;
        for(int i =0; i< 3; i++){
            notInCatIndex = arc4random()%[contentArray count];
            while(notInCatIndex == categoryNumber){
                notInCatIndex = arc4random()%[contentArray count];
            }
            [wrongCategories addObject:[NSNumber numberWithInt:notInCatIndex]];
        }
        
        
        NSString *cont = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: [(NSDictionary*)[contentArray objectAtIndex:categoryNumber] objectForKey:@"filename"] ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
        NSArray * inCategory = [cont componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]];
        
        NSArray * notInCategory = [[[NSArray alloc] init] autorelease];
        for(int i = 0; i < [wrongCategories count]; i++){
            NSString *contentwrong = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource: [(NSDictionary*)[contentArray objectAtIndex: [(NSNumber*)[wrongCategories objectAtIndex:i] integerValue]] objectForKey:@"filename"] ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
            
            
            notInCategory = [notInCategory arrayByAddingObjectsFromArray: [contentwrong componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]]];
        }
        [wrongCategories release];
        wrongCategories = nil;
        
        NSMutableArray* wordsArray = [[NSMutableArray alloc] init];
        
        for (int i=0; i<_numWords; i++) {
            BOOL categoryDecider = [(NSNumber*)[_inCategroyTrack objectAtIndex:i] boolValue];
            NSString *wordToAdd;
            do{
                if(categoryDecider){
                    wordToAdd = [inCategory objectAtIndex:arc4random()%[inCategory count]];
                }
                else{
                    wordToAdd = [notInCategory objectAtIndex:arc4random()%[notInCategory count]];
                }
            }while ([wordsArray indexOfObject:wordToAdd] != NSNotFound);
            [wordsArray addObject:wordToAdd];
        }
        return [wordsArray autorelease];
    }
    else if([task isEqualToString:decision]){
        NSString *realWordsPath = [[NSBundle mainBundle] pathForResource:@"decisionWords" ofType:@"txt"];
        NSString *realWordsList = [NSString stringWithContentsOfFile:realWordsPath
                                                            encoding:NSUTF8StringEncoding
                                                               error:nil];
        
        //NSString *realWordsTrimmed = [realWordsList stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *realWordsArray = [realWordsList componentsSeparatedByCharactersInSet:
                                   [NSCharacterSet newlineCharacterSet]];
        
        NSString *nonWordsPath = [[NSBundle mainBundle] pathForResource:@"non-words" ofType:@"txt"];
        NSString *nonWordsList = [NSString stringWithContentsOfFile:nonWordsPath
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
        
        //NSString *nonWordsTrimmed = [nonWordsList stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *nonWordsArray = [nonWordsList componentsSeparatedByCharactersInSet:
                                  [NSCharacterSet newlineCharacterSet]];
        
        
        NSMutableArray* wordsArray = [[NSMutableArray alloc] init];
        
        for (int i=0; i<_numWords; i++) {
            BOOL isWord = [(NSNumber*)[_inCategroyTrack objectAtIndex:i] boolValue];
            NSString *wordToAdd;
            do{
                if(isWord){
                    NSInteger asdf = [DecisionVC chooseUnusedWord:YES withWordCap:[realWordsArray count] andNotWordCap:[nonWordsArray count]];
                    wordToAdd = [realWordsArray objectAtIndex:asdf];
                }
                else{
                    NSInteger asdf = [DecisionVC chooseUnusedWord:NO withWordCap:[realWordsArray count] andNotWordCap:[nonWordsArray count]];
                    wordToAdd = [nonWordsArray objectAtIndex:asdf];
                }
            }while ([wordsArray indexOfObject:wordToAdd] != NSNotFound);
            [wordsArray addObject:wordToAdd];
        }
        return [wordsArray autorelease];
    }
    else if([task isEqualToString:sentence]){
        NSString *truePath = [[NSBundle mainBundle] pathForResource:@"trueSentences" ofType:@"txt"];
        NSString *falsePath = [[NSBundle mainBundle] pathForResource:@"falseSentences" ofType:@"txt"];
        
        NSString *trueList = [NSString stringWithContentsOfFile:truePath
                                                       encoding:NSUTF8StringEncoding
                                                          error:nil];
        NSString *falseList = [NSString stringWithContentsOfFile:falsePath
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];
        NSArray *trueArray = [trueList componentsSeparatedByCharactersInSet:
                              [NSCharacterSet newlineCharacterSet]];
        NSArray *falseArray = [falseList componentsSeparatedByCharactersInSet:
                               [NSCharacterSet newlineCharacterSet]];
        
        NSMutableArray* sentanceArray = [[NSMutableArray alloc] init];
        
        for (int i=0; i<_numWords; i++) {
            BOOL makesSense = [(NSNumber*)[_inCategroyTrack objectAtIndex:i] boolValue];
            NSString *sentenceToAdd;
            do{
                if(makesSense){
                    sentenceToAdd = [trueArray objectAtIndex:[SentenceVC chooseUnusedSentence:YES withRealSentenceCap:[trueArray count] andFakeSentenceCap:[falseArray count]]];
                }
                else{
                    sentenceToAdd = [falseArray objectAtIndex:[SentenceVC chooseUnusedSentence:NO withRealSentenceCap:[trueArray count] andFakeSentenceCap:[falseArray count]]];
                }
            }while ([sentanceArray indexOfObject:sentenceToAdd] != NSNotFound);
            [sentanceArray addObject:sentenceToAdd];
        }
        return [sentanceArray autorelease];
    }
    else{
        [NSException raise:NSInvalidArgumentException format:@"task must be one of the three"];
    }
    return nil;
}
-(void)startTask:(NSString*)task{
    [self showInstructions:task];

    _numWords = [[NSUserDefaults standardUserDefaults] integerForKey:CONTROL_GROUP_NUM_WORDS_INT];
    _currentTask = task;
    categoryLabel.text = @"";


    _timeForTask = [[NSUserDefaults standardUserDefaults] floatForKey:TASK_TIME] * 60;
    _startTime = [[NSDate date] retain];
    
    [self updateLevelIndicatorLabel];
    
}
- (void)nextRound {
    _totalCorrect = 0;
    if( [[_startTime dateByAddingTimeInterval:_timeForTask] timeIntervalSinceNow] < 0){
        [self.delegate checkDoneForToday];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        _currentWord = 0;
        _hasPressedButton = NO;
        [_speedRecords release];
        _speedRecords = nil;
        _speedRecords = [[NSMutableArray alloc] init];
        [self showButtons];
        [_wordTrack release];
        _wordTrack = nil;
        _wordTrack = [[self generateContentFor:_currentTask] retain];
        
        _timePerWord = [ControlGroupViewController getTimeForWordInTask:_currentTask];

        [self nextWord];
    }
}
-(void)nextWord{
    [self showButtons];
    if(_currentWord == _numWords) {
        [self hideButtons];
        [self showScoreScreen];
    }
    else{
        content.text = [_wordTrack objectAtIndex:_currentWord];
        [revealTime release];
        revealTime = nil;
        revealTime = [[NSDate date] retain];
        _currentWord++;
        [self performSelector:@selector(timerUp:) withObject:nil afterDelay:_timePerWord/1000 ];
        [self animateClock:_timePerWord];
    }
}
-(void)animateClock:(NSTimeInterval)time{
    NSLog((@"animating"));
    countDown.frame = CGRectMake(0, 0, self.view.frame.size.width, countDown.frame.size.height);
    [UIView animateWithDuration:time/1000 animations:^{
        countDown.frame = CGRectMake(0, 0, 0, countDown.frame.size.height);
    }];
}
-(void)timerUp:(id)sender{
    [self nextWord];
}
-(void)showScoreScreen{
    if( _totalCorrect >= [[NSUserDefaults standardUserDefaults] integerForKey:CONTROL_GROUP_NUM_NEEDED_TO_ADVANCE_INT]){
        [ControlGroupViewController increaseLevelForWordInTask:_currentTask];
    }
    if( _totalCorrect <= [[NSUserDefaults standardUserDefaults] integerForKey:CONTROL_GROUP_NUM_NEEDED_TO_DEMOTE_INT]){
        [ControlGroupViewController decreaseLevelForWordInTask:_currentTask];
    }
    [self updateLevelIndicatorLabel];
    
    ControlFeedbackViewController* feedback = [[ControlFeedbackViewController alloc] init];
    feedback.delegate = self;
    feedback.modalPresentationStyle = UIModalPresentationFormSheet;
    feedback.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:feedback animated:YES completion:nil];
    
    feedback.view.superview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    feedback.view.superview.bounds = CGRectMake(0, 0, 400, 500);
    
    CGFloat ave = 0.0;
    for(int i = 0; i < [_speedRecords count];i++){
        ave = ave - [(NSNumber*)[_speedRecords objectAtIndex:i] floatValue];
    }
    ave = ave / (float)[_speedRecords count];
    
    NSDateFormatter *date_formatter=[[NSDateFormatter alloc] init];
	[date_formatter setDateFormat:@"MM.dd.yyyy - HH:mm:ss.SSS "];
    [[LoggingSingleton sharedSingleton]
     storeTrialDataWithName:[LoggingSingleton getSubjectName]
     task:_currentTask
     sessionNumber:[LoggingSingleton getSessionNumber]
     date:[date_formatter stringFromDate:[NSDate date]]
     trial:[LoggingSingleton sharedSingleton].currentTrial
     taskAccuracy:((float)_totalCorrect/(float)_numWords)
     averageReactionTime:(int)(ave*1000)
     memoryAccuracy:0.0
     andSpanLevel: [ControlGroupViewController getTaskLevel:_currentTask]];
    [[LoggingSingleton sharedSingleton] writeBufferToFile];
    [date_formatter release];
}
-(void)buttonPressed:(BOOL)wasTrue {
    if(_hasPressedButton) return;
    _hasPressedButton = YES;
    NSNumber* time = [NSNumber numberWithDouble:[revealTime timeIntervalSinceNow]];
    [revealTime release];
    revealTime = nil;
    [_speedRecords addObject:time];
    if([(NSNumber*)[_inCategroyTrack objectAtIndex:_currentWord-1] boolValue] == wasTrue){
        _totalCorrect++;
        right.hidden = NO;
    }else{
        wrong.hidden = NO;
    }
    [self hideButtons];
}
-(void)hideButtons{
    yesButton.hidden = YES;
    noButton.hidden = YES;
}
-(void)showButtons{
    _hasPressedButton = NO;
    yesButton.hidden = NO;
    noButton.hidden = NO;
    wrong.hidden = YES;
    right.hidden = YES;
}
-(void)updateLevelIndicatorLabel{
    NSLog(@"changed level indicator %d", [ControlGroupViewController getTaskLevel:_currentTask]);
    levelIndicatorLabel.text = [NSString stringWithFormat:@"%d", [ControlGroupViewController getTaskLevel:_currentTask] ];
}



//stackoverflow.com/questions/56648/whats-the-best-way-to-shuffle-an-nsmutablearray
+(NSMutableArray*)shuffle:(NSMutableArray*) array{
    NSUInteger count = [array count];
    for (uint i = 0; i < count; ++i)
    {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = arc4random_uniform(nElements) + i;
        [array exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return array;
}
+(bool)checkHighScoreByLevel:(NSInteger)level andTask:(NSString*)task{
    NSInteger high = 0;
    if([task isEqualToString: category]){
        high = [[NSUserDefaults standardUserDefaults] integerForKey:CONTROL_GROUP_CATEGROY_DIFFICULTY_LEVEL_HIGHSCORE_INT];
    }
    if([task isEqualToString: decision]){
        high = [[NSUserDefaults standardUserDefaults] integerForKey:CONTROL_GROUP_DECISION_DIFFICULTY_LEVEL_HIGHSCORE_INT];
    }
    if([task isEqualToString: sentence]){
        high = [[NSUserDefaults standardUserDefaults] integerForKey:CONTROL_GROUP_SENTENCE_DIFFICULTY_LEVEL_HIGHSCORE_INT];
    }
    if (level <= high){
        return false;
    }
    if([task isEqualToString: category]){
        [[NSUserDefaults standardUserDefaults] setInteger:level forKey:CONTROL_GROUP_CATEGROY_DIFFICULTY_LEVEL_HIGHSCORE_INT];
    }
    if([task isEqualToString: decision]){
        [[NSUserDefaults standardUserDefaults] setInteger:level forKey:CONTROL_GROUP_DECISION_DIFFICULTY_LEVEL_HIGHSCORE_INT];
    }
    if([task isEqualToString: sentence]){
        [[NSUserDefaults standardUserDefaults] setInteger:level forKey:CONTROL_GROUP_SENTENCE_DIFFICULTY_LEVEL_HIGHSCORE_INT];
    }
    return true;
}
+(NSTimeInterval)getTimeForWordInTask:(NSString*)task{
    NSInteger level;
    if([task isEqualToString: category]){
        level = [[NSUserDefaults standardUserDefaults] integerForKey:CONTROL_GROUP_CATEGROY_DIFFICULTY_LEVEL_INT];
    }
    if([task isEqualToString: decision]){
        level = [[NSUserDefaults standardUserDefaults] integerForKey:CONTROL_GROUP_DECISION_DIFFICULTY_LEVEL_INT];
    }
    if([task isEqualToString: sentence]){
        level = [[NSUserDefaults standardUserDefaults] integerForKey:CONTROL_GROUP_SENTENCE_DIFFICULTY_LEVEL_INT];
    }
    CGFloat diffIncrease = [[NSUserDefaults standardUserDefaults] floatForKey:CONTROL_GROUP_REDUCTION_TIME_FLOAT];

    CGFloat wordTime;
    if([task isEqualToString:category]){
        wordTime = [(NSNumber*)[[NSUserDefaults standardUserDefaults] valueForKey:CATEGORY_PRESENTATION_TIME] floatValue];
    }
    else if([task isEqualToString:decision]){
        wordTime = [(NSNumber*)[[NSUserDefaults standardUserDefaults] valueForKey:DECISION_PRESENTATION_TIME] floatValue];
    }
    else if([task isEqualToString:sentence]){
        wordTime = [(NSNumber*)[[NSUserDefaults standardUserDefaults] valueForKey:SENTENCE_PRESENTATION_TIME] floatValue];
    }
    return (pow(diffIncrease, level) * wordTime);
}
+(NSInteger)getTaskLevel:(NSString*)task{
    NSInteger level;
    if([task isEqualToString: category]){
        level = [[NSUserDefaults standardUserDefaults] integerForKey:CONTROL_GROUP_CATEGROY_DIFFICULTY_LEVEL_INT];
    }
    if([task isEqualToString: decision]){
        level = [[NSUserDefaults standardUserDefaults] integerForKey:CONTROL_GROUP_DECISION_DIFFICULTY_LEVEL_INT];
    }
    if([task isEqualToString: sentence]){
        level = [[NSUserDefaults standardUserDefaults] integerForKey:CONTROL_GROUP_SENTENCE_DIFFICULTY_LEVEL_INT];
    }
    return level;
}
+(void)increaseLevelForWordInTask:(NSString*)task{
    NSInteger level;
    if([task isEqualToString: category]){
        level = [[NSUserDefaults standardUserDefaults] integerForKey:CONTROL_GROUP_CATEGROY_DIFFICULTY_LEVEL_INT] + 1;
        [[NSUserDefaults standardUserDefaults] setInteger:level forKey:CONTROL_GROUP_CATEGROY_DIFFICULTY_LEVEL_INT];
    }
    if([task isEqualToString: decision]){
        level = [[NSUserDefaults standardUserDefaults] integerForKey:CONTROL_GROUP_DECISION_DIFFICULTY_LEVEL_INT] + 1;
        [[NSUserDefaults standardUserDefaults] setInteger:level forKey:CONTROL_GROUP_DECISION_DIFFICULTY_LEVEL_INT];
    }
    if([task isEqualToString: sentence]){
        level = [[NSUserDefaults standardUserDefaults] integerForKey:CONTROL_GROUP_SENTENCE_DIFFICULTY_LEVEL_INT] + 1;
        [[NSUserDefaults standardUserDefaults] setInteger:level forKey:CONTROL_GROUP_SENTENCE_DIFFICULTY_LEVEL_INT];
    }
}
+(void)decreaseLevelForWordInTask:(NSString*)task{
    NSInteger level = [ControlGroupViewController getTaskLevel:task];
    //prevent negative levels
    if (level != 0) {
        level --;
    }
    if([task isEqualToString: category]){
        [[NSUserDefaults standardUserDefaults] setInteger:level forKey:CONTROL_GROUP_CATEGROY_DIFFICULTY_LEVEL_INT];
    }
    if([task isEqualToString: decision]){
        [[NSUserDefaults standardUserDefaults] setInteger:level forKey:CONTROL_GROUP_DECISION_DIFFICULTY_LEVEL_INT];
    }
    if([task isEqualToString: sentence]){
        [[NSUserDefaults standardUserDefaults] setInteger:level forKey:CONTROL_GROUP_SENTENCE_DIFFICULTY_LEVEL_INT];
    }
    
}


- (IBAction)yesPressed:(id)sender{[self buttonPressed:YES];}
- (IBAction)noPressed:(id)sender{[self buttonPressed:NO];}

//Feedback Delegate
- (void)FeedbackControllerContinuePressed:(UIViewController*)sender{
    [sender dismissViewControllerAnimated:NO completion:nil];
    [sender release];
    [self nextRound];
}
- (void)FeedbackControllerDoneLoading:(ControlFeedbackViewController *)sender{
    CGFloat ave = 0.0;
    for(int i = 0; i < [_speedRecords count];i++){
        ave = ave - [(NSNumber*)[_speedRecords objectAtIndex:i] floatValue];
    }
    ave = ave / [_speedRecords count];
    NSLog(@"Delegate called");
    [sender setupFieldsWithNumCorrect:_totalCorrect numIncorrect:_numWords averageTime:ave allowedTime:_timePerWord levelAchieved:[ControlGroupViewController getTaskLevel:_currentTask]];
    
    if([ControlGroupViewController checkHighScoreByLevel:[ControlGroupViewController getTaskLevel:_currentTask] andTask:_currentTask]){
        [sender recognizeHighScore];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self hideButtons];
    content.font = [UIFont systemFontOfSize:50];
    content.textAlignment = NSTextAlignmentCenter;
    
    [_wordTrack release];
    _wordTrack = nil;
    
    [_speedRecords release];
    _speedRecords = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
