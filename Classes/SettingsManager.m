//
//  SettingsManager.m
//  Foraging
//
//  Created by Thomas Deegan on 7/7/13.
//
//

#import "SettingsManager.h"

@implementation SettingsManager

+ (NSObject*) getObjectWithKey:(NSString*)key orWriteAndReturn:(NSObject*)defaultValue{
    NSObject *presentValue = (NSObject*)[[NSUserDefaults standardUserDefaults] objectForKey:key];
    if(presentValue ==  nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:defaultValue forKey:key];
        presentValue = defaultValue;
        NSLog(@"Using default value!");
    }
    return presentValue;
}
+ (NSObject*) getObjectWithKey:(NSString*)key{
    NSObject *presentValue = (NSObject*)[[NSUserDefaults standardUserDefaults] objectForKey:key];
    if(presentValue ==  nil)
    {
        [NSException raise:@"NO USER DEFAULT VALUE" format:@"NO USER DEFAULT VALUE"];
    }
    return presentValue;
}
+ (void) setObject:(NSObject*)value withKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
}



+ (void)setInteger:(NSInteger)value withKey:(NSString*)key{
    NSNumber* number = [NSNumber numberWithInt:value];
    [SettingsManager setObject:number withKey:key];
}
+ (NSInteger)getIntegerWithKey:(NSString*)key{
    NSNumber* number = (NSNumber*)[SettingsManager getObjectWithKey:key];
    return [number integerValue];
}
+ (NSInteger)getIntegerWithKey:(NSString*)key orWriteAndReturn:(int)defaultValue{
    NSNumber* defaultNumber = [NSNumber numberWithInt:defaultValue];
    NSNumber* number = (NSNumber*)[SettingsManager getObjectWithKey:key orWriteAndReturn:defaultNumber];
    return [number integerValue];
}

+ (void)setFloat:(CGFloat)value withKey:(NSString*)key{
    NSNumber* number = [NSNumber numberWithFloat:value];
    [SettingsManager setObject:number withKey:key];
}
+ (CGFloat)getFloatWithKey:(NSString*)key{
    NSNumber* number = (NSNumber*)[SettingsManager getObjectWithKey:key];
    return [number floatValue];
}
+ (CGFloat)getFloatWithKey:(NSString*)key orWriteAndReturn:(CGFloat)defaultValue{
    NSNumber* defaultNumber = [NSNumber numberWithFloat:defaultValue];
    NSNumber* number = (NSNumber*)[SettingsManager getObjectWithKey:key orWriteAndReturn:defaultNumber];
    return [number floatValue];
}

+ (void)setString:(NSString*)value withKey:(NSString*)key{
    [SettingsManager setObject:value withKey:key];
}
+ (NSString*)getStringWithKey:(NSString*)key{
    return (NSString*)[SettingsManager getObjectWithKey:key];
}
+ (NSString*)getStringWithKey:(NSString*)key orWriteAndReturn:(NSString*)defaultValue{
    return (NSString*)[SettingsManager getObjectWithKey:key orWriteAndReturn:defaultValue];
}

+ (void) syncronize{
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
