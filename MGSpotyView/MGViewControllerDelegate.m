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


#pragma mark - MGSpotyViewControllerProtocol

- (NSInteger)spotyViewController:(MGSpotyViewController *)spotyViewController
     numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger mySections = 1;
    return mySections + 1;
}

- (NSInteger)spotyViewController:(MGSpotyViewController *)spotyViewController
                   withTableView:(UITableView *)tableView
           numberOfRowsInSection:(NSInteger)section
{
    return (section == 1) ? 20 : 0;
}

- (UITableViewCell *)spotyViewController:(MGSpotyViewController *)spotyViewController
                           withTableView:(UITableView *)tableView
                   cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    cell.textLabel.text = @"Cell";
    
    return cell;
}

- (UIView *)spotyViewController:(MGSpotyViewController *)spotyViewController
                  withTableView:(UITableView *)tableView
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
                 withTableView:(UITableView *)tableView
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
                    withTableView:(UITableView *)tableView
          titleForHeaderInSection:(NSInteger)section
{
    return (section == 1) ? @"My Section" : nil;
}


@end