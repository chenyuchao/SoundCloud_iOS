//
//  AddTagForUser.m
//  iSound
//
//  Created by Jumax.R on 13-11-4.
//  Copyright (c) 2013年 Jumax.R. All rights reserved.
//

#import "AddTagForUser.h"
#import "Recommend.h"

@interface AddTagForUser ()

@end

@implementation AddTagForUser


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"选择合适您的标签";
    self.navigationItem.hidesBackButton = YES;
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(0, 0, 28, 28);
    [nextButton addTarget:self
                   action:@selector(nextButton)
         forControlEvents:UIControlEventTouchUpInside];
    [nextButton setImage:[UIImage imageNamed:@"nextBtn"]
                forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = CUSTOMVIEW(nextButton);
    
    [[Request request:100] getTagListWithDelegate:self];
    
    headerScrollView = [self scrollView];
    mainScrollView = [self scrollView];
    mainTableView = [self tableView];
    
    headerScrollView.backgroundColor = mainTableView.backgroundColor;
    headerScrollView.layer.borderColor = ARGB(220, 220, 220, 1.0).CGColor;
    headerScrollView.layer.borderWidth = 0.5f;
    mainScrollView.frame = CGRectMake(130, 60, 190, 508);
    mainScrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:headerScrollView];
    [self.view addSubview:mainTableView];
    [self.view addSubview:mainScrollView];
    
    self.selectedTag = [NSMutableArray array];
}

- (void)nextButton {
    
    NSMutableString *tags = [NSMutableString string];
    for (NSDictionary *objet in self.selectedTag)
    {
        [tags appendString:[objet valueForKey:@"id"]];
        break;
        if (objet  != [self.selectedTag lastObject])
            [tags appendString:@","];
        
    }
    UserInfo *info = [UserInfo standardUserInfo];
    [[Request request] addTagForUser:info.user_id
                               tagId:tags
                             isFirst:YES
                            delegate:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.mainlist count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    static NSString *identifier = @"AddTagForUserCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = CLEARCOLOR;
        cell.textLabel.textColor = ARGB(112, 112, 112, 1.0);
        cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, 320, 0.5)];
        aView.backgroundColor = ARGB(220, 220, 220, 1.0);
        [cell.contentView addSubview:aView];
        
        aView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
        aView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = aView;
    }
    NSDictionary *object = [self.mainlist objectAtIndex:row];
    cell.textLabel.text = [object valueForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self selctedCellAtIndex:(int)indexPath.row];
}

- (void)downloadDidFinish:(Request *)request withResult:(id)result  {
    
    if ([[result valueForKey:@"code"] integerValue] != 200)
    {
        return;
    }
    if (request.requestId == 100)
    {
        self.mainlist = [[[result valueForKey:@"data"] valueForKey:@"tag_list"] valueForKey:@"one_level"];
        [mainTableView reloadData];
        [self selctedCellAtIndex:0];
        
        NSIndexPath *indexPath = [mainTableView indexPathForRowAtPoint:CGPointMake(0, 0)];
        [mainTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    else
    {
        Recommend *controller = [[Recommend alloc] init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)selctedCellAtIndex:(int)idx {
    
    [mainScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *tabs = [[self.mainlist objectAtIndex:idx] valueForKey:@"two_level"];
    
    CGFloat lastY;
    for (int i = 0; i < [tabs count]; i++)
    {
        NSDictionary *object = [tabs objectAtIndex:i];
        
        lastY  = i / 2 * 41 + 6;
        TagButton *button = [TagButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((i % 2) * 95 + 10, lastY, 75, 29);
        [button setBackgroundImage:[UIImage imageNamed:@"tagNormal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"tagSelected"] forState:UIControlStateSelected];
        [button setTitle:[object valueForKey:@"name"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tagButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [[button titleLabel] setFont:[Custom systemFont:13]];
        [button setElement:object];
        [mainScrollView addSubview:button];
        
        for (NSDictionary *element in self.selectedTag) {
            
            if ([[element valueForKey:@"id"] isEqualToString:[object valueForKey:@"id"]])
            {
                button.selected = YES;
            }
        }
    }
    [mainScrollView setContentSize:CGSizeMake(0, lastY + 47)];
}

- (void)tagButtonPressed:(TagButton *)sender {
    
    sender.selected = !sender.selected;
    
    BOOL find = NO;
    
    for (NSDictionary *object in self.selectedTag)
    {
        if ([[object valueForKey:@"id"] isEqualToString:[sender.element valueForKey:@"id"]])
        {
            [self.selectedTag removeObject:object];
            find = YES;
            break;
        }
    }
    if (find == NO)
    {
        [self.selectedTag addObject:sender.element];
    }
    
    [headerScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    int i = 0;
    for (; i < [self.selectedTag count]; i++)
    {
        NSDictionary *object = [self.selectedTag objectAtIndex:i];
        TagButton *button = [TagButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * 64 + 5, 15.5, 54, 29);
        [button setBackgroundImage:[UIImage imageNamed:@"selectedTag"] forState:UIControlStateNormal];
        [button setTitle:[object valueForKey:@"name"] forState:UIControlStateNormal];
        [button setUserInteractionEnabled:NO];
        [button setTitleColor:ARGB(254, 115, 24, 1.0) forState:UIControlStateNormal];
        [[button titleLabel] setFont:[Custom systemFont:12]];
        [headerScrollView addSubview:button];
    }
    [headerScrollView setContentSize:CGSizeMake(i * 64, 0)];
}

- (UITableView *)tableView {
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, 130, 508)];
    table.backgroundColor = ARGB(238, 238, 238, 1.0);
    table.separatorColor = CLEARCOLOR;
    table.delegate = self;
    table.dataSource = self;
    return table;
}

- (UIScrollView *)scrollView {
    
    return [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

@implementation TagButton

- (void)setElement:(NSDictionary *)element {
    
    _element = [NSDictionary dictionaryWithDictionary:element];
}

@end
