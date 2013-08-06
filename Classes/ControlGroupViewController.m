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
-(NSMutableArray*)generateContentFor:(NSString*)task{
    NSMutableArray* truthArray = [[NSMutableArray alloc] init];
    for(int i = 0; i < _numWords; i++){
        [truthArray addObject:[NSNumber numberWithBool: arc4random()%2 ? YES : NO]];
    }
    _inCategroyTrack = [ControlGroupViewController shuffle:truthArray];
    
    
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
        return wordsArray;
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
        return wordsArray;
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
        return sentanceArray;
    }
    else{
        [NSException raise:NSInvalidArgumentException format:@"task must be one of the three"];
    }
    return nil;
}
-(void)startTask:(NSString*)task{
    _numWords = 5;
    _currentTask = task;
    categoryLabel.text = @"";


    _timeForTask = [(NSNumber*)[[NSUserDefaults standardUserDefaults] valueForKey:TASK_TIME] floatValue] * 60;
    _startTime = [[NSDate date] retain];
    
    [self nextRound];
}
- (void)nextRound {
    
    if( [[_startTime dateByAddingTimeInterval:_timeForTask] timeIntervalSinceNow] < 0){
        UIAlertView* done = [[UIAlertView alloc] initWithTitle:@"Task Complete!" message:@"press okay to continue"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [done show];
        [done release];
    }
    else{
        _currentWord = 0;
        _hasPressedButton = NO;
        [_speedRecords release];
        _speedRecords = nil;
        _speedRecords = [[NSMutableArray alloc] init];
        [self showButtons];
        _wordTrack = [self generateContentFor:_currentTask];
        
        if([_currentTask isEqualToString:category]){
            _timePerWord = [(NSNumber*)[[NSUserDefaults standardUserDefaults] valueForKey:@"k_categoryPresentationTime"] floatValue];
        }
        else if([_currentTask isEqualToString:decision]){
            _timePerWord = [(NSNumber*)[[NSUserDefaults standardUserDefaults] valueForKey:@"k_decisionWordTime"] floatValue];
        }
        else if([_currentTask isEqualToString:sentence]){
            _timePerWord = [(NSNumber*)[[NSUserDefaults standardUserDefaults] valueForKey:@"k_sentencePresentationTime"] floatValue];
        }
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
    countDown.frame = CGRectMake(0, 0, self.view.frame.size.width, 20);
    [UIView animateWithDuration:time/1000 animations:^{
        countDown.frame = CGRectMake(0, 0, 0, 20);
    }];
}
-(void)timerUp:(id)sender{
    [self nextWord];
}
-(void)showScoreScreen{

    ControlFeedbackViewController* feedback = [[ControlFeedbackViewController alloc] init];
    feedback.delegate = self;
    feedback.modalPresentationStyle = UIModalPresentationFormSheet;
    feedback.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:feedback animated:YES completion:nil];

    feedback.view.superview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    feedback.view.superview.bounds = CGRectMake(0, 0, 400, 500);
}
-(void)buttonPressed:(BOOL)wasTrue {
    if(_hasPressedButton) return;
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
    _hasPressedButton = YES;
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

- (IBAction)yesPressed:(id)sender{[self buttonPressed:YES];}
- (IBAction)noPressed:(id)sender{[self buttonPressed:NO];}


//ALERT View Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

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
    [sender setupFieldsWithNumCorrect:_totalCorrect numIncorrect:_numWords averageTime:ave andAllowedTime:_timePerWord];
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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
