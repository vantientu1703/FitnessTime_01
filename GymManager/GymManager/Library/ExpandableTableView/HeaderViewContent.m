//
//  HeaderViewContent.m
//  GymManager
//
//  Created by Thinh on 8/12/16.
//  Copyright © 2016 vantientu. All rights reserved.
//

#import "HeaderViewContent.h"

@interface HeaderViewContent () <UIActionSheetDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *customConstraints;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger totalRows;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL isCollapsed;

@end

@implementation HeaderViewContent

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier andFrame:(CGRect)frame {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.frame = frame;
        [self addHeaderButton];
    }
    return self;
}

- (void)drawView {
    [self commonInit];
}

- (void)addHeaderButton {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerButtonAction:)];
    [self addGestureRecognizer:tap];
}

- (void)headerButtonAction:(UIButton *)headerButton {
    self.isCollapsed = !self.isCollapsed;
    if ([self.delegate respondsToSelector:@selector(didTapHeader:)]) {
        [self.delegate didTapHeader:self];
    }
}

- (void)updateWithTitle:(NSString *)title isCollapsed:(BOOL)isCollapsed totalRows:(NSInteger)row andSection:(NSInteger)section {
    self.title = title;
    self.isCollapsed = isCollapsed;
    self.section = section;
    self.totalRows = row;
}

- (void)commonInit {
    self.customConstraints = [[NSMutableArray alloc] init];
    UIView *view = nil;
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"HeaderViewContent"
                                                     owner:self
                                                   options:nil];
    for (id object in objects) {
        if ([object isKindOfClass:[UIView class]]) {
            view = object;
            break;
        }
    }
    if (view != nil) {
        view.frame = self.contentView.bounds;
        [self.contentView addSubview:view];
    }
}

- (IBAction)btnMenuClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"What do you want to do?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete"
                                                    otherButtonTitles:@"Edit", nil];
    [actionSheet showInView:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([self.delegate respondsToSelector:@selector(didPickActionSheetAtIndex:withHeaderView:)]) {
        [self.delegate didPickActionSheetAtIndex:buttonIndex withHeaderView:self];
    }
}
@end
