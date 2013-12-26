//
//  SelectedCity.h
//  iSound
//
//  Created by Jumax.R on 13-11-10.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserCenter_Super.h"

@protocol InfoSelectorDelegate <NSObject>

- (void)didSeletedCity:(NSDictionary *)info;
- (void)didSeletedSex:(NSString *)sex;

@end

@interface InfoSelector : Center_TableView {

    
}

@property (nonatomic, assign) id <InfoSelectorDelegate> delegate;

@property (nonatomic, retain) NSArray *mainlist;
@property (nonatomic, retain) NSString *stringA;
@property (nonatomic, retain) NSString *stringB;

@end
