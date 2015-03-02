//
//  CurrencyPopUpViewController.m
//  Daily Expense Manager
//
//  Created by Appbulous on 16/01/15.
//  Copyright (c) 2015 Chandan Kumar. All rights reserved.
//

#import "CurrencyPopUpViewController.h"
#import "Recipe.h"
#import "UIAlertView+Block.h"
#import "CurrencyPopUpCell.h"
@interface CurrencyPopUpViewController ()
{
    NSMutableArray *recipes;
    NSArray *searchResults;
}
@end

@implementation CurrencyPopUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Utility setFontFamily:Embrima forView:self.view andSubViews:YES];
    [self.lblTitle setFont:[UIFont fontWithName:Ebrima_Bold size:16.0f]];
    // Initialize the recipes array
    recipes =[[NSMutableArray alloc] init];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    self.tapView.userInteractionEnabled=YES;
    [self.tapView addGestureRecognizer:tapRecognizer];
    
    NSArray* sortedArray = [[NSLocalizedString(@"countries", nil) componentsSeparatedByString:@","] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSArray* signArray =[NSLocalizedString(@"items", nil) componentsSeparatedByString:@","];;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    for (int i=0; i<[signArray count]; i++)
    {
        NSUInteger index ;
        Recipe *recipe1 = [Recipe new];
        recipe1.name =[sortedArray objectAtIndex:i];
        NSArray *array =[NSLocalizedString(@"countries", nil) componentsSeparatedByString:@","];
        NSString *matchCity =[sortedArray objectAtIndex:i];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", matchCity];
        index = [array  indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
            return [predicate evaluateWithObject:obj];
        }];
        recipe1.prepTime = [signArray objectAtIndex:index];
        recipe1.image =[NSString stringWithFormat:@"%@.png",[sortedArray objectAtIndex:i]];
        [recipes addObject:recipe1];
    }
}

- (IBAction)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self animatedOut];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [searchResults count];
        
    } else
    {
        return [recipes count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomTableCell";
    CurrencyPopUpCell *cell = (CurrencyPopUpCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil)
    {
        cell = [[CurrencyPopUpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Display recipe in the table cell
    Recipe *recipe = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        recipe = [searchResults objectAtIndex:indexPath.row];
    } else
    {
        recipe = [recipes objectAtIndex:indexPath.row];
    }
    cell.nameLabel.text = recipe.name;
    cell.thumbnailImageView.image = [UIImage imageNamed:recipe.image];
    NSArray *array=[recipe.prepTime componentsSeparatedByString:@"-"];
    cell.lblCurrency.text=[array objectAtIndex:1];
    cell.lblCurrency.font=[UIFont fontWithName:Embrima size:14.0f];
    cell.nameLabel.font=[UIFont fontWithName:Embrima size:14.0f];
    cell.prepTimeLabel.font=[UIFont fontWithName:Embrima size:14.0f];
    cell.prepTimeLabel.text =[array objectAtIndex:0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Recipe *recipe ;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        recipe  = [searchResults objectAtIndex:indexPath.row];
        
    } else
    {
        recipe  = [recipes objectAtIndex:indexPath.row];
    }
      NSString *mainToken=[[[Utility userDefaultsForKey:CURRENT_TOKEN_ID] componentsSeparatedByString:@"_"] objectAtIndex:0];
      [Utility  removeFromUserDefaultsWithKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
     [Utility saveToUserDefaults:recipe.prepTime withKey:[NSString stringWithFormat:@"%@ @@@@ %@",CURRENT_CURRENCY,mainToken]];
    
    [self animatedOut];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    searchResults = [recipes filteredArrayUsingPredicate:resultPredicate];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles]  objectAtIndex:[self.searchDisplayController.searchBar  selectedScopeButtonIndex]]];
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    [tableView setFrame:CGRectMake(self.tableView .frame.origin.x+16, tableView .frame.origin.y, self.tableView .frame.size.width, self.tableView .frame.size.height)];
}


- (void)animatedIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)animatedOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self.view removeFromSuperview];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:CURRENT_CURRENCY_TIMESTAMP];
            NSString * noticationName =@"CurrencyPopUpViewController";
            NSMutableDictionary *bookListing = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:noticationName object:nil userInfo:bookListing];
        }
    }];
}


- (void)touchForDismissSelf:(id)sender
{
    [self animatedOut];
    
}

- (void)show
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self.view];
    self.view.center = CGPointMake(keywindow.bounds.size.width/2.0f, keywindow.bounds.size.height/2.0f);
    [self animatedIn];
}

- (void)dismiss
{
    [self animatedOut];
}
@end
