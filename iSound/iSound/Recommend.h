//
//  Recommend.h
//  iSound
//
//  Created by Jumax.R on 13-11-4.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPeople.h"

@interface Recommend : UIPeople <RequestDelegate> {
    
}

@property (nonatomic, retain) NSArray *mainlist;

@end