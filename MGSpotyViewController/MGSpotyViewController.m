//
//  MGSpotyViewController.m
//  MGSpotyView
//
//  Created by Matteo Gobbi on 25/06/2014.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import "MGSpotyViewController.h"
#import "UIImageView+LBBlurredImage.h"

@interface MGSpotyViewController ()

@end

@implementation MGSpotyViewController

- (instancetype)initWithMainImage:(UIImage *)image {
    if(self = [super init]) {
        _mainImageView = [UIImageView new];
        [_mainImageView setImage:image];
        _overView = [UIView new];
        _tableView = [UITableView new];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)loadView
{
    //Create the view
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [view setBackgroundColor:[UIColor grayColor]];
    
    //Configure the view
    [_mainImageView setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.width)];
    [_mainImageView setImageToBlur:_mainImageView.image blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:nil];
    
    [view addSubview:_mainImageView];
    
    [_tableView setFrame:view.frame];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setContentInset:UIEdgeInsetsMake(_mainImageView.frame.size.height, 0, 0, 0)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [view addSubview:_tableView];
    
    [_overView setFrame:CGRectMake(0, -_tableView.contentInset.top, _mainImageView.frame.size.width, _mainImageView.frame.size.height)];
    [_overView setBackgroundColor:[UIColor clearColor]];
    [_tableView addSubview:_overView];
    
    //Set the view
    self.view = view;
}

#pragma mark - UITableView Delegate & Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
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

#pragma mark - Observer

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"contentOffset"]) {
        
    }
}

@end
