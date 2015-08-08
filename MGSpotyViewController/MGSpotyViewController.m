//
//  MGSpotyViewController.m
//  MGSpotyView
//
//  Created by Matteo Gobbi on 25/06/2014.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import "MGSpotyViewController.h"
#import "MGSpotyView.h"

#import "UIImageView+LBBlurredImage.h"


CGFloat const kMGOffsetEffects = 40.0;
CGFloat const kMGOffsetBlurEffect = 2.0;

static const CGFloat kMGMaxPercentageOverviewHeightInScreen = 0.67f;


@interface MGSpotyViewController () <UITableViewDelegate, UITableViewDataSource>

/**
 *  Main TableView object
 */
@property (nonatomic, strong) UITableView *tableView;

@end


@implementation MGSpotyViewController {
    CGPoint startContentOffset_;
    CGPoint lastContentOffsetBlurEffect_;
    UIImage *image_;
    NSOperationQueue *operationQueue_;
}


#pragma mark - Life cycle

- (instancetype)initWithMainImage:(UIImage *)image
{
    if(self = [super init]) {
        image_ = [image copy];
        
        _mainImageView = [UIImageView new];
        _mainImageView.image = image_;
        
        _overView = [UIView new];
        
        _tableView = [UITableView new];
        
        operationQueue_ = [[NSOperationQueue alloc]init];
        operationQueue_.maxConcurrentOperationCount = 1;
    }
    
    return self;
}

- (void)loadView
{
    //Create the view
    MGSpotyView *view = [[MGSpotyView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = [UIColor grayColor];
    
    //Configure the view
    CGFloat viewWidth = CGRectGetWidth(view.frame);
    _mainImageView.frame = (CGRect){ 0, 0, viewWidth, MIN(viewWidth, CGRectGetHeight(view.frame)*kMGMaxPercentageOverviewHeightInScreen) };
    _mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_mainImageView setImageToBlur:image_ blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:nil];
    [view addSubview:_mainImageView];
    
    _overView.frame = _mainImageView.bounds;
    _overView.backgroundColor = [UIColor clearColor];
    [view addSubview:_overView];
    
    _tableView.frame = view.frame;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [view addSubview:_tableView];
    
    startContentOffset_ = _tableView.contentOffset;
    lastContentOffsetBlurEffect_ = startContentOffset_;
    
    //Pass references
    view.overview = _overView;
    view.tableView = _tableView;
    
    //Set the view
    self.view = view;
}


#pragma mark - Override accessor methods

- (void)setOverView:(UIView *)overView
{
    static NSUInteger subviewTag = 100;
    UIView *subView = [overView viewWithTag:subviewTag];
    
    if(![subView isEqual:overView]) {
        [subView removeFromSuperview];
        [_overView addSubview:overView];

        for (NSLayoutConstraint *constraint in _overView.constraints) {
            [_overView removeConstraint:constraint];
        }
        
        NSDictionary *views = NSDictionaryOfVariableBindings(overView);
        
        overView.translatesAutoresizingMaskIntoConstraints = NO;
        [_overView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[overView]-0-|" options:0 metrics:nil views:views]];
        [_overView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[overView]-0-|" options:0 metrics:nil views:views]];
    }
}

- (void)setMainImage:(UIImage *)image
{
    image = [self mg_resizeImage:image];
    
    //Copying resized image & setting to blur
    image_ = [image copy];
    [_mainImageView setImageToBlur:image blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:nil];
}


#pragma mark - Public methods

- (void)registerCellClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{
    [_tableView registerClass:cellClass forCellReuseIdentifier:identifier];
}


#pragma mark - Private methods

- (UIImage *)mg_resizeImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(_mainImageView.frame.size);
    [image drawInRect:_mainImageView.bounds];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (void)mg_didRotateToSize:(CGSize)size
{
    [_mainImageView setFrame:CGRectMake(0, 0, size.width, size.width)];
    
    CGRect rect = _mainImageView.frame;
    rect.size.height = MIN(rect.size.height, size.height*kMGMaxPercentageOverviewHeightInScreen);
    [_overView setFrame:rect];
    
    [_tableView setFrame:(CGRect){ 0, 0, size.width, size.height }];
    
    //Clear
    _tableView.contentOffset = (CGPoint){ 0, 0 };
    startContentOffset_ = _tableView.contentOffset;
    lastContentOffsetBlurEffect_ = startContentOffset_;
}


#pragma mark - Rotation

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [self mg_didRotateToSize:(CGSize){ CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds) }];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self mg_didRotateToSize:size];
}


#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y <= startContentOffset_.y) {
        
        //Image size effects
        CGFloat absoluteY = ABS(scrollView.contentOffset.y);
        CGFloat diff = startContentOffset_.y - scrollView.contentOffset.y;
        CGFloat overviewWidth = CGRectGetWidth(_overView.frame);
        CGFloat overviewHeight = CGRectGetHeight(_overView.frame);
        
        _mainImageView.frame = (CGRect){ 0.0-diff/2.0, 0.0, overviewWidth+absoluteY, overviewWidth+absoluteY };
        _overView.frame = (CGRect){ 0.0, 0.0+absoluteY, overviewWidth, overviewHeight };
        
        if(scrollView.contentOffset.y < startContentOffset_.y-kMGOffsetEffects) {
            diff = kMGOffsetEffects;
        }
        
        //Image blur effects
        CGFloat scale = kLBBlurredImageDefaultBlurRadius/kMGOffsetEffects;
        CGFloat newBlur = kLBBlurredImageDefaultBlurRadius - diff*scale;
        
        __block typeof (_overView) overView = _overView;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //Blur effects
            if(ABS(lastContentOffsetBlurEffect_.y-scrollView.contentOffset.y) >= kMGOffsetBlurEffect) {
                lastContentOffsetBlurEffect_ = scrollView.contentOffset;
                [_mainImageView setImageToBlur:image_ blurRadius:newBlur completionBlock:nil];
            }
            
            //Opacity overView
            CGFloat scale = 1.0/kMGOffsetEffects;
            overView.alpha = 1.0 - diff*scale;
        });
        
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource spotyViewController:self numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource spotyViewController:self withTableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource spotyViewController:self withTableView:tableView cellForRowAtIndexPath:indexPath];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(spotyViewController:withTableView:heightForRowAtIndexPath:)]) {
        return [self.delegate spotyViewController:self withTableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(spotyViewController:withTableView:viewForHeaderInSection:)]) {
        return [self.delegate spotyViewController:self withTableView:tableView viewForHeaderInSection:section];
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(spotyViewController:withTableView:heightForHeaderInSection:)]) {
        return [self.delegate spotyViewController:self withTableView:tableView heightForHeaderInSection:section];
    }
    
    return 0.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(spotyViewController:withTableView:titleForHeaderInSection:)]) {
        return [self.delegate spotyViewController:self withTableView:tableView titleForHeaderInSection:section];
    }
    
    return nil;
}


@end