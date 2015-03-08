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
- (IBAction)doneClick:(UIBarButtonItem *)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the recipes array
    recipes = [[NSMutableArray alloc] init];
    NSArray *sortedArray = [[NSLocalizedString(@"countries", nil) componentsSeparatedByString:@","] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSArray *signArray = [NSLocalizedString(@"items", nil) componentsSeparatedByString:@","];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    for (int i = 0; i < [signArray count]; i++) {
        NSUInteger index;
        Recipe *recipe1 = [Recipe new];
        recipe1.name = [sortedArray objectAtIndex:i];
        NSArray *array = [NSLocalizedString(@"countries", nil) componentsSeparatedByString:@","];
        NSString *matchCity = [sortedArray objectAtIndex:i];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", matchCity];
        index = [array indexOfObjectPassingTest: ^(id obj, NSUInteger idx, BOOL *stop) {
            return [predicate evaluateWithObject:obj];
        }];
        recipe1.prepTime = [signArray objectAtIndex:index];
        recipe1.image = [NSString stringWithFormat:@"%@.png", [sortedArray objectAtIndex:i]];
        [recipes addObject:recipe1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    }
    else {
        return [recipes count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CustomTableCell";
    CurrencyPopUpCell *cell = (CurrencyPopUpCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[CurrencyPopUpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Display recipe in the table cell
    Recipe *recipe = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        recipe = [searchResults objectAtIndex:indexPath.row];
    }
    else {
        recipe = [recipes objectAtIndex:indexPath.row];
    }
    cell.nameLabel.text = recipe.name;
    cell.thumbnailImageView.image = [UIImage imageNamed:recipe.image];
    NSArray *array = [recipe.prepTime componentsSeparatedByString:@"-"];
    cell.lblCurrency.text = [array objectAtIndex:1];
    
    cell.prepTimeLabel.text = [array objectAtIndex:0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Recipe *recipe;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        recipe  = [searchResults objectAtIndex:indexPath.row];
    }
    else {
        recipe  = [recipes objectAtIndex:indexPath.row];
    }
    NSString *mainToken = [[[Utility userDefaultsForKey:CURRENT_TOKEN_ID] componentsSeparatedByString:@"_"] objectAtIndex:0];
    [Utility removeFromUserDefaultsWithKey:[NSString stringWithFormat:@"%@ @@@@ %@", CURRENT_CURRENCY, mainToken]];
    [Utility saveToUserDefaults:recipe.prepTime withKey:[NSString stringWithFormat:@"%@ @@@@ %@", CURRENT_CURRENCY, mainToken]];
    
    [self animatedOut];
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"name contains[c] %@", searchText];
    searchResults = [recipes filteredArrayUsingPredicate:resultPredicate];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    //[tableView setFrame:CGRectMake(self.tableView .frame.origin.x+16, tableView .frame.origin.y, self.tableView .frame.size.width, self.tableView .frame.size.height)];
}

- (void)animatedOut {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:CURRENT_CURRENCY_TIMESTAMP];
    NSString *noticationName = @"CurrencyPopUpViewController";
    NSMutableDictionary *bookListing = [[NSMutableDictionary alloc] init];
    [[NSNotificationCenter defaultCenter] postNotificationName:noticationName object:nil userInfo:bookListing];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
