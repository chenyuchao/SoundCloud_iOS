//
//  Acitivity.h
//  iSound
//
//  Created by Jumax.R on 13-9-28.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Activity : Center_TableView <UITableViewDelegate, UITableViewDataSource, RequestDelegate> {

}

@property (nonatomic, retain) NSArray *mainlist;
@property (nonatomic, retain) NSString *msgPath;

@end
