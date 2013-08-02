//
//  SettingsManager.h
//  Foraging
//
//  Created by Thomas Deegan on 7/7/13.
//
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject

+ (NSObject*) getObjectWithKey:(NSString*)key orWriteAndReturn:(NSObject*)defaultValue;
+ (NSObject*) getObjectWithKey:(NSString*)key;
+ (void) setObject:(NSObject*)value withKey:(NSString*)key;

+ (void)setInteger:(NSInteger)value withKey:(NSString*)key;
+ (NSInteger)getIntegerWithKey:(NSString*)key;
+ (NSInteger)getIntegerWithKey:(NSString*)key orWriteAndReturn:(int)defaultValue;

+ (void)setFloat:(CGFloat)value withKey:(NSString*)key;
+ (CGFloat)getFloatWithKey:(NSString*)key;
+ (CGFloat)getFloatWithKey:(NSString*)key orWriteAndReturn:(CGFloat)defaultValue;

+ (void)setString:(NSString*)value withKey:(NSString*)key;
+ (NSString*)getStringWithKey:(NSString*)key;
+ (NSString*)getStringWithKey:(NSString*)key orWriteAndReturn:(NSString*)defaultValue;

+ (void) syncronize;

@end
