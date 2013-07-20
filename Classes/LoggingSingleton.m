//
//  LoggingSingleton.m
//  Memory Training
//
//  Created by Thomas Deegan on 2/10/13.
//
// This class will be used a way of tracking subject testing as well as outputing the correct data files.


#import "LoggingSingleton.h"

@implementation LoggingSingleton

+(LoggingSingleton *)sharedSingleton {
    static dispatch_once_t pred;
    static LoggingSingleton *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[LoggingSingleton alloc] init];
    });
    return sharedInstance;
}

- (void)storeTrialDataWithName:(NSString*)name task:(NSString*)task sessionNumber:(NSInteger)sessionNum date:(NSString*)date trial:(NSInteger)trialNum taskAccuracy:(CGFloat)taskAccuracy averageReactionTime:(NSInteger)reactionTime memoryAccuracy:(CGFloat)memoryAccuracy andSpanLevel:(NSInteger)spanLevel{
    if(taskAccuracy ==0){
        taskAccuracy = 0;
    }
    if(reactionTime ==0){
        double rt = 0;
        for(int i =0; i< [self.timeAverages count];i++){
            rt += [[self.timeAverages objectAtIndex:i] doubleValue];
        }
        reactionTime = rt / [self.timeAverages count] * -1000;
    }
    if(memoryAccuracy ==0){
        memoryAccuracy = 0;
    }
    if(spanLevel ==0){
        spanLevel = 0;
    }
    
    NSString* nextLine = [NSString stringWithFormat:@"%@,%@,%d,%@,%d,%f,%d,%f,%d \n",name,task,sessionNum, date,trialNum, taskAccuracy,reactionTime,memoryAccuracy, spanLevel];
    NSLog(@"%@",nextLine);
    self.stringWriteBuffer = [self.stringWriteBuffer stringByAppendingString:nextLine];
}

-(void)writeBufferToFile{
    NSLog(@"writing buffer to file: %@ \n",self.stringWriteBuffer);
    [self writeToEndOfFile:self.stringWriteBuffer withFilename:@"record.csv"];
    self.stringWriteBuffer = @"";
}
- (void)writeToEndOfFile:(NSString*)string withFilename:(NSString*)filename{
    if(string == nil || [string length] == 0) return;
    // NSFileHandle won't create the file for us, so we need to check to make sure it exists
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* path = [NSString stringWithFormat:@"%@/%@",[self applicationDocumentsDirectory],filename];
    NSLog(@"%@",path);
    if (![fileManager fileExistsAtPath:path]) {
        
        // the file doesn't exist yet, so we can just write out the text using the
        // NSString convenience method
        
        NSError *error = nil;
        BOOL success = [string writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (!success) {
            // handle the error
            NSLog(@"%@", error);
        }
    }
    else {
        
        // the file already exists, so we should append the text to the end
        
        // get a handle to the file
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        
        // move to the end of the file
        [fileHandle seekToEndOfFile];
        
        // convert the string to an NSData object
        NSData *textData = [string dataUsingEncoding:NSUTF8StringEncoding];
        
        // write the data to the end of the file
        [fileHandle writeData:textData];
        
        // clean up
        [fileHandle closeFile];
    }
}
- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}
//This number is reset when the subject is reset in the Admin Screen
+ (NSInteger)getSessionNumber{
    NSInteger toReturn = [[NSUserDefaults standardUserDefaults] integerForKey:@"k_sessionNumber"];
    return toReturn;
}
+ (NSString*)getSubjectName{
    NSString* toReturn = [[NSUserDefaults standardUserDefaults] stringForKey:@"k_subjectName"];
    if(toReturn == nil){
        [[NSUserDefaults standardUserDefaults] setObject:@"default_subject" forKey:@"k_subjectName"];
        toReturn = @"default_subject";
    }
    return toReturn;
}


+ (void)setRecoveryTime:(NSDate*)date{
    [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"k_recovery_timestamp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (void)setRecoverySection:(NSNumber*)section{
    [[NSUserDefaults standardUserDefaults] setObject:section forKey:@"k_recovery_section"];
}
+ (void)setRecoverySections:(NSMutableArray*)sectionsArray{
    [[NSUserDefaults standardUserDefaults] setObject:sectionsArray forKey:@"k_recovery_order"];
}
+ (void)setRecoverySectionTimeLeft:(NSNumber*)time{
    [[NSUserDefaults standardUserDefaults] setObject:time forKey:@"k_recovery_section_time_left"];
}
+ (void)setRecoveryValidExit:(BOOL)validExit{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:validExit] forKey:@"k_recovery_valid_exit"];
}

+ (NSDate*)getRecoveryTime{
    return  (NSDate*)[[NSUserDefaults standardUserDefaults] objectForKey:@"k_recovery_timestamp"];
}
+ (NSNumber*)getRecoverySection{
    return  (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"k_recovery_section"];
}
+ (NSMutableArray*)getRecoverySections{
    return [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"k_recovery_order"]];
}
+ (NSNumber*)getRecoverySectionTimeLeft{
    return  (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"k_recovery_section_time_left"];
}
+ (BOOL)getRecoveryValidExit{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"k_recovery_valid_exit"] boolValue];
}
@end
