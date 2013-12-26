//
//  CreateGroup.h
//  iSound
//
//  Created by Jumax.R on 13-11-16.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "CreatePlayerList.h"

@protocol CreateGroupDelegate <NSObject>

- (void)addGroupDidFinish;

@end

@interface CreateGroup : UIAddDescription {

}

@property (nonatomic, assign) id <CreateGroupDelegate> delegate;
@property (nonatomic, retain) UIImage *headImage;

@end
