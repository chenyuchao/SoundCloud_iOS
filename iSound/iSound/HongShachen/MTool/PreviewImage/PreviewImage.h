//
//  PreviewImage.h
//  LearnTink
//
//  Created by Jason_Li on 13-5-10.
//  Copyright (c) 2013年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreviewSubView.h"

@class PreviewImage;

@protocol PreviewImageDelegate <NSObject>

- (void)imageScrollViewTouchUpInside:(PreviewImage *)imageScrollView;
- (void)imageDidScrolling:(PreviewImage *)imageScrollView;
@end

@interface PreviewImage : UIScrollView<UIScrollViewDelegate>
{
    NSMutableArray *subviewArray;
}

@property (nonatomic, assign) id <PreviewImageDelegate> pDelegate;
@property (nonatomic, retain) NSMutableArray *imagesArray;

- (void)addImage:(UIImage *)addImage;
- (void)removeImageAtIndex:(NSUInteger)index;
- (void)removeAllImages;
- (void)insertImage:(UIImage *)image atIndex:(NSUInteger)index;
- (void)exchangeImageAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;

- (void)showAtIndex:(NSInteger)index animated:(BOOL)animated;
@end
