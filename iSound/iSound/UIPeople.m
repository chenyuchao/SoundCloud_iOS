//
//  UIPeople.m
//  iSound
//
//  Created by Jumax.R on 13-11-16.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "UIPeople.h"

@interface UIPeople ()

@end

@implementation UIPeople

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.mainlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    static NSString *identifier = @"Cell";
    
    UIPeopleCell *cell = (UIPeopleCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UIPeopleCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:identifier];
    }
    
    NSMutableDictionary *object = [self.mainlist objectAtIndex:row];
    cell.result = object;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

@implementation UIPeopleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = CLEARCOLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 200, 15)];
        nameLabel.font = [UIFont boldSystemFontOfSize:13];
        [self addSubview:nameLabel];
        
        fansLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 200, 15)];
        fansLabel.font = [Custom systemFont:11];
        fansLabel.textColor = ARGB(112, 112, 112, 1.0);
        [self addSubview:fansLabel];
        
        headView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6.5, 57, 57)];
        [self addSubview:headView];
        
        headBack = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6.5, 57, 57)];
        headBack.image = [UIImage imageNamed:@"zhezhao"];
        [self addSubview:headBack];
        
        followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [followBtn setImage:[UIImage imageNamed:@"addFollow"] forState:UIControlStateNormal];
        [followBtn setImage:[UIImage imageNamed:@"following"] forState:UIControlStateSelected];
        [followBtn setFrame:CGRectMake(0, 0, 40, 40)];
        [followBtn addTarget:self action:@selector(addFollow:) forControlEvents:UIControlEventTouchUpInside];
        self.accessoryView = followBtn;
    }
    return self;
}

- (void)setResult:(NSMutableDictionary *)value {
    
//    if (value != result)
    {
        result = value;
        UserInfo *info = [UserInfo standardUserInfo];
        
        if ([[result valueForKey:@"follow"] isKindOfClass: [NSNull class]])
            [result setObject:@"0" forKey:@"follow"];
        
        if ([info.user_id isEqualToString:[result valueForKey:@"user_id"]])
            followBtn.hidden = YES;
        else
            followBtn.hidden = NO;
        
        followBtn.selected = [[result valueForKey:@"follow"] boolValue];
        nameLabel.text = [result valueForKey:@"nickname"];
        fansLabel.text = [NSString stringWithFormat:@"声音 %@   粉丝 %@",
                          [result valueForKey:@"voice_count"],
                          [result valueForKey:@"follower_count"]];
        headView.image = nil;
        headView.image = [[Downloader downloader] loadingWithURL:[result valueForKey:@"avatar"]
                                                           index:0
                                                        delegate:self
                                                         cacheTo:Document];
    }
}

- (void)downloaderDidFinish:(Downloader *)downloader object:(UIImage *)object {
    
    headView.image = object;
}

- (void)addFollow:(UIButton *)sender {
    
    UserInfo *info = [UserInfo standardUserInfo];
    
    if (sender.selected == NO)
    {
        [result setObject:@"1" forKey:@"follow"];
        [[Request request] addFollow:info.user_id
                            targetId:[result valueForKey:@"user_id"]
                            delegate:self];
    }
    else
    {
        [result setObject:@"0" forKey:@"follow"];
        [[Request request] cancelFollow:info.user_id
                               targetId:[result valueForKey:@"user_id"]
                               delegate:self];
    }
}

- (void)downloadDidFinish:(Request *)request withResult:(id)results {
    
    if ([[results valueForKey:@"code"] intValue] == 200)
    {
        followBtn.selected = !followBtn.selected;
    }
}

@end

@implementation FansCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = CLEARCOLOR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        nameLabel.frame = CGRectMake(80, 10, 200, 15);
        fansLabel.frame = CGRectMake(80, 50, 200, 15);
        
        signLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 30, 200, 15)];
        signLabel.font = [Custom systemFont:13];
        [self addSubview:signLabel];
    }
    return self;
}

- (void)setResult:(NSMutableDictionary *)value {
    
//    if (value != result)
    {
        result = value;
        UserInfo *info = [UserInfo standardUserInfo];
        if ([[result valueForKey:@"follow_state"] isKindOfClass: [NSNull class]])
            [result setObject:@"0" forKey:@"follow_state"];
        
        if ([info.user_id isEqualToString:[result valueForKey:@"user_id"]])
            followBtn.hidden = YES;
        else
            followBtn.hidden = NO;
        
        followBtn.selected = [[result valueForKey:@"follow_state"] boolValue];
        nameLabel.text = [result valueForKey:@"nickname"];
        signLabel.text = [result valueForKey:@"profile"];
        fansLabel.text = [NSString stringWithFormat:@"声音 %@   粉丝 %@",
                          [result valueForKey:@"voice_count"],
                          [result valueForKey:@"follower_count"]];
        headView.image = nil;
        headView.image = [[Downloader downloader] loadingWithURL:[result valueForKey:@"avatar"]
                                                           index:0
                                                        delegate:self
                                                         cacheTo:Document];
    }
}

- (void)addFollow:(UIButton *)sender {
    
    UserInfo *info = [UserInfo standardUserInfo];
    
    if (sender.selected == NO)
    {
        [result setObject:@"1" forKey:@"follow_state"];
        [[Request request] addFollow:info.user_id
                            targetId:[result valueForKey:@"user_id"]
                            delegate:self];
    }
    else
    {
        [result setObject:@"0" forKey:@"follow_state"];
        [[Request request] cancelFollow:info.user_id
                               targetId:[result valueForKey:@"user_id"]
                               delegate:self];
    }
}

@end

@implementation GMCell

- (void)setResult:(NSMutableDictionary *)value {
    
//    if (value != result)
    {
        result = value;
        UserInfo *info = [UserInfo standardUserInfo];
        if ([[result valueForKey:@"follow_state"] isKindOfClass:[NSNull class]])
            [result setObject:@"0" forKey:@"follow_state"];
        
        if ([info.user_id isEqualToString:[result valueForKey:@"user_id"]])
            followBtn.hidden = YES;
        else
            followBtn.hidden = NO;
        followBtn.selected = [[result valueForKey:@"follow_state"] boolValue];
        nameLabel.text = [result valueForKey:@"nickname"];
        signLabel.text = [result valueForKey:@"profile"];
        fansLabel.text = [NSString stringWithFormat:@"声音 %@   粉丝 %@",
                          [result valueForKey:@"voice_count"],
                          [result valueForKey:@"follower_count"]];
        headView.image = nil;
        headView.image = [[Downloader downloader] loadingWithURL:[result valueForKey:@"avatar"]
                                                           index:0
                                                        delegate:self
                                                         cacheTo:Document];
    }
}

@end

@implementation AddMemberCell

- (void)addFollow:(UIButton *)sender {
    
    if (sender.selected) return;
    
    [[Request request:100] inviteUserToGroup:[[UserInfo standardUserInfo] user_id]
                                     groupId:self.groupId
                                    inviteId:[result valueForKey:@"user_id"]
                                    delegate:self];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)results {
    
    if ([[results valueForKey:@"code"] intValue] == 200)
    {
        followBtn.selected = YES;
        followBtn.userInteractionEnabled = NO;
        [result setObject:@"1" forKey:@"GZ_State"];
        [Custom messageWithString:@"发送邀请成功，请等待对方答复"];
    }
}

- (void)setResult:(NSMutableDictionary *)value {
    
//    if (value != result)
    {
        result = value;
        if ([[result valueForKey:@"follow_state"] isKindOfClass: [NSNull class]])
            [result setObject:@"0" forKey:@"follow_state"];
        
        followBtn.selected = [[result valueForKey:@"follow_state"] boolValue];
        nameLabel.text = [result valueForKey:@"nickname"];
        signLabel.text = [result valueForKey:@"profile"];
        fansLabel.text = [NSString stringWithFormat:@"声音 %@   粉丝 %@",
                          [result valueForKey:@"voice_count"],
                          [result valueForKey:@"follower_count"]];
        headView.image = nil;
        headView.image = [[Downloader downloader] loadingWithURL:[result valueForKey:@"avatar"]
                                                           index:0
                                                        delegate:self
                                                         cacheTo:Document];
    }
}

@end
