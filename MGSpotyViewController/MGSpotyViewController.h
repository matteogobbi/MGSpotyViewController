//
//  MGSpotyViewController.h
//  MGSpotyView
//
//  Created by Matteo Gobbi on 25/06/2014.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

@import UIKit;

#import "MGSpotyViewControllerDataSource.h"
#import "MGSpotyViewControllerDelegate.h"


extern CGFloat const kMGOffsetEffects;
extern CGFloat const kMGOffsetBlurEffect;

typedef NS_ENUM(NSUInteger, MGSpotyViewTableScrollingType) {
    MGSpotyViewTableScrollingTypeNormal,
    MGSpotyViewTableScrollingTypeOver
};

@interface MGSpotyViewController : UIViewController

/**
 *  Main TableView object
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 *  Overview object
 */
@property (nonatomic, strong) UIView *overView;

/**
 *  Main image view
 */
@property (nonatomic, strong) UIImageView *mainImageView;

/**
 *  The MGSpotyViewController dataSource. This protocol wraps the tableview datasource
 */
@property (nonatomic, weak) id <MGSpotyViewControllerDataSource> dataSource;

/**
 *  The MGSpotyViewController delegate. This protocol wraps the tableview delegate
 */
@property (nonatomic, weak) id <MGSpotyViewControllerDelegate> delegate;

/**
 *  Initialize method for MGSpotyViewController
 *
 *  @param image UIImage you want to use
 *
 *  @return MGSpotyViewController
 */
- (instancetype)initWithMainImage:(UIImage *)image;

/**
 *  Initialize method for MGSpotyViewController
 *
 *  @param image UIImage you want to use
 *  @param scrollingType the type of the tableView scrolling
 *
 *  @return MGSpotyViewController
 */
- (instancetype)initWithMainImage:(UIImage *)image tableScrollingType:(MGSpotyViewTableScrollingType)scrollingType;

/**
 *  Set an UIImage for the mainImageView
 *
 *  @param image UIImage you want to use
 */
- (void)setMainImage:(UIImage *)image;

/**
 *  Register class for the tableview
 *
 *  @param cellClass  cell class
 *  @param identifier cell isdentifier
 */
- (void)registerCellClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;

@end