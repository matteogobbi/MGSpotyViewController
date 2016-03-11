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

static const CGFloat kMGMaxPercentageOverviewHeightInScreen = 0.60f;
static const NSUInteger kMGOverviewMainSubviewTag = 100;


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
    MGSpotyViewTableScrollingType scrollingType_;
}


#pragma mark - Life cycle

- (instancetype)initWithMainImage:(UIImage *)image
{
    return [self initWithMainImage:image tableScrollingType:MGSpotyViewTableScrollingTypeOver];
}

- (instancetype)initWithMainImage:(UIImage *)image tableScrollingType:(MGSpotyViewTableScrollingType)scrollingType
{
    if(self = [super init]) {
        image_ = [image copy];
        scrollingType_ = scrollingType;
        
        _mainImageView = [UIImageView new];
        _mainImageView.image = image_;
        
        _overView = [UIView new];
        
        _tableView = [UITableView new];
        
        _shouldUnblur = YES;
        _flexibleOverviewHeight = YES;
        
        operationQueue_ = [[NSOperationQueue alloc]init];
        operationQueue_.maxConcurrentOperationCount = 1;
        
        _overViewDownFadeOut = YES;
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
    _mainImageView.clipsToBounds = YES;
    
    if (image_) {
        [_mainImageView setImageToBlur:image_ blurRadius:kLBBlurredImageDefaultBlurRadius tintColor:_tintColor completionBlock:nil];
    }
    
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
    _overView.frame = overView.frame;

    UIView *subView = [_overView viewWithTag:kMGOverviewMainSubviewTag];
    
    if(![subView isEqual:overView]) {
        [subView removeFromSuperview];
        [_overView addSubview:overView];
        overView.tag = kMGOverviewMainSubviewTag;
        
        for (NSLayoutConstraint *constraint in _overView.constraints) {
            [_overView removeConstraint:constraint];
        }
        
        NSDictionary *views = NSDictionaryOfVariableBindings(overView);
        
        overView.translatesAutoresizingMaskIntoConstraints = NO;
        [_overView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[overView]-0-|" options:0 metrics:nil views:views]];
        [_overView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[overView]-0-|" options:0 metrics:nil views:views]];
    }
    
    [self mg_applyEffectsConsideringScrollViewContentOffset:_tableView.contentOffset];
}

- (void)setMainImage:(UIImage *)image
{
    BOOL imageIsContained = CGRectContainsRect(_mainImageView.bounds, (CGRect){ 0, 0, image.size.width, image.size.height });
    if (!imageIsContained) {
        image = [self mg_resizeImage:image];
    }
    
    //Copying resized image & setting to blur
    image_ = [image copy];
    
    // If image is nil means that the context was nil
    if (image) {
        [_mainImageView setImageToBlur:image blurRadius:kLBBlurredImageDefaultBlurRadius tintColor:_tintColor completionBlock:nil];
        [self mg_applyEffectsConsideringScrollViewContentOffset:_tableView.contentOffset];
    }
}

- (void)setBlurRadius:(CGFloat)blurRadius
{
    kLBBlurredImageDefaultBlurRadius = blurRadius;
}

- (CGFloat)blurRadius
{
    return kLBBlurredImageDefaultBlurRadius;
}


#pragma mark - Versioning (deprecated)

- (void)setOverViewFadeOut:(BOOL)overViewFadeOut
{
    _overViewUpFadeOut = overViewFadeOut;
}

- (BOOL)overViewFadeOut
{
    return _overViewUpFadeOut;
}


#pragma mark - Public methods

- (void)registerCellClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{
    [_tableView registerClass:cellClass forCellReuseIdentifier:identifier];
}


#pragma mark - Private methods

- (UIImage *)mg_resizeImage:(UIImage *)image
{
    CGSize sizeBeingScaledTo = [self mg_sizeAspectFill:_mainImageView.frame.size aspectRatio:image.size];
    
    UIGraphicsBeginImageContext(_mainImageView.frame.size);
    [image drawInRect:(CGRect){ 0, 0, sizeBeingScaledTo.width, sizeBeingScaledTo.height }];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (CGSize)mg_sizeAspectFill:(CGSize)minimumSize aspectRatio:(CGSize)aspectRatio
{
    CGFloat mW = minimumSize.width / aspectRatio.width;
    CGFloat mH = minimumSize.height / aspectRatio.height;
    if(mH > mW) {
        minimumSize.width = minimumSize.height / aspectRatio.height * aspectRatio.width;
    } else if( mW > mH ) {
        minimumSize.height = minimumSize.width / aspectRatio.width * aspectRatio.height;
    }
    return minimumSize;
}

- (void)mg_didRotateToSize:(CGSize)size
{
    CGRect rect = _overView.frame;
    rect.size.width = size.width;
    
    if (_flexibleOverviewHeight) {
        CGFloat newH = MIN(size.height*kMGMaxPercentageOverviewHeightInScreen, size.width);
        rect.size.height = newH;
    }
    
    _overView.frame = rect;
    _mainImageView.frame = rect;
    _tableView.frame = (CGRect){ 0, 0, size.width, size.height };
    
    //Clear
    _tableView.contentOffset = (CGPoint){ 0, 0 };
    startContentOffset_ = _tableView.contentOffset;
    lastContentOffsetBlurEffect_ = startContentOffset_;
}

- (void)mg_applyEffectsConsideringScrollViewContentOffset:(CGPoint)contentOffset
{
    //Image size effects
    CGFloat absoluteY = ABS(contentOffset.y);
    CGFloat overviewWidth = CGRectGetWidth(_overView.frame);
    CGFloat overviewHeight = CGRectGetHeight(_overView.frame);
    
    __block UIView *overviewMainSubview = [_overView viewWithTag:kMGOverviewMainSubviewTag];;
    
    if(contentOffset.y <= startContentOffset_.y) {
        _overView.frame = (CGRect){ 0.0, absoluteY, overviewWidth, overviewHeight };
        
        CGFloat diff = startContentOffset_.y - contentOffset.y;
        CGFloat newH = contentOffset.y <= 0 ? overviewHeight + absoluteY : overviewHeight;
        CGFloat newW = contentOffset.y <= 0 ? (newH * overviewWidth) / newH : overviewWidth;
        
        _mainImageView.frame = (CGRect){ 0.0, 0.0, newW, newH };
        
        if(contentOffset.y < startContentOffset_.y-kMGOffsetEffects) {
            diff = kMGOffsetEffects;
        }
        
        //Image blur effects
        CGFloat scale = kLBBlurredImageDefaultBlurRadius/kMGOffsetEffects;
        CGFloat newBlur = kLBBlurredImageDefaultBlurRadius - diff*scale;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //Blur effects
            if (_shouldUnblur) {
                if(ABS(lastContentOffsetBlurEffect_.y-contentOffset.y) >= kMGOffsetBlurEffect) {
                    lastContentOffsetBlurEffect_ = contentOffset;
                    [_mainImageView setImageToBlur:image_ blurRadius:newBlur tintColor:_tintColor completionBlock:nil];
                }
            }
            
            //Opacity overView
            if (_overViewDownFadeOut) {
                CGFloat scale = 1.0/kMGOffsetEffects;
                overviewMainSubview.alpha = 1.0 - diff*scale;
            }
        });
    } else if (scrollingType_ == MGSpotyViewTableScrollingTypeNormal) {
        _overView.frame = (CGRect){ 0.0, -absoluteY, overviewWidth, overviewHeight };
        
        if (_overViewUpFadeOut) {
            CGFloat diff = startContentOffset_.y + contentOffset.y;
            dispatch_async(dispatch_get_main_queue(), ^{
                //Opacity overView
                CGFloat scale = 1.0/(overviewMainSubview.frame.size.height/2.0);
                overviewMainSubview.alpha = 1.0 - diff*scale;
            });
        }
    }
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
    [self mg_applyEffectsConsideringScrollViewContentOffset:scrollView.contentOffset];
    
    if ([self.delegate respondsToSelector:@selector(spotyViewController:scrollViewDidScroll:)]) {
        [self.delegate spotyViewController:self scrollViewDidScroll:scrollView];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInSpotyViewController:)]) {
        return [self.dataSource numberOfSectionsInSpotyViewController:self] + 1;
    }
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section != 0) {
        return [self.dataSource spotyViewController:self numberOfRowsInSection:section];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.dataSource spotyViewController:self tableView:tableView cellForRowAtIndexPath:indexPath];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(spotyViewController:heightForRowAtIndexPath:)]) {
        return [self.delegate spotyViewController:self heightForRowAtIndexPath:indexPath];
    }
    
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        UIView *transparentView = [[UIView alloc] initWithFrame:self.overView.bounds];
        [transparentView setBackgroundColor:[UIColor clearColor]];
        return transparentView;
    } else if ([self.delegate respondsToSelector:@selector(spotyViewController:viewForHeaderInSection:)]) {
        return [self.delegate spotyViewController:self viewForHeaderInSection:section];
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGRectGetHeight(self.overView.frame);
    } else if (section != 0 && [self.delegate respondsToSelector:@selector(spotyViewController:heightForHeaderInSection:)]) {
        return [self.delegate spotyViewController:self heightForHeaderInSection:section];
    }
    
    return 0.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section != 0 && [self.delegate respondsToSelector:@selector(spotyViewController:titleForHeaderInSection:)]) {
        return [self.delegate spotyViewController:self titleForHeaderInSection:section];
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section > 0) {
        if ([self.delegate respondsToSelector:@selector(spotyViewController:didSelectRowAtIndexPath:)]) {
            [self.delegate spotyViewController:self didSelectRowAtIndexPath:indexPath];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section > 0) {
        if ([self.delegate respondsToSelector:@selector(spotyViewController:didDeselectRowAtIndexPath:)]) {
            [self.delegate spotyViewController:self didDeselectRowAtIndexPath:indexPath];
        }
    }
}


@end
