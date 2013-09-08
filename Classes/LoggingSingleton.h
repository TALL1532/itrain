//
//  LoggingSingleton.h
//  Memory Training
//
//  Created by Thomas Deegan on 2/10/13.
//
//

#import <Foundation/Foundation.h>
#import "AdminScreenVC.h"

#define CONTROL_HEADER @"name, task, session number, date, trial, block, item presented, correct choice, category, reaction time, span level, user acc \n"

@interface LoggingSingleton : NSObject
{}
@property (nonatomic, retain) NSString *recordsStringWriteBuffer;
@property (nonatomic, retain) NSString *loggingStringWriteBuffer;
@property (nonatomic, retain) NSString *currentCategory; //for storing current state
@property (nonatomic, retain) NSMutableArray *timeAverages;
@property (nonatomic, retain) NSNumber *correctTask;
@property (nonatomic, retain) NSNumber *correctMemory;
@property (nonatomic) NSInteger currentTrial;
+ (LoggingSingleton *)sharedSingleton;
- (void)storeTrialDataWithName:(NSString*)name task:(NSString*)task sessionNumber:(NSInteger)sessionNum date:(NSString*)date trial:(NSInteger)trialNum taskAccuracy:(CGFloat)taskAccuracy averageReactionTime:(NSInteger)reactionTime memoryAccuracy:(CGFloat)memoryAccuracy andSpanLevel:(NSInteger)spanLevel;

- (void)storeControlDataWithName:(NSString*)name
                            task:(NSString*)task
                   sessionNumber:(NSInteger)sessionNum
                            date:(NSString*)date
                           trial:(NSInteger)trialNum
                           block:(NSInteger)block
                   itemPresented:(NSString*)itemPresented
                             cat:(NSString*)currentCategory
                      inCategory:(BOOL)isInCat
                      wasCorrect:(int)acc
                    reactionTime:(NSInteger)reactionTime
                    andSpanLevel:(NSInteger)spanLevel;

- (void)writeBufferToFile;

+ (NSInteger)getSessionNumber;
+ (NSString*)getSubjectName;

//Used for recovery of app state if there is a crash or the user accidentally exits.
+ (void)setRecoveryTime:(NSDate*)date;
+ (void)setRecoverySection:(NSNumber*)date;
+ (void)setRecoverySections:(NSMutableArray*)date;
+ (void)setRecoverySectionTimeLeft:(NSNumber*)time;
+ (void)setRecoveryValidExit:(BOOL)validExit;

+ (NSDate*)getRecoveryTime;
+ (NSString*)getRecoverySection;
+ (NSMutableArray*)getRecoverySections;
+ (NSNumber*)getRecoverySectionTimeLeft;

+ (BOOL)getRecoveryValidExit;

@end
