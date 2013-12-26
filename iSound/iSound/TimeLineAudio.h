//
//  TimeLineAudio.h
//  iSound
//
//  Created by Jumax.R on 13-11-23.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "UIPeople.h"

@interface TimeLineAudio : Center_TableView <RequestDelegate> {

}

@property (nonatomic, copy)   NSString *userid;
@property (nonatomic, retain) NSArray  *mainlist;
@property (nonatomic, retain) NSDictionary *audioInfo;

@end
