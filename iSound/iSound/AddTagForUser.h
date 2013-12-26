//
//  AddTagForUser.h
//  iSound
//
//  Created by Jumax.R on 13-11-4.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTagForUser : UIViewController <RequestDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    IBOutlet UITableView *mainTableView;
    IBOutlet UIScrollView *headerScrollView;
    IBOutlet UIScrollView *mainScrollView;
}

@property (nonatomic, retain) NSArray *mainlist;
@property (nonatomic, retain) NSMutableArray *selectedTag;

@end


@interface TagButton : UIButton {
    
}

@property (nonatomic, retain) NSDictionary *element;

@end