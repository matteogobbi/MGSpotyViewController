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
 *  Main image view
 */
@property (nonatomic, strong, readonly) UITableView *tableView;

/**
 *  Overview object
 */
@property (nonatomic, strong) UIView *overView;

/**
 *  Main image view
 */
@property (nonatomic, strong) UIImageView *mainImageView;

/**
 *  The tint color on top of the blur. When alpha is 1.0 
 *  you'll not be able to see the image behind.
 */
@property (nonatomic, strong) UIColor *tintColor;

/**
 *  Indicate if the overView has to fade out when scrolling up
 *  Default value: NO
 */
@property (atomic) BOOL overViewFadeOut __deprecated_msg("Deprecated in version 0.4.8; Use instead `overViewUpFadeOut`.");

/**
 *  Indicate if the overView has to fade out when scrolling up
 *  Default value: NO
 */
@property (atomic) BOOL overViewUpFadeOut;

/**
 *  Indicate if the overView has to fade out when scrolling down
 *  Default value: YES
 */
@property (atomic) BOOL overViewDownFadeOut;

/**
 *  Indicate if the main image has to get unblurred when scrolling down
 *  Default value: YES
 */
@property (atomic) BOOL shouldUnblur;

/**
 *  Indicate if the overView height is resized automatically when the
 *  device is rotated (ie when the height of the interface change)
 *  Default value: YES
 */
@property (atomic) BOOL flexibleOverviewHeight;

/**
 *  Set the value of the blur radius.
 *  Default value: 20.0
 */
@property (nonatomic) CGFloat blurRadius;

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