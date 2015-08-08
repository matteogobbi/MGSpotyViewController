//
//  MGSpotyViewControllerProtocol.h
//  MGSpotyView
//
//  Created by Daniele Bogo on 08/08/2015.
//  Copyright (c) 2015 Matteo Gobbi. All rights reserved.
//

@import Foundation;

@class MGSpotyViewController;
@protocol MGSpotyViewControllerProtocol <NSObject>

@required
- (NSInteger)spotyViewController:(MGSpotyViewController *)spotyViewController
     numberOfSectionsInTableView:(UITableView *)tableView;
- (NSInteger)spotyViewController:(MGSpotyViewController *)spotyViewController
                   withTableView:(UITableView *)tableView
           numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)spotyViewController:(MGSpotyViewController *)spotyViewController
                           withTableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (UIView *)spotyViewController:(MGSpotyViewController *)spotyViewController
                  withTableView:(UITableView *)tableView
         viewForHeaderInSection:(NSInteger)section;
- (CGFloat)spotyViewController:(MGSpotyViewController *)spotyViewController
                 withTableView:(UITableView *)tableView
      heightForHeaderInSection:(NSInteger)section;
- (NSString *)spotyViewController:(MGSpotyViewController *)spotyViewController
                    withTableView:(UITableView *)tableView
          titleForHeaderInSection:(NSInteger)section;

@end