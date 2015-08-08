//
//  MGViewControllerDataSource.m
//  MGSpotyView
//
//  Created by Daniele Bogo on 08/08/2015.
//  Copyright (c) 2015 Matteo Gobbi. All rights reserved.
//

#import "MGViewControllerDataSource.h"
#import "MGSpotyViewController.h"


@implementation MGViewControllerDataSource


#pragma mark - MGSpotyViewControllerDataSource

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
        
        UIView *stroke = [[UIView alloc] init];
        stroke.backgroundColor = [UIColor grayColor];
        stroke.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:stroke];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(stroke);
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[stroke(1)]|" options:0 metrics:nil views:views]];
        [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[stroke]|" options:0 metrics:nil views:views]];
    }
    
    cell.textLabel.text = @"Cell";
    
    return cell;
}

@end
