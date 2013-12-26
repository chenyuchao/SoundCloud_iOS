//
//  DataCache.h
//  OlisEfficacy
//
//  Created by  Jumax.R on 13-4-7.
//  Copyright (c) 2013年  Jumax.R. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCache : NSObject {

}

+ (void)saveData:(id)object forKey:(NSString *)key;
+ (id)readDataForKey:(NSString *)key;
+ (void)deleteAllObject;
+ (void)removeObject:(NSString *)key;

@end

/*
@interface UserDescription : NSObject {

    NSString *document;
}

@property (nonatomic, assign) Platform platform;
@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *header;

+ (UserDescription *)description;
- (void)destroy;
- (void)saveData;

@end
*/