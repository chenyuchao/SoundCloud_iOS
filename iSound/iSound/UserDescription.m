//
//  UserDescription.m
//  iSound
//
//  Created by Jumax.R on 13-11-10.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "UserDescription.h"


@interface UserDescription ()

@end

@implementation UserDescription


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"详细资料";
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0, 0, 28, 28);
    [returnButton addTarget:self
                     action:@selector(popViewController)
           forControlEvents:UIControlEventTouchUpInside];
    [returnButton setImage:[UIImage imageNamed:@"return"]
                  forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = CUSTOMVIEW(returnButton);
    
    UserInfo *info = [UserInfo standardUserInfo];
    
    if (isMySelf)
    {
        signField.text = info.sign;
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightButton.frame = CGRectMake(0, 0, 28, 28);
        [self.rightButton addTarget:self
                             action:@selector(didFinish)
                   forControlEvents:UIControlEventTouchUpInside];
        [self.rightButton setImage:[UIImage imageNamed:@"finishBtn"]
                          forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = CUSTOMVIEW(self.rightButton);
    }
    else
    {
        nameField.text = @"";
        nameField.userInteractionEnabled = NO;
        signField.userInteractionEnabled = NO;
    }
    [self setHeadWithUrl:self.userhead];
    [[Request request:GetCityList] getCityListWithDelegate:self];
    [[Request request:GetUserDescription] getUserDescription:self.userid delegate:self];
}

- (void)didFinish {
    
    if ([nameField.text isEqualToString:@""] || [signField.text isEqualToString:@""] || !self.sex || !self.shi)
    {
        [Custom messageWithString:@"信息不能留空"];
        return;
    }
    [super didFinish];
    
    if ([self.sheng isEqualToString:@""]) self.sheng = self.shi;
    [[Request request:UpdateBaseInfo] updateBaseInfo:self.userid
                                            nickname:nameField.text
                                             profile:signField.text
                                                 sex:[self.sex isEqualToString:@"女"] ? @"0" : @"1"
                                            province:self.sheng
                                                city:self.shi
                                            delegate:self];
}

- (void)tableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!isMySelf) return;
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result {
    
    if ([[result valueForKey:@"code"] integerValue] != 200)
    {
        [Custom messageWithString:[[result valueForKey:@"error"] valueForKey:@"msg"]];
        self.navigationItem.rightBarButtonItem = CUSTOMVIEW(self.rightButton);
        return;
    }
    
    if (request.requestId == GetCityList)
    {
        self.cityList = [NSArray arrayWithArray:[[[result valueForKey:@"data"]
                                                  valueForKey:@"areas"]
                                                 valueForKey:@"prov"]];
        return;
    }
    if (request.requestId == UpdateBaseInfo)
    {
        UserInfo *info = [UserInfo standardUserInfo];
        info.nickname = nameField.text;
        info.sign = signField.text;
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (request.requestId == GetUserDescription)
    {
        NSDictionary *object = [[result valueForKey:@"data"] valueForKey:@"user_info"];
        self.sex   = [[object valueForKey:@"sex"] intValue] == 1 ? @"男" : @"女";
        self.shi   = [object valueForKey:@"city"];
        self.sheng = [object valueForKey:@"province"];
        nameField.text = [object valueForKey:@"nickname"];
        signField.text = [object valueForKey:@"profile"];
        [tableView reloadData];
        return;
    }
    if (request.requestId == UpLoadHeader)
    {
        [self setHeadWithUrl:[[result valueForKey:@"data"] valueForKey:@"head_url"]];
        [[UserInfo standardUserInfo] setHead_image:[[result valueForKey:@"data"] valueForKey:@"head_url"]];
        return;
    }
}

- (void)downloadDidFail:(Request *)request WithError:(NSError *)error {

    [super downloadDidFail:request WithError:error];
}

#pragma mark UIImagePickerController Delegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	[picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    [[Request request:UpLoadHeader] uploadHeader:[[UserInfo standardUserInfo] user_id]
                                           image:[Custom scaleToSize:image targetSize:CGSizeMake(120, 120)]
                                        delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
