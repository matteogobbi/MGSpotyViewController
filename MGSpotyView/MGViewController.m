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
    self = [super initWithMainImage:image];
    if (self) {
        dataSource_ = [MGViewControllerDataSource new];
        delegate_ = [MGViewControllerDelegate new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSource = dataSource_;
    self.delegate = delegate_;
    
    self.overView.frame = (CGRect){ self.overView.frame.origin.x, self.overView.frame.origin.y, CGRectGetWidth(self.view.frame), 400 };
    self.mainImageView.frame = self.overView.frame;
    
    [self setOverView:self.myOverView];
}

- (UIView *)myOverView
{
    UIView *view = [[UIView alloc] initWithFrame:self.overView.bounds];
    
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
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:imageView];
    [view addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1
                                                      constant:0]];
    
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1
                                                           constant:100.0]];
    
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1
                                                           constant:100.0]];
    
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    [imageView setImage:[UIImage imageNamed:@"example"]];
    [imageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [imageView.layer setBorderWidth:2.0];
    [imageView.layer setCornerRadius:50.0];
    imageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [imageView addGestureRecognizer:tapRecognizer];
    
    
    //Add an example label
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:lblTitle];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:lblTitle
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:lblTitle
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:imageView
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:10.0]];
    
    [lblTitle addConstraint:[NSLayoutConstraint constraintWithItem:lblTitle
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1
                                                          constant:30.0]];
    
    [lblTitle addConstraint:[NSLayoutConstraint constraintWithItem:lblTitle
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1
                                                          constant:240.0]];
    
    [lblTitle setText:@"Name Surname"];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:25.0]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setTextColor:[UIColor whiteColor]];
    
    
    //Add an example button
    UIButton *btContact = [[UIButton alloc] initWithFrame:CGRectZero];
    btContact.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:btContact];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:btContact
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:view
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    
    [view addConstraint:[NSLayoutConstraint constraintWithItem:btContact
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:lblTitle
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:10.0]];
    
    [btContact addConstraint:[NSLayoutConstraint constraintWithItem:btContact
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1
                                                           constant:35.0]];
    
    [btContact addConstraint:[NSLayoutConstraint constraintWithItem:btContact
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1
                                                           constant:70.0]];
    
    [btContact setTitle:@"Contact" forState:UIControlStateNormal];
    [btContact addTarget:self action:@selector(actionContact:) forControlEvents:UIControlEventTouchUpInside];
    btContact.backgroundColor = [UIColor darkGrayColor];
    btContact.titleLabel.font = [UIFont fontWithName:@"Verdana" size:12.0];
    btContact.layer.cornerRadius = 5.0;
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
