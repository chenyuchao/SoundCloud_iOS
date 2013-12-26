//
//  JGGUI.m
//  iSound
//
//  Created by 郭子健 on 13-11-13.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "JGGUI.h"

@implementation JGGUI

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, ScreenHeight - 64)];
    [self.view addSubview:mainScrollView];
    UserInfo *info = [UserInfo standardUserInfo];
    isMySelf = [info.user_id isEqualToString:self.userid] || self.userid == nil;
}

- (void)reloadContent:(NSString *)title imagePath:(NSString *)path {
    
    CGFloat lastY = 0;
    GroupElement *element;
    
    [[mainScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int idx = isMySelf ? self.mainlist.count + 1 : self.mainlist.count;
    
    for (int i = 0; i < idx; i++)
    {
        lastY  = i / 3 * 106 + 5;
        element = [[GroupElement alloc] initWithFrame:CGRectMake((i % 3) * 106 + 3.5, lastY, 100, 100)];
        element.tag = i;
        element.delegate = self;
        [mainScrollView addSubview:element];
    
        if (i == self.mainlist.count)
        {
            if (isMySelf && !self.hideAddGroup)
            {
                element.highlightedView = nil;
                element.titleLabel.text = lastElementTitle;
                element.imageView.image = [UIImage imageNamed:@"addGroup"];
            }
            else
            {
                [element removeFromSuperview];
            }
        }
        else
        {
            NSString *object = [self.mainlist objectAtIndex:i];
            element.titleLabel.text = [object valueForKey:title];
            element.imageView.image = [[Downloader downloader] loadingWithURL:[object valueForKey:path]
                                                                        index:element.tag
                                                                     delegate:self
                                                                      cacheTo:Document];
        }
    }
    [mainScrollView setContentSize:CGSizeMake(0, lastY + 111)];
}

- (void)touchUpInsideAtTouchView:(JRTouchView *)touchView {

}

- (void)downloaderDidFinish:(Downloader *)downloader object:(UIImage *)object {
    
    GroupElement *element = (GroupElement *)[[mainScrollView subviews] objectAtIndex:downloader.idx];
    element.imageView.image = object;
}

@end

@implementation GroupElement

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame])
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, 5, 65, 65)];
        [self addSubview:_imageView];
        
        _highlightedView = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, 5, 65, 65)];
        _highlightedView.image = [UIImage imageNamed:@"zhezhao"];
        _highlightedView.highlightedImage = [UIImage imageNamed:@"zhezhao2"];
        [self addSubview:_highlightedView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 100, 15)];
        _titleLabel.font = [Custom systemFont:13];
        _titleLabel.textColor = ARGB(0, 49, 81, 1.0);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setImage:(NSString *)value {
    
    _imageView.image = [[Downloader downloader] loadingWithURL:value
                                                         index:0
                                                      delegate:self
                                                       cacheTo:Document];
}

- (void)downloaderDidFinish:(Downloader *)downloader object:(UIImage *)object {
    
    _imageView.image = object;
}

@end

@implementation FindElement

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame])
    {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor grayColor];
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 15, frame.size.width, 15)];
        _titleLabel.font = [Custom systemFont:13];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = ARGB(0, 0, 0, 0.3);
        [self addSubview:_titleLabel];
    }
    return self;
}

- (void)setImage:(NSString *)value {

    _imageView.image = [[Downloader downloader] loadingWithURL:value
                                                         index:0
                                                      delegate:self
                                                       cacheTo:Document];
}

- (void)downloaderDidFinish:(Downloader *)downloader object:(UIImage *)object {

    _imageView.image = object;
}

@end
