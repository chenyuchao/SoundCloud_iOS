//
//  AddComment.h
//  iSound
//
//  Created by MaoHeng Zhang on 13-11-15.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddComment : UIViewController<RequestDelegate>
{
    IBOutlet UITextView *textView;
}

@property (nonatomic, copy) NSString *voiceId;

@end
