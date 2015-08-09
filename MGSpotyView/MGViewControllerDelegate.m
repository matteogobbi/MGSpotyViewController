//
//  MGViewControllerDelegate.m
//  MGSpotyView
//
//  Created by Daniele Bogo on 08/08/2015.
//  Copyright (c) 2015 Matteo Gobbi. All rights reserved.
//

#import "MGViewControllerDelegate.h"
#import "MGSpotyViewController.h"


@implementation MGViewControllerDelegate


#pragma mark - MGSpotyViewControllerDelegate

- (CGFloat)spotyViewController:(MGSpotyViewController *)spotyViewController
       heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UIView *)spotyViewController:(MGSpotyViewController *)spotyViewController
         viewForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        UIView *transparentView = [[UIView alloc] initWithFrame:spotyViewController.overView.bounds];
        [transparentView setBackgroundColor:[UIColor clearColor]];
        return transparentView;
    }
    
    return nil;
}

- (CGFloat)spotyViewController:(MGSpotyViewController *)spotyViewController
      heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return CGRectGetHeight(spotyViewController.overView.frame);
            break;
            
        case 1:
            return 20.0;
            break;
            
        default:
            return 0.0;
            break;
    }
}

- (NSString *)spotyViewController:(MGSpotyViewController *)spotyViewController
          titleForHeaderInSection:(NSInteger)section
{
    return (section == 1) ? @"My Section" : nil;
}


@end