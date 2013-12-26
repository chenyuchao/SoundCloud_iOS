//
//  PreViewController.h
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-5.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PreviewImage.h"

@protocol PreViewControllerDelegate <NSObject>

@optional
- (void)preViewDeleteImageAtIndex:(NSInteger)deleteIndex;

@end

@interface PreViewController : UIViewController<PreviewImageDelegate>
{
    IBOutlet UILabel *indexLabel;
    IBOutlet UIView  *titleView;
    IBOutlet UIImageView *shotView;
    IBOutlet UIButton *deleteBtn;
    
    PreviewImage *preView;
}

@property (nonatomic, assign) id <PreViewControllerDelegate> pDelegate;

@property (nonatomic) BOOL hiddenDeleteBtn;

@property (nonatomic, retain) NSMutableArray *imageArray;
@property (nonatomic) NSInteger showIndex;
@property (nonatomic, copy) UIImage *shotImage;

@end
