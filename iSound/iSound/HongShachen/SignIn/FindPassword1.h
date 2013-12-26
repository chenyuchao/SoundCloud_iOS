//
//  FindPassword1.h
//  iSound
//
//  Created by Jumax.R on 13-12-11.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindPassword2.h"

@interface FindPassword1 : UIViewController<RequestDelegate>
{
    IBOutlet UITextField *yzmField;
}

@property (nonatomic, copy) NSString *user_name;

@end
