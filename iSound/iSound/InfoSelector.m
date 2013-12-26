//
//  SelectedCity.m
//  iSound
//
//  Created by Jumax.R on 13-11-10.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "InfoSelector.h"

@implementation InfoSelector


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"城市选择";
    if (self.stringA == nil)
        self.stringA = @"";
    
    if (!self.mainlist)
    {
        self.mainlist = @[[NSDictionary dictionaryWithObject:@"男" forKey:@"name"],
                          [NSDictionary dictionaryWithObject:@"女" forKey:@"name"]];
        self.title = @"性别选择";
    }
    self.view.backgroundColor = ARGB(239, 239, 244, 1.0);
    [(UITableView *)self.view setSeparatorColor:CLEARCOLOR];
    [(UITableView *)self.view setBackgroundView:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mainlist count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        
        cell.textLabel.backgroundColor = CLEARCOLOR;
        cell.detailTextLabel.backgroundColor = CLEARCOLOR;
        
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

        cell.textLabel.font = [Custom systemFont:13];
    }

    UIView *lineViewA = [cell.contentView viewWithTag:100];
    UIView *lineViewB = [cell.contentView viewWithTag:101];
    if (indexPath.row == 0)
    {
        lineViewA.frame = CGRectMake(15, 43.5, 305, 0.5);
        lineViewB.hidden = NO;
    }
    else if (indexPath.row == [self.mainlist count] - 1)
    {
        lineViewA.frame = CGRectMake(0, 43.5, 320, 0.5);
        lineViewB.hidden = YES;
    }
    else if (indexPath.row > 0 && indexPath.row < [self.mainlist count] - 1)
    {
        lineViewA.frame = CGRectMake(15, 43.5, 305, 0.5);
        lineViewB.hidden = YES;
    }

    NSDictionary *dictionary = [self.mainlist objectAtIndex:indexPath.row];
    cell.textLabel.text = [dictionary valueForKey:@"name"];

    if ([[dictionary valueForKey:@"city"] isKindOfClass:[NSArray class]])
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dictionary = [self.mainlist objectAtIndex:indexPath.row];
    
    if ([[[self.mainlist objectAtIndex:0] valueForKey:@"name"] isEqualToString:@"男"])
    {
        [self.delegate didSeletedSex:[dictionary valueForKey:@"name"]];
        [self.navigationController popToViewController:(UIViewController *)self.delegate animated:YES];
        return;
    }
    
    if (![[dictionary valueForKey:@"city"] isKindOfClass:[NSArray class]])
    {
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setObject:[dictionary valueForKey:@"name"] forKey:@"shi"];
        [info setObject:self.stringA forKey:@"sheng"];
        [self.delegate didSeletedCity:[NSDictionary dictionaryWithDictionary:info]];
        [self.navigationController popToViewController:(UIViewController *)self.delegate animated:YES];
        return;
    }
    
    InfoSelector *selector = [[InfoSelector alloc] init];
    selector.mainlist = [dictionary valueForKey:@"city"];
    selector.delegate = self.delegate;
    selector.stringA  = [dictionary valueForKey:@"name"];
    [self.navigationController pushViewController:selector animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20.0f;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 20.0f;
}


@end
