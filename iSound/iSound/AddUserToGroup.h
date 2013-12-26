//
//  AddUserToGroup.h
//  iSound
//
//  Created by Jumax.R on 13-11-16.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "UIPeople.h"

@interface AddUserToGroup : UIPeople <RequestDelegate> {

}

@property (nonatomic, copy) NSString *groupId;

@end
