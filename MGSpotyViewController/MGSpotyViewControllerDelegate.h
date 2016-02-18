//
//  MGSpotyViewControllerDelegate.h
//  MGSpotyView
//
//  Created by Daniele Bogo on 08/08/2015.
//  Copyright (c) 2015 Matteo Gobbi. All rights reserved.
//

@import Foundation;
@import UIKit;

@class MGSpotyViewController;
@protocol MGSpotyViewControllerDelegate <NSObject>

@optional
- (CGFloat)spotyViewController:(nonnull MGSpotyViewController *)spotyViewController
    heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (nullable UIView *)spotyViewController:(nonnull MGSpotyViewController *)spotyViewController
         viewForHeaderInSection:(NSInteger)section;

- (CGFloat)spotyViewController:(nonnull MGSpotyViewController *)spotyViewController
      heightForHeaderInSection:(NSInteger)section;

- (nonnull NSString *)spotyViewController:(nonnull MGSpotyViewController *)spotyViewController
          titleForHeaderInSection:(NSInteger)section;

- (void)spotyViewController:(nonnull MGSpotyViewController *)spotyViewController
              scrollViewDidScroll:(nonnull UIScrollView *)scrollView;

- (void)spotyViewController:(nonnull MGSpotyViewController *)spotyViewController
  didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

- (void)spotyViewController:(nonnull MGSpotyViewController *)spotyViewController
    didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath;


@end