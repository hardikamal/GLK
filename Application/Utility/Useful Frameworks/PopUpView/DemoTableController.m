//
//  DemoTableControllerViewController.m
//  FPPopoverDemo
//
//  Created by Alvise Susmel on 4/13/12.
//  Copyright (c) 2012 Fifty Pixels Ltd. All rights reserved.
//

#import "DemoTableController.h"
@interface DemoTableController ()

@end

@implementation DemoTableController


- (void)viewDidLoad
{
    [self.tableView setScrollEnabled:NO];
    [super viewDidLoad];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view setBackgroundColor:[UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:239.0f/255.0f alpha:1.0f]];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listArray count];
}
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[[_listArray objectAtIndex:[indexPath row]] objectForKey:@"name"];
    cell.textLabel.font= [UIFont fontWithName:Embrima size:16.0f];

	cell.backgroundColor = [UIColor clearColor];
    cell.imageView.image=[UIImage imageNamed:[[_listArray objectAtIndex:[indexPath row]] objectForKey:@"image"]];
    return cell;
}


#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    NSString * noticationName =@"DemoListner";
    NSMutableDictionary *bookListing = [[NSMutableDictionary alloc] init];
    [bookListing setObject:[NSString stringWithFormat:@"%ld",(long)[indexPath row]] forKey:@"index"];
    [bookListing setObject:[NSNumber numberWithInteger:self.position]forKey:@"position"];
    [[NSNotificationCenter defaultCenter] postNotificationName:noticationName   object:nil userInfo:bookListing];
}




@end
