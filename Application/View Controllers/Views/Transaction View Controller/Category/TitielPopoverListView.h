//
//  TitielPopoverListView.h
//  Daily Expense Manager
//
//  Created by Appbulous on 12/11/14.
//  Copyright (c) 2014 Jyoti Kumar. All rights reserved.
//

@class TitielPopoverListView;

@protocol TitielPopoverListViewDataSource <NSObject>
@required

- (UITableViewCell *)popoverListView:(TitielPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)popoverListView:(TitielPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section;

@end

@protocol TitielPopoverListViewDelegate <NSObject>
@optional

- (void)popoverListView:(TitielPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath;

- (void)popoverListViewCancel:(TitielPopoverListView *)popoverListView;

- (CGFloat)popoverListView:(TitielPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface TitielPopoverListView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_listView;
    UILabel     *_titleView;
    UIControl   *_overlayView;
    
}

@property (nonatomic, assign) id<TitielPopoverListViewDataSource> datasource;
@property (nonatomic, assign) id<TitielPopoverListViewDelegate>   delegate;
@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic, retain) UITableView *listView;
@property (nonatomic, retain) NSString     *categeryOrsubcategery;

- (void)setTitle:(NSString *)title;
- (void)show;
- (void)dismiss;

@end
