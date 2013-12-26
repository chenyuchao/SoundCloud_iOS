//
//  FirstSign.m
//  iSound
//
//  Created by Jumax.R on 13-11-3.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "FirstSign.h"
#import "Recommend.h"


@implementation FirstSign

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"基本信息设定";
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0, 0, 28, 28);
    [nextButton addTarget:self
                   action:@selector(nextButton)
         forControlEvents:UIControlEventTouchUpInside];
    [nextButton setImage:[UIImage imageNamed:@"nextBtn"]
                forState:UIControlStateNormal];
     self.navigationItem.rightBarButtonItem = CUSTOMVIEW(nextButton);
     self.navigationItem.hidesBackButton = YES;
    [self setHeadWithUrl:[[UserInfo standardUserInfo] head_image]];
    [[Request request:GetCityList] getCityListWithDelegate:self];
}

- (void)nextButton {
    
    if ([nameField.text isEqualToString:@""] || [signField.text isEqualToString:@""] ||
        !self.shi || !self.sex || !nameField.text || !signField.text || !headView.image)
    {
        [Custom messageWithString:@"信息不能留空"];
        return;
    }
    UserInfo *info = [UserInfo standardUserInfo];
    [[Request request:EditBaseInfo] editBaseInfo:info.user_id
                                        nickname:nameField.text
                                         profile:signField.text
                                             sex:[self.sex isEqualToString:@"女"] ? @"0" : @"1"
                                        province:self.sheng
                                            city:self.shi
                                        delegate:self];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result {
    
    if ([[result valueForKey:@"code"] integerValue] != 200)
    {
        [Custom messageWithString:[[result valueForKey:@"error"] valueForKey:@"msg"]];    
        return;
    }
    if (request.requestId == GetCityList)
    {
        self.cityList = [NSArray arrayWithArray:[[[result valueForKey:@"data"] valueForKey:@"areas"] valueForKey:@"prov"]];
        return;
    }
    if (request.requestId == EditBaseInfo)
    {
        [[UserInfo standardUserInfo] setIs_first:NO];
        Recommend *controller = [[Recommend alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
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

}

- (NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section {
    
    return 5;
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
}

@end
