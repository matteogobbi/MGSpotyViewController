//
//  MGSpotyViewController.m
//  MGSpotyView
//
//  Created by Matteo Gobbi on 25/06/2014.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import "MGSpotyViewController.h"
#import "UIImageView+LBBlurredImage.h"

CGFloat const kMGOffsetEffects = 40.0;
CGFloat const kMGOffsetBlurEffect = 2.0;

@implementation MGSpotyViewController {
    CGPoint _startContentOffset;
    CGPoint _lastContentOffsetBlurEffect;
    UIImage *_image;
    NSOperationQueue *_operationQueue;
}

- (instancetype)initWithMainImage:(UIImage *)image {
    if(self = [super init]) {
        _image = [image copy];
        _mainImageView = [UIImageView new];
        [_mainImageView setImage:_image];
        _overView = [UIView new];
        _tableView = [UITableView new];
        _operationQueue = [[NSOperationQueue alloc]init];
        _operationQueue.maxConcurrentOperationCount = 1;
    }
    
    return self;
}

- (void)loadView
{
    //Create the view
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [view setBackgroundColor:[UIColor grayColor]];
    
    //Configure the view
    [_mainImageView setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.width)];
    [_mainImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_mainImageView setImageToBlur:_image blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:nil];
    [view addSubview:_mainImageView];
    
    [_overView setFrame:_mainImageView.bounds];
    [_overView setBackgroundColor:[UIColor clearColor]];
    [view addSubview:_overView];
    
    [_tableView setFrame:view.frame];
    [_tableView setShowsVerticalScrollIndicator:NO];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [view addSubview:_tableView];
    
    //[_tableView setContentInset:UIEdgeInsetsMake(20.0, 0, 0, 0)];
    _startContentOffset = _tableView.contentOffset;
    _lastContentOffsetBlurEffect = _startContentOffset;
    
    //Set the view
    self.view = view;
}

#pragma mark - Properties Methods

- (void)setOverView:(UIView *)overView {
    static NSUInteger subviewTag = 100;
    UIView *subView = [overView viewWithTag:subviewTag];
    
    if(![subView isEqual:overView]) {
        [subView removeFromSuperview];
        [_overView addSubview:overView];
    }
}

- (void)setMainImage:(UIImage *)image {
    _image = [image copy];
    [_mainImageView setImageToBlur:_image blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:nil];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y <= _startContentOffset.y) {
        
        //Image size effects
        CGFloat absoluteY = ABS(scrollView.contentOffset.y);
        CGFloat diff = _startContentOffset.y - scrollView.contentOffset.y;
        
        [_mainImageView setFrame:CGRectMake(0.0-diff/2.0, 0.0, _overView.frame.size.width+absoluteY, _overView.frame.size.width+absoluteY)];
        [_overView setFrame:CGRectMake(0.0, 0.0+absoluteY, _overView.frame.size.width, _overView.frame.size.height)];
        
        if(scrollView.contentOffset.y < _startContentOffset.y-kMGOffsetEffects) {
            diff = kMGOffsetEffects;
        }
        
        //Image blur effects
        CGFloat scale = kLBBlurredImageDefaultBlurRadius/kMGOffsetEffects;
        CGFloat newBlur = kLBBlurredImageDefaultBlurRadius - diff*scale;
        
        __block typeof (_overView) overView = _overView;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //Blur effects
            if(ABS(_lastContentOffsetBlurEffect.y-scrollView.contentOffset.y) >= kMGOffsetBlurEffect) {
                _lastContentOffsetBlurEffect = scrollView.contentOffset;
                [_mainImageView setImageToBlur:_image blurRadius:newBlur completionBlock:nil];
            }
            
            //Opacity overView
            CGFloat scale = 1.0/kMGOffsetEffects;
            [overView setAlpha:1.0 - diff*scale];
        });
        
    }
}


#pragma mark - UITableView Delegate & Datasource

/* To override */

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        UIView *transparentView = [[UIView alloc] initWithFrame:_overView.bounds];
        [transparentView setBackgroundColor:[UIColor clearColor]];
        return transparentView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return _overView.frame.size.height;

    return 0.0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 1)
        return 20;
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setBackgroundColor:[UIColor darkGrayColor]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    }
    
    [cell.textLabel setText:@"Cell"];
    
    return cell;
}



@end
