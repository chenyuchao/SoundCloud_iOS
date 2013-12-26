//
//  ADLabelView.h
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-5.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "AddTagForUser.h"

@protocol ADLabelViewDelegate <NSObject>

- (void)backWithTags:(NSString *)tags names:(NSString *)names;

@end

@interface ADLabelView : AddTagForUser

@property (nonatomic, assign) id <ADLabelViewDelegate> aDelegate;

@end
