//
//  SignIn.h
//  iSound
//
//  Created by MaoHeng Zhang on 13-10-24.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBaseController.h"
#import "SignUp.h"
#import "FindPassword1.h"

#define kFindPasswordTag 23982

@interface SignIn : MBaseController <UITabBarControllerDelegate>
{
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *psdField;
    NSInteger index;
    UIViewController *lastController;
    
    UIView *loadingView;
}

@property (strong, nonatomic) UITabBarController *tabBarController;

- (UITabBarController *)pushTabBarController;

@end
