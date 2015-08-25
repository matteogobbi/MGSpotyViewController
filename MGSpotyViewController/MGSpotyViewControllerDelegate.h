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
- (CGFloat)spotyViewController:(MGSpotyViewController *)spotyViewController
    heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (UIView *)spotyViewController:(MGSpotyViewController *)spotyViewController
         viewForHeaderInSection:(NSInteger)section;
- (CGFloat)spotyViewController:(MGSpotyViewController *)spotyViewController
      heightForHeaderInSection:(NSInteger)section;
- (NSString *)spotyViewController:(MGSpotyViewController *)spotyViewController
          titleForHeaderInSection:(NSInteger)section;

@end