//
//  MGViewController.m
//  MGSpotyView
//
//  Created by Matteo Gobbi on 25/06/2014.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import "MGViewController.h"
#import "MGViewControllerDataSource.h"
#import "MGViewControllerDelegate.h"


@interface MGViewController ()

@end



@implementation MGViewController {
    MGViewControllerDelegate *delegate_;
    MGViewControllerDataSource *dataSource_;
}

- (instancetype)initWithMainImage:(UIImage *)image
{
    self = [super initWithMainImage:image tableScrollingType:MGSpotyViewTableScrollingTypeNormal]; //or MGSpotyViewTableScrollingTypeOver
    if (self) {
        dataSource_ = [MGViewControllerDataSource new];
        delegate_ = [MGViewControllerDelegate new];
        
        self.overViewUpFadeOut = YES;
        
        self.blurRadius = 8.f;
        self.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = dataSource_;
    self.delegate = delegate_;
    
    [self setOverView:self.myOverView];
}

- (UIView *)myOverView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.overView.frame.size.width, 250)];
    
    [self mg_addElementOnView:view];
    
    return view;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark - Private methods

- (void)mg_addElementOnView:(UIView *)view
{
    //Add an example imageView
    UIView *itemsContainer = [UIView new];
    itemsContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:itemsContainer];
    
    UIImageView *imageView = [UIImageView new];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    [imageView setImage:[UIImage imageNamed:@"example"]];
    [imageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [imageView.layer setBorderWidth:2.0];
    [imageView.layer setCornerRadius:45.0];
    imageView.userInteractionEnabled = YES;
    [itemsContainer addSubview:imageView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [imageView addGestureRecognizer:tapRecognizer];
    
    
    //Add an example label
    UILabel *lblTitle = [UILabel new];
    lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [lblTitle setText:@"Name Surname"];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:25.0]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setTextColor:[UIColor whiteColor]];
    lblTitle.numberOfLines = 0;
    lblTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [itemsContainer addSubview:lblTitle];
    
    
    //Add an example button
    UIButton *btContact = [UIButton buttonWithType:UIButtonTypeCustom];
    btContact.translatesAutoresizingMaskIntoConstraints = NO;
    [btContact setTitle:@"Contact" forState:UIControlStateNormal];
    [btContact addTarget:self action:@selector(actionContact:) forControlEvents:UIControlEventTouchUpInside];
    btContact.backgroundColor = [UIColor darkGrayColor];
    btContact.titleLabel.font = [UIFont fontWithName:@"Verdana" size:12.0];
    btContact.layer.cornerRadius = 5.0;
    [itemsContainer addSubview:btContact];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:itemsContainer attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:itemsContainer attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    NSDictionary *items = NSDictionaryOfVariableBindings(imageView, lblTitle, btContact);
    [items enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [itemsContainer addConstraint:[NSLayoutConstraint constraintWithItem:obj attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:itemsContainer attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    }];
    
    [itemsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView(90)]" options:0 metrics:nil views:items]];
    [itemsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[btContact(70)]" options:0 metrics:nil views:items]];
    [itemsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[lblTitle]-10-|" options:0 metrics:nil views:items]];
    
    [itemsContainer addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView(90)]-10-[lblTitle]-10-[btContact(30)]|" options:0 metrics:nil views:items]];
}


#pragma mark - Action

- (void)actionContact:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@"Contact" message:@"Pressed button Contact" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}


#pragma mark - Gesture recognizer

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        [[[UIAlertView alloc] initWithTitle:@"Gesture recognizer" message:@"Touched image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}


@end