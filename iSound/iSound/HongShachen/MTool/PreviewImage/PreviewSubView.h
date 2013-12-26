//
//  PreviewSubView.h
//  LearnTink
//
//  Created by Jason_Li on 13-5-10.
//  Copyright (c) 2013年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewSubView : UIScrollView<UIScrollViewDelegate>
{
    UIImageView *contentView;
}

@property (nonatomic, copy) UIImage *image;

@end
