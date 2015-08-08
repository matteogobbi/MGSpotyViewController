//
//  MGSpotyViewController.h
//  MGSpotyView
//
//  Created by Matteo Gobbi on 25/06/2014.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

@import UIKit;

#import "MGSpotyViewControllerProtocol.h"

extern CGFloat const kMGOffsetEffects;
extern CGFloat const kMGOffsetBlurEffect;


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
 *  The MGSpotyViewController delegate. This protocol wraps the tableview datasource and delegate
 */
@property (nonatomic, weak) id <MGSpotyViewControllerProtocol> delegate;

/**
 *  Initialize method for MGSpotyViewController
 *
 *  @param image UIImage you want to use
 *
 *  @return MGSpotyViewController
 */
- (instancetype)initWithMainImage:(UIImage *)image;

/**
 *  Set an UIImage for the mainImageView
 *
 *  @param image UIImage you want to use
 */
- (void)setMainImage:(UIImage *)image;

@end