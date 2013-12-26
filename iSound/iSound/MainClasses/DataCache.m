//
//  DataCache.m
//  OlisEfficacy
//
//  Created by  Jumax.R on 13-4-7.
//  Copyright (c) 2013年  Jumax.R. All rights reserved.
//

#import "DataCache.h"

static NSMutableDictionary *cacheDictionary = nil;

@implementation DataCache

+ (void)saveData:(id)object forKey:(NSString *)key {

    if (!cacheDictionary)
    {
        cacheDictionary = [[NSMutableDictionary alloc] init];
    }
    [cacheDictionary setObject:object forKey:key];
}

+ (id)readDataForKey:(NSString *)key {

    if (!cacheDictionary)
    {
        cacheDictionary = [[NSMutableDictionary alloc] init];
    }
    if (cacheDictionary.allKeys.count == 0 || ![cacheDictionary objectForKey:key])
    {
        NSLog(@"No Cache Data !");
        return nil;
    }
    return [cacheDictionary objectForKey:key];
}

+ (void)removeObject:(NSString *)key
{
    if (!cacheDictionary)
    {
        cacheDictionary = [[NSMutableDictionary alloc] init];
    }
    [cacheDictionary removeObjectForKey:key];
}

+ (void)deleteAllObject
{
    if (!cacheDictionary)
    {
        cacheDictionary = [[NSMutableDictionary alloc] init];
    }
    [cacheDictionary removeAllObjects];
}

@end

/*
@implementation UserDescription

static UserDescription *description = nil;

+ (UserDescription *)description {

    if (!description)
    {
        description = [[self alloc] init];
    }
    return description;
}

- (id)init {

    if (self = [super init])
    {
        [self readData];
    }
    return self;
}

- (void)destroy {
    
    self.platform = PlatformNull;
    self.uid      = nil;
    self.name     = nil;
    self.header   = nil;
    [self saveData];
}

- (void)readData {

    NSDictionary *result = [[ConnectSql connect] readUserData];
    if (result)
    {
        self.platform = [[result objectForKey:@"platfrom"] intValue];
        if (![[result objectForKey:@"uid"] isEqualToString:@"(null)"])
            self.uid    = [result objectForKey:@"uid"];
        if (![[result objectForKey:@"name"] isEqualToString:@"(null)"])
            self.name   = [result objectForKey:@"name"];
        if (![[result objectForKey:@"header"] isEqualToString:@"(null)"])
            self.header = [result objectForKey:@"header"];
    }
}

- (void)saveData {

    if ([[ConnectSql connect] saveUserData:_platform uid:_uid uname:_name header:_header] == NO)
    {
        NSLog(@"save UserDescription Did Fail!");
    }
}

- (void)dealloc {

    [_uid    release];
    [_name   release];
    [_header release];
    [super   dealloc];
}

@end
*/