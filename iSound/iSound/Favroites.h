//
//  Favroites.h
//  iSound
//
//  Created by Jumax.R on 13-11-7.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Favroites : Center_TableView <RequestDelegate> {

}

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, retain) NSArray *mainlist;

@end
