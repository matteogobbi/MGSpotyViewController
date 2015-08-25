//
//  MGSpotyViewControllerDataSource.h
//  MGSpotyView
//
//  Created by Daniele Bogo on 08/08/2015.
//  Copyright (c) 2015 Matteo Gobbi. All rights reserved.
//

@import Foundation;
@import UIKit;

@class MGSpotyViewController;
@protocol MGSpotyViewControllerDataSource <NSObject>

@required
- (NSInteger)spotyViewController:(MGSpotyViewController *)spotyViewController
           numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)spotyViewController:(MGSpotyViewController *)spotyViewController
         cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)numberOfSectionsInSpotyViewController:(MGSpotyViewController *)spotyViewController;

@end