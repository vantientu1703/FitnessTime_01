//
//  ExpandableTableView.m
//  ExpandableTableView
//
//  Created by Warif Akhand Rishi on 4/13/16.
//  Copyright © 2016 Warif Akhand Rishi. All rights reserved.
//

#import "ExpandableTableView.h"
//#import "HeaderView.h"
#import "HeaderViewContent.h"
@interface ExpandableTableView () <HeaderViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *sectionStatusDic;

@end

@implementation ExpandableTableView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.sectionStatusDic = [[NSMutableDictionary alloc] init];
    self.initiallyExpandedSection = -1;
}

- (HeaderViewContent *)headerView {
    HeaderViewContent *headerView  = [self dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    if (!headerView) {
        CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), kTableViewHeaderHeight);
        headerView = [[HeaderViewContent alloc] initWithReuseIdentifier:@"Header" andFrame:frame];
        headerView.delegate = self;
    }
    return headerView;
}

- (BOOL)collapsedForSection:(NSInteger)section {
    NSString *key = [NSString stringWithFormat:@"%ld", (long)section];
    if (self.sectionStatusDic[key]) {
        return ((NSNumber *)self.sectionStatusDic[key]).boolValue;
    }
    return (self.initiallyExpandedSection == section) ? NO : self.allHeadersInitiallyCollapsed;
}

- (NSInteger)totalNumberOfRows:(NSInteger)total inSection:(NSInteger)section; {
    return ([self collapsedForSection:section]) ? 0 : total;
}

- (UIView *)headerWithTitle:(NSString *)title totalRows:(NSInteger)row inSection:(NSInteger)section {
    BOOL isCollapsed = [self collapsedForSection:section];
    HeaderViewContent *headerView = self.headerView;
    [headerView updateWithTitle:title isCollapsed:isCollapsed totalRows:row andSection:section];
    [headerView drawView];
    return headerView;
}

#pragma mark - HeaderViewDelegate
- (void)didTapHeader:(HeaderViewContent *)headerView {
    NSString *key = [NSString stringWithFormat:@"%ld", (long)headerView.section];
    BOOL isCollapsed = [self collapsedForSection:headerView.section];
    isCollapsed = !isCollapsed;
    [self.sectionStatusDic setObject:@(isCollapsed) forKey:key];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (int i = 0; i < headerView.totalRows; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:headerView.section]];
    }
    [CATransaction begin];
    [self beginUpdates];
    NSInteger numberOfCellChanged = 0;
    if (isCollapsed) {
        numberOfCellChanged = -(headerView.totalRows);
        [self.expandableDelegate didEndAnimationWithNumberOffCellChange:numberOfCellChanged];
        [self deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
    } else {
        numberOfCellChanged = (headerView.totalRows);
        [self insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
        [self.expandableDelegate didEndAnimationWithNumberOffCellChange:numberOfCellChanged];
    }
    [self endUpdates];
    [CATransaction commit];
}

- (void)didPickActionSheetAtIndex:(NSUInteger)index withHeaderView:(HeaderViewContent *)headerView {
    if (index == 0) {
        NSString *key = [NSString stringWithFormat:@"%ld", (long)headerView.section];
        BOOL isCollapsed = [self collapsedForSection:headerView.section];
        isCollapsed = !isCollapsed;
        [self.sectionStatusDic setObject:@(isCollapsed) forKey:key];
        for (NSInteger i = headerView.section; i < self.numberOfSections - 1; i++) {
            NSString *key = [NSString stringWithFormat:@"%ld", (long)i];
            BOOL isCollapsed = [self collapsedForSection:(i +1)];
            [self.sectionStatusDic setObject:@(isCollapsed) forKey:key];
        }
        [self.expandableDelegate didDeleteSection:headerView.section];
    }
}

@end
