//
//  UIAddDescription.m
//  iSound
//
//  Created by Jumax.R on 13-11-13.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "UIAddDescription.h"
#import "AddTagForUser.h"


@interface UIAddDescription ()

@end

@implementation UIAddDescription

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    nameField  = [self textField];
    signField  = [self textField];
    tableView  = [self tableView];
    headView   = [self imageView];
    [self.view addSubview:tableView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        self.view.backgroundColor = ARGB(239, 239, 244, 1.0);
        [tableView setBackgroundView:nil];
    }
    UserInfo *info = [UserInfo standardUserInfo];
    nameField.text = [info nickname];
    isMySelf = [info.user_id isEqualToString:self.userid] || self.userid == nil;
    self.sex   = @"";
    self.sheng = @"";
    self.shi   = @"";
}

- (void)setHeadWithUrl:(NSString *)url {
    
    headView.image = [[Downloader downloader] loadingWithURL:url
                                                       index:0
                                                    delegate:self
                                                     cacheTo:Document];
}

- (void)didFinish {

    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activity.frame = CGRectMake(0, 0, 30, 30);
    [activity startAnimating];
    self.navigationItem.rightBarButtonItem = CUSTOMVIEW(activity);
}

- (void)popViewController {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downloaderDidFinish:(Downloader *)downloader object:(UIImage *)object {
    
    headView.image = object;
}

- (void)textFieldEditDidFinish {
    
    [nameField resignFirstResponder];
    [signField resignFirstResponder];
}

- (void)didSeletedSex:(NSString *)sex {
    
    self.sex = sex;
    [tableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result {
    
    if ([[result valueForKey:@"code"] integerValue] != 200)
    {
        self.navigationItem.rightBarButtonItem = CUSTOMVIEW(self.rightButton);
        return;
    }
}

- (void)downloadDidFail:(Request *)request WithError:(NSError *)error {
    
    [Custom messageWithString:@"出错啦，请稍后再试！"];
    self.navigationItem.rightBarButtonItem = CUSTOMVIEW(self.rightButton);
}

- (CGFloat)tableView:(UITableView *)tableview heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
    {
        return 70;
    }
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableview numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    static NSString *identifier = @"FirstSignCell";
    
    UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.font = [Custom systemFont:13];
        cell.textLabel.backgroundColor = CLEARCOLOR;
        cell.detailTextLabel.backgroundColor = CLEARCOLOR;
        
        if (!IOS7)
        {
            UIView *lineView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
            lineView.backgroundColor = [UIColor whiteColor];
            cell.backgroundView = lineView;
            
            lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 43.5, 305, 0.5)];
            lineView.backgroundColor = [UIColor grayColor];
            lineView.alpha = 0.4;
            lineView.tag = 100;
            [cell.contentView addSubview:lineView];
            
            lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5)];
            lineView.backgroundColor = [UIColor grayColor];
            lineView.alpha = 0.4;
            lineView.tag = 101;
            lineView.hidden = YES;
            [cell.contentView addSubview:lineView];
        }
    }
    if (!IOS7)
    {
        UIView *lineViewA = [cell.contentView viewWithTag:100];
        UIView *lineViewB = [cell.contentView viewWithTag:101];
        if (indexPath.row == 0)
        {
            lineViewA.frame = CGRectMake(15, 69.5, 305, 0.5);
            lineViewB.hidden = NO;
        }
        else if (indexPath.row == 4)
        {
            lineViewA.frame = CGRectMake(0, 43.5, 320, 0.5);
            lineViewB.hidden = YES;
        }
        else if (indexPath.row > 0 && indexPath.row < 4)
        {
            lineViewA.frame = CGRectMake(15, 43.5, 305, 0.5);
            lineViewB.hidden = YES;
        }
    }
    switch (row)
    {
        case 0:
            cell.textLabel.text = @"头像";
            [cell.contentView addSubview:headView];
            break;
        case 1:
            cell.textLabel.text = @"昵称";
            [cell.contentView addSubview:nameField];
            break;
        case 2:
            cell.textLabel.text = @"签名";
            [cell.contentView addSubview:signField];
            break;
        case 3:
            cell.textLabel.text = @"性别";
            cell.detailTextLabel.text = self.sex;
            break;
        case 4:
            cell.textLabel.text = @"城市";
            BOOL boolean = [self.sheng isEqualToString:@""] || [self.sheng isEqualToString:self.shi];
            cell.detailTextLabel.text = boolean ? self.shi : [NSString stringWithFormat:@"%@ %@", self.sheng,self.shi];
            break;
        case 5:
            cell.textLabel.text = @"标签";
            cell.detailTextLabel.text = self.tagText;
        default:
            break;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20.0f;
}

- (void)tableView:(UITableView *)tableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row != 1 && indexPath.row != 2)
    {
        [self textFieldEditDidFinish];
    }
    
    if (indexPath.row == 0)
    {
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择头像来源..."
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"本地相册",@"摄像头获取", nil];
        [sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
        [sheet showInView:self.view];
        return;
    }
    if (indexPath.row == 1)
    {
        [nameField becomeFirstResponder];
        return;
    }
    if (indexPath.row == 2)
    {
        [signField becomeFirstResponder];
        return;
    }
    if (indexPath.row == 3)
    {
        InfoSelector *selector = [[InfoSelector alloc] init];
        selector.delegate = self;
        [self.navigationController pushViewController:selector animated:YES];
        return;
    }
    if (indexPath.row == 4)
    {
        InfoSelector *selector = [[InfoSelector alloc] init];
        selector.mainlist = self.cityList;
        selector.delegate = self;
        [self.navigationController pushViewController:selector animated:YES];
        return;
    }
    if (indexPath.row == 5)
    {
        ADLabelView *label = [[ADLabelView alloc] init];
        label.aDelegate = self;
        [self.navigationController pushViewController:label animated:YES];
    }
}

- (void)didSeletedCity:(NSDictionary *)info {
    
    self.sheng = [info valueForKey:@"sheng"];
    self.shi   = [info valueForKey:@"shi"];
    [tableView reloadData];
}

- (void)backWithTags:(NSString *)tags names:(NSString *)names {
    
    self.tagText = names;
    [tableView reloadData];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 2) return;
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = buttonIndex == 1 ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    controller.allowsEditing = YES;
    controller.delegate = self;
    [self presentModalViewController:controller animated:YES];
}


- (UITextField *)textField {
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(70, 7, 210, 30)];
    textField.font = [Custom systemFont:13];
    textField.textAlignment = NSTextAlignmentRight;
    textField.borderStyle = UITextBorderStyleNone;
    textField.textColor = [UIColor grayColor];
    textField.delegate = self;
    [textField addTarget:self action:@selector(textField) forControlEvents:UIControlEventEditingDidEndOnExit];
    return textField;
}

- (UITableView *)tableView {
    
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:IOS7];
    if (!IOS7)
    {
        table.separatorColor = CLEARCOLOR;
        table.backgroundColor = ARGB(239, 239, 244, 1.0);
        table.backgroundView = nil;
    }
    table.dataSource = self;
    table.delegate = self;
    return table;
    
}

- (UIImageView *)imageView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 5, 60, 60)];
    [imageView.layer setCornerRadius:5];
    [imageView.layer setMasksToBounds:YES];
	[imageView.layer setCornerRadius:4];
    return imageView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
