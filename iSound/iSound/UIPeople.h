//
//  UIPeople.h
//  iSound
//
//  Created by Jumax.R on 13-11-16.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "UserCenter_Super.h"

@interface UIPeople : Center_TableView {

}

@property (nonatomic, retain) NSArray *mainlist;
@property (nonatomic, copy)   NSString *userid;

@end

@interface UIPeopleCell : UITableViewCell <RequestDelegate, DownloaderDelegate> {
    
    UIButton *followBtn;
    UIImageView *headView;
    UIImageView *headBack;
    UILabel *nameLabel;
    UILabel *fansLabel;
    
    NSMutableDictionary *result;
}

- (void)setResult:(NSMutableDictionary *)value;

@end


@interface FansCell : UIPeopleCell {
    
    UILabel *signLabel;
}

@end

@interface GMCell : FansCell

@end

@interface AddMemberCell : FansCell {

}

@property (nonatomic, copy) NSString *groupId;

@end