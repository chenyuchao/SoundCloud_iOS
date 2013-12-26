//
//  PreViewController.m
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-5.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "PreViewController.h"

@interface PreViewController ()

@end

@implementation PreViewController
@synthesize showIndex;
@synthesize imageArray;
@synthesize pDelegate;
@synthesize shotImage;
@synthesize hiddenDeleteBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if (shotImage)
    {
        shotView.image = shotImage;
        
        CGFloat y = -20;
        
        if (IOS7)
        {
            y = 0;
        }
        
        shotView.frame = CGRectMake(0, y, shotImage.size.width, shotImage.size.height);
    }
    
    deleteBtn.hidden = hiddenDeleteBtn;
    
    preView = [[PreviewImage alloc] initWithFrame:[UIScreen mainScreen].bounds];
    preView.pDelegate = self;
    
    [self.view addSubview:preView];

    if (!IOS7)
    {
        CGRect frame    = titleView.frame;
        frame.origin.y  = -20;
        titleView.frame = frame;
    }
    
    for (NSInteger i = 0; i < [imageArray count]; i ++)
    {
        [preView addImage:[imageArray objectAtIndex:i]];
    }
    
    [preView showAtIndex:showIndex animated:NO];
    
    [self.view bringSubviewToFront:titleView];
    indexLabel.text = [NSString stringWithFormat:@"%i/%lu",showIndex + 1,(unsigned long)[imageArray count]];
    
    preView.alpha   = 0.0f;
    titleView.alpha = 0.0f;
    
    [UIView animateWithDuration:0.3 animations:^
    {
        preView.alpha = 1.0f;
        titleView.alpha = 1.0f;
    }completion:^(BOOL finished){
        shotView.hidden = YES;
    }];
}


#pragma mark - PreviewImageDelegate

- (void)imageScrollViewTouchUpInside:(PreviewImage *)imageScrollView
{
    [UIView animateWithDuration:0.3f animations:^
    {
        titleView.alpha = 1.0 - titleView.alpha;
    }];
    
    [self back];
}

- (void)imageDidScrolling:(PreviewImage *)imageScrollView
{
    showIndex = imageScrollView.contentOffset.x/imageScrollView.frame.size.width;
    indexLabel.text = [NSString stringWithFormat:@"%i/%lu",showIndex + 1,(unsigned long)[imageArray count]];
}

- (IBAction)back
{
    shotView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^
     {
//         self.view.alpha = 0.0f;
         preView.alpha = 0.0f;
         titleView.alpha = 0.0f;
     }completion:^(BOOL finished){
         
    [self dismissModalViewControllerAnimated:NO];
         
     }];

}

- (IBAction)delegeImage
{
    if ([preView.imagesArray count] == 0)
    {
        return;
    }
    
    if ([pDelegate respondsToSelector:@selector(preViewDeleteImageAtIndex:)])
    {
        [pDelegate preViewDeleteImageAtIndex:showIndex];
    }
    
    [preView removeImageAtIndex:showIndex];
    
    if ([preView.imagesArray count] == 0)
    {
        indexLabel.text = @"0/0";
    }
    else
    {
        showIndex = preView.contentOffset.x/preView.frame.size.width;
        indexLabel.text = [NSString stringWithFormat:@"%i/%lu",showIndex + 1,(unsigned long)[imageArray count]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
