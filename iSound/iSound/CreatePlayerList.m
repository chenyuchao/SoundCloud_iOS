//
//  CreatePlayerList.m
//  iSound
//
//  Created by 郭子健 on 13-11-13.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "CreatePlayerList.h"

@interface CreatePlayerList ()

@end

@implementation CreatePlayerList


- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"创建播放列表";
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
    
    if ([nameField.text isEqualToString:@""] || !headView.image)
    {
        [Custom messageWithString:@"信息不能留空"];
        return;
    }
    [super didFinish];

    [[Request request] creatVoiceListWithTitle:nameField.text
                                         image:[Custom scaleToSize:self.headImage targetSize:CGSizeMake(120, 120)]
                                      delegate:self];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	
	[picker dismissModalViewControllerAnimated:YES];
    self.headImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    headView.image = self.headImage;
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result {
    
    [super downloadDidFinish:request withResult:result];
    [self.delegate addPlayerListDidFinish];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downloadDidFail:(Request *)request WithError:(NSError *)error {
    
    [super downloadDidFail:request WithError:error];
}

- (NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 1)
    {
        cell.textLabel.text = @"名称";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
