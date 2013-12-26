//
//  SoundListCell.m
//  iSound
//
//  Created by Jumax.R on 13-11-11.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "SoundListCell.h"

@implementation SoundListCellOfLeft

- (void)setResult:(NSDictionary *)result {

    number.text = [result valueForKey:@"num"];
    timeB.text  = [result valueForKey:@"city"];
    timeA.text  = [NSString stringWithFormat:@"%@.%@", [result valueForKey:@"release_year"], [result valueForKey:@"release_month"]];
    headView.image = [[Downloader downloader] loadingWithURL:[result valueForKey:@"image_path"]
                                                       index:0
                                                    delegate:self
                                                     cacheTo:Document];

    CGFloat width  = [timeB.text sizeWithFont:timeB.font constrainedToSize:CGSizeMake(MAXFLOAT, 20)].width + 1;
    CGRect frame   = timeB.frame;
    frame.size     = CGSizeMake(width, 20);
    timeB.frame    = frame;
    UIImage *image = cityView.image;
    cityView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 17.5, 20, 25)];
    cityView.frame = CGRectMake(cityView.frame.origin.x, cityView.frame.origin.y, 40 + width, 20);
    
}

- (void)downloaderDidFinish:(Downloader *)downloader object:(UIImage *)object {

    headView.image = object;
}

@end

@implementation SoundListCellOfRight

- (void)setResult:(NSDictionary *)result {
    
    number.text = [result valueForKey:@"num"];
    timeB.text  = [result valueForKey:@"city"];
    timeA.text  = [NSString stringWithFormat:@"%@.%@", [result valueForKey:@"release_year"], [result valueForKey:@"release_month"]];
    headView.image = [[Downloader downloader] loadingWithURL:[result valueForKey:@"image_path"]
                                                       index:0
                                                    delegate:self
                                                     cacheTo:Document];
    
    CGFloat width  = [timeB.text sizeWithFont:timeB.font constrainedToSize:CGSizeMake(MAXFLOAT, 20)].width + 1;
    CGRect frame   = timeB.frame;
    frame.size     = CGSizeMake(width, 20);
    UIImage *image = cityView.image;
    cityView.image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 17.5, 20, 25)];
    cityView.frame = CGRectMake(148 - (40 + width), cityView.frame.origin.y, 40 + width, 20);
    frame.origin   = CGPointMake(cityView.frame.origin.x + 25, frame.origin.y);
    timeB.frame    = frame;
}

- (void)downloaderDidFinish:(Downloader *)downloader object:(UIImage *)object {
    
    headView.image = object;
}

@end
