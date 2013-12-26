//
//  PlayerList.m
//  iSound
//
//  Created by Jumax.R on 13-11-11.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "PlayerList.h"
#import "CreatePlayerList.h"
#import "PlayerListContent.h"

@interface PlayerList ()

@end

@implementation PlayerList


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"播放列表";
    lastElementTitle = @"创建新的列表";
    [[Request request] voiceClassList:self.userid delegate:self];
}

- (void)addPlayerListDidFinish {

    [[Request request] voiceClassList:self.userid delegate:self];
}

- (void)touchUpInsideAtTouchView:(JRTouchView *)touchView {

    if (self.comfromCenter == NO && self.mainlist.count != touchView.tag)
    {
        if ([self.delegate respondsToSelector:@selector(didSelectedPlayerList:name:)])
        {
            NSDictionary *object = [self.mainlist objectAtIndex:touchView.tag];
            [self.delegate didSelectedPlayerList:[object valueForKey:@"playlist_id"]
                                            name:[object valueForKey:@"playlist_name"]];
        }
//        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (self.mainlist.count == touchView.tag)
    {
        CreatePlayerList *list = [[CreatePlayerList alloc] init];
        list.delegate = self;
        [self.navigationController pushViewController:list animated:YES];
    }
    else
    {
        NSDictionary *object = [self.mainlist objectAtIndex:touchView.tag];
        PlayerListContent *content = [[PlayerListContent alloc] init];
        content.listId = [object valueForKey:@"playlist_id"];
        content.title = [object valueForKey:@"playlist_name"];
        [self.navigationController pushViewController:content animated:YES];
    }
}

- (void)longTouchUpInsideAtTouchView:(JRTouchView *)touchView {

    if (self.comfromCenter == NO) return;
        
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"删除列表"
                                              otherButtonTitles:nil];
    sheet.tag = touchView.tag;
    [sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [sheet showInView:self.tabBarController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0)
    {
        NSDictionary *object = [self.mainlist objectAtIndex:actionSheet.tag];
        [[Request request:100] delAudioPlayerlist:self.userid
                                      playlist_id:[object valueForKey:@"playlist_id"]
                                         delegate:self];
    }
}

#pragma mark - RequestDelegate

- (void)downloadDidFinish:(Request *)request withResult:(id)result
{
    if ([[result valueForKey:@"code"] intValue] != 200)
    {
        NSLog(@"%@", result);
        return;
    }
    if (request.requestId == 0)
    {
        if ([[result valueForKey:@"data"] isKindOfClass:[NSArray class]])
        {
            self.mainlist = [result valueForKey:@"data"];
        }
        [self reloadContent:@"playlist_name" imagePath:@"image_path"];
    }
    else if (request.requestId == 100)
    {
        [[Request request] voiceClassList:self.userid delegate:self];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
