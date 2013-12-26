//
//  CreatePlayerList.h
//  iSound
//
//  Created by 郭子健 on 13-11-13.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "UserDescription.h"
#import "UIAddDescription.h"

@protocol CreatePlayerListDelegate <NSObject>

- (void)addPlayerListDidFinish;

@end

@interface CreatePlayerList : UIAddDescription {

    
}

@property (nonatomic, retain) UIImage *headImage;
@property (nonatomic, assign) id <CreatePlayerListDelegate> delegate;

@end
