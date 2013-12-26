//
//  AppDelegate.h
//  iSound
//
//  Created by Jumax.R on 13-9-27.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  SignIn;

@interface AppDelegate : UIResponder <UIApplicationDelegate, RequestDelegate> {

    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SignIn *rootController;
@property (nonatomic, retain) NSMutableArray *messges;
@property (nonatomic, retain) NSString *msgPath;

@end
