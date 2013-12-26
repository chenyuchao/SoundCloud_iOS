//
//  More.m
//  iSound
//
//  Created by Jumax.R on 13-9-28.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "More.h"

@interface More ()

@end

@implementation More


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    titleArray = [[NSArray alloc] initWithObjects:@"Record",
                                                  @"Who to follow",
                                                  @"Find friends",
                                                  @"People you follow (0)",
                                                  @"People who follow you (0)",
                                                  @"Account info", @"Sign out", nil];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        self.view.backgroundColor = ARGB(239, 239, 244, 1.0);
        [(UITableView *)self.view setBackgroundView:nil];
    }
    self.title = @"更  多";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section)
    {
        case 0:
            return 1;
        case 1:
            return 4;
        case 3:
        case 4:
            return 0;
    }
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSInteger row     = indexPath.row;
    NSInteger section = indexPath.section;
    static NSString *identifier = @"MoreCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [Custom systemFont:14];
        cell.textLabel.numberOfLines = 0;
    }
    NSInteger currentRow = [self atRow:row section:section];
    cell.textLabel.text = [titleArray objectAtIndex:currentRow];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSLog(@"%i",[self atRow:indexPath.row section:indexPath.section]);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    if (section < 3)
    {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 25)];
    label.text = section == 3 ? @"SoundClound Imprint, Terms of Use, Cookie Policy and Privacy Policy." :
                                @"SoundClound v2.6.5";
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.font = [Custom systemFont:12];
    label.backgroundColor = CLEARCOLOR;
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    if (section < 3)
        return 10;
    return 30;
}

- (NSInteger)atRow:(NSInteger)row section:(NSInteger)section {

    if (section == 0)
        return row;
    if (section == 1)
        return row + 1;
    if (section == 2)
        return row + 5;
    if (section == 3)
        return row + 7;
    return row + 8;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
