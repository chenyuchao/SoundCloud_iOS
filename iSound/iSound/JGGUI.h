//
//  JGGUI.h
//  iSound
//
//  Created by 郭子健 on 13-11-13.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGGUI : Center_ViewController <DownloaderDelegate, RequestDelegate, JRTouchViewDelegate> {

    UIScrollView *mainScrollView;
    NSString *lastElementTitle;
    BOOL isMySelf;
}

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, strong) NSArray *mainlist;
@property (nonatomic, assign) BOOL hideAddGroup;
@property (nonatomic ,assign) BOOL comfromCenter;
@property (nonatomic, retain) NSString *selectedGroupId;

- (void)reloadContent:(NSString *)title imagePath:(NSString *)path;

@end

@interface GroupElement : JRTouchView <DownloaderDelegate> {
    
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *highlightedView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)setImage:(NSString *)value;

@end

@interface FindElement : JRTouchView <DownloaderDelegate> {
    
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)setImage:(NSString *)value;

@end