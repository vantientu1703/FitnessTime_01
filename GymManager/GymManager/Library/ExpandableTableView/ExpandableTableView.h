//
//  ExpandableTableView.h
//  ExpandableTableView
//
//  Created by Warif Akhand Rishi on 4/13/16.
//  Copyright © 2016 Warif Akhand Rishi. All rights reserved.
//

#import <UIKit/UIKit.h>

const CGFloat kTableViewHeaderHeight = 60.0;

@protocol ExpandableTableViewDelegate <NSObject>

- (void)didEndAnimationWithNumberOffCellChange:(NSInteger)numberOfCell;
- (void)didDeleteSection:(NSUInteger)section;

@end

@interface ExpandableTableView : UITableView

@property (nonatomic, assign) BOOL allHeadersInitiallyCollapsed;
@property (nonatomic, assign) int initiallyExpandedSection;
@property (nonatomic, strong) id<ExpandableTableViewDelegate> expandableDelegate;

- (NSInteger)totalNumberOfRows:(NSInteger)total inSection:(NSInteger)section;
- (UIView *)headerWithTitle:(NSString *)title totalRows:(NSInteger)row inSection:(NSInteger)section;

@end
