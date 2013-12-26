//
//  CreateGroup.m
//  iSound
//
//  Created by Jumax.R on 13-11-16.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "CreateGroup.h"
#import "GroupRanking.h"

@interface CreateGroup ()

@end

@implementation CreateGroup

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"创建新的群组";
    UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    returnButton.frame = CGRectMake(0, 0, 28, 28);
    [returnButton addTarget:self
                     action:@selector(popViewController)
           forControlEvents:UIControlEventTouchUpInside];
    [returnButton setImage:[UIImage imageNamed:@"return"]
                  forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = CUSTOMVIEW(returnButton);
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightButton.frame = CGRectMake(0, 0, 28, 28);
    [self.rightButton addTarget:self
                         action:@selector(didFinish)
               forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setImage:[UIImage imageNamed:@"finishBtn"]
                      forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = CUSTOMVIEW(self.rightButton);
    nameField.text = nil;
}

- (void)didFinish {
    
    if ([nameField.text isEqualToString:@""] || !headView.image || [signField.text isEqualToString:@""])
    {
        [Custom messageWithString:@"信息不能留空"];
        return;
    }
    [super didFinish];
    
    [[Request request] addGroupList:[[UserInfo standardUserInfo] user_id]
                               name:nameField.text
                               sign:signField.text
                              image:[Custom scaleToSize:self.headImage targetSize:CGSizeMake(120, 120)]
                           delegate:self];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	[picker dismissModalViewControllerAnimated:YES];
    self.headImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    headView.image = self.headImage;
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result {
    
    if ([[result valueForKey:@"code"] integerValue] != 200)
    {
        return;
    }
    [self.delegate addGroupDidFinish];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downloadDidFail:(Request *)request WithError:(NSError *)error {
    
    [super downloadDidFail:request WithError:error];
}

- (NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 1)
    {
        cell.textLabel.text = @"名称";
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"简介";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
