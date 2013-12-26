//
//  PreviewImage.m
//  LearnTink
//
//  Created by Jason_Li on 13-5-10.
//  Copyright (c) 2013年 admin. All rights reserved.
//

#import "PreviewImage.h"

#define PREVIEWTAG 1000

@implementation PreviewImage
@synthesize imagesArray;
@synthesize pDelegate;

//- (void)dealloc
//{
//    [imagesArray  release];
//    [subviewArray release];
//    [super dealloc];
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.pagingEnabled   = YES;
        self.backgroundColor = [UIColor blackColor];
        self.delegate        = self;
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator   = YES;
        
//        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
//        titleView.backgroundColor = [UIColor redColor];

        imagesArray  = [[NSMutableArray alloc] init];
        subviewArray = [[NSMutableArray alloc] init];
        
//        indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, 320, 40)];
//        indexLabel.textAlignment = NSTextAlignmentCenter;
//        indexLabel.backgroundColor = [UIColor blueColor];

//        [titleView addSubview:indexLabel];
        
//        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 24, 29, 29)];
//        [backBtn setImage:LoadImage(@"SoundSavedBack", @"png") forState:UIControlStateNormal];
//        [titleView addSubview:backBtn];
//        
//        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(262, 24, 29, 29)];
//        [deleteBtn addTarget:self
//                      action:@selector(deleteImage)
//            forControlEvents:UIControlEventTouchUpInside];
//        deleteBtn.backgroundColor = [UIColor greenColor];
//        [titleView addSubview:deleteBtn];
//        
//        [self addSubview:titleView];
    }
    
    return self;
}

- (void)deleteImage
{
    [self removeImageAtIndex:0];
}

- (void)addImage:(UIImage *)addImage
{
    CGSize size = self.frame.size;
    
    PreviewSubView *subview = [[PreviewSubView alloc] initWithFrame:self.bounds];
    subview.image           = addImage;
    subview.center          = CGPointMake(size.width/2 + imagesArray.count*size.width, size.height/2);
    
    subview.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(tapRecognizer:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [subview addGestureRecognizer:tapRecognizer];
    
    [self addSubview:subview];
    [imagesArray addObject:addImage];
    [subviewArray addObject:subview];
//    [subview release];
    
    self.contentSize = CGSizeMake(size.width*imagesArray.count, size.height);
}

- (void)tapRecognizer:(UITapGestureRecognizer *)Recognizer
{
    if ([pDelegate respondsToSelector:@selector(imageScrollViewTouchUpInside:)])
    {
        [pDelegate imageScrollViewTouchUpInside:self];
    }
}

- (void)insertImage:(UIImage *)image atIndex:(NSUInteger)index
{
    [self addImage:image];
    
    for (NSInteger i = index; i < [subviewArray count]; i ++)
    {
        [self exchangeImageAtIndex:i withObjectAtIndex:[subviewArray count] - 1];
    }
}

- (void)exchangeImageAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2
{
    [imagesArray  exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];

    PreviewSubView *fromeSubView = [subviewArray objectAtIndex:idx1];
    PreviewSubView *toSubView    = [subviewArray objectAtIndex:idx2];

    CGRect frame       = toSubView.frame;
    toSubView.frame    = fromeSubView.frame;
    fromeSubView.frame = frame;
    
    [subviewArray exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)removeImageAtIndex:(NSUInteger)index
{
    if (index > imagesArray.count - 1)
    {
        return;
    }
    
    CGSize size = self.frame.size;
    
    PreviewSubView *subView = [subviewArray objectAtIndex:index];
    [subView removeFromSuperview];
    [imagesArray  removeObjectAtIndex:index];
    [subviewArray removeObjectAtIndex:index];
    
    for (NSInteger i = index; i < [subviewArray count]; i ++)
    {
        PreviewSubView *subView = [subviewArray objectAtIndex:i];
        subView.center =  CGPointMake(size.width/2 + i*size.width, size.height/2);
    }
    
    self.contentSize = CGSizeMake(size.width*imagesArray.count, size.height);
}

- (void)removeAllImages
{
    CGSize size = self.frame.size;
    
    [imagesArray removeAllObjects];
    
    [subviewArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [subviewArray removeAllObjects];
    
    self.contentSize = CGSizeMake(size.width*imagesArray.count, size.height);
}

- (void)showAtIndex:(NSInteger)index animated:(BOOL)animated
{
    CGSize size = self.frame.size;
    
    if (animated)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentOffset = CGPointMake(size.width*index, self.contentOffset.y);
        }];
    }
    else
    {
        self.contentOffset = CGPointMake(size.width*index, self.contentOffset.y);
    }
}

#pragma mark - delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([pDelegate respondsToSelector:@selector(imageDidScrolling:)])
    {
        [pDelegate imageDidScrolling:self];
    }
//    NSInteger pageIndex = scrollView.contentOffset.x/scrollView.frame.size.width;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex = scrollView.contentOffset.x/scrollView.frame.size.width;

    NSInteger left = pageIndex - 1;
    
    if (left >= 0)
    {
        PreviewSubView *subviewL = (PreviewSubView *)[subviewArray objectAtIndex:left];
        
        if (subviewL)
        {
            subviewL.zoomScale = subviewL.minimumZoomScale;
        }
    }
    
    NSInteger right = pageIndex + 1;
    
    if (right <= [subviewArray count] - 1)
    {
        PreviewSubView *subviewR = (PreviewSubView *)[subviewArray objectAtIndex:right];
        
        if (subviewR)
        {
            subviewR.zoomScale = subviewR.minimumZoomScale;
        }
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
