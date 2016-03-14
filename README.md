MGSpotyViewController
=====================

Beautiful viewController with a tableView and amazing effects like a viewController in the Spotify app.
With MGSpotyViewController you can implement several layouts like these:

<img src="http://www.matteogobbi.it/files-hosting/MGSpotyViewVideo-smaller.gif" alt="MGSpotyViewController Gif" width=280 />
<img src="https://github.com/matteogobbi/MGSpotyViewController/blob/master/GIFs%20and%20Videos/spotiviewcontroller.gif" alt="MGSpotyViewController Gif" width=280 />
<img src="https://github.com/matteogobbi/MGSpotyViewController/blob/master/GIFs%20and%20Videos/example2.gif" alt="MGSpotyViewController Gif" width=280 />

## Info

This code must be used under ARC.
If your code doesn't use ARC you can [mark this source with the compiler flag](http://www.codeography.com/2011/10/10/making-arc-and-non-arc-play-nice.html) `-fobjc-arc`

## Example Usage

In the package is included an example to use this class.

The best thing to do, is <b>to extend</b> the `MGSpotyViewController`.
In the package see the class `MGViewController.{h,m}` as example.

Here the explanation:

Init is easy. You have just to pass the main image for the blur effect:

``` objective-c
MGViewController *spotyViewController = [[MGViewController alloc] initWithMainImage:[UIImage imageNamed:@"example"]];
```

`MGViewController` extends `MGSpotyViewController`:

``` objective-c
//
//  MGViewController.h
//  MGSpotyView
//
//  Created by Matteo Gobbi on 25/06/2014.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import "MGSpotyViewController.h"

@interface MGViewController : MGSpotyViewController


@end
```

Set the `delegate` and the `datasource` of the `MGSpotyViewController`:

```objective-c
- (instancetype)init
{
    if (self = [super init]) {
        self.dataSource = myDataSource; //Or self
        self.delegate = myDelegate; //Or self
    }
    
    return self;
}
```

In the implementation file, first of all you should set the `overView`. The `overView` is basically <b>the header view which remains over the blur image</b>:

``` objective-c
- (void)viewDidLoad {
    [self setOverView:self.myOverView];
}


//This is just an example view created by code, but you can return any type of view.
- (UIView *)myOverView {
    UIView *view = [[UIView alloc] initWithFrame:self.overView.bounds];

    //Add an example imageView
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.center.x-50.0, view.center.y-60.0, 100.0, 100.0)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    [imageView setImage:[UIImage imageNamed:@"example"]];
    [imageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [imageView.layer setBorderWidth:2.0];
    [imageView.layer setCornerRadius:imageView.frame.size.width/2.0];

    //Add an example label
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(view.center.x-120.0, view.center.y+50.0, 240.0, 50.0)];
    [lblTitle setText:@"Name Surname"];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:25.0]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setTextColor:[UIColor whiteColor]];


    [view addSubview:imageView];
    [view addSubview:lblTitle];

    return view;
}
```

Another thing to configure is the `tableView`. The `tableView` is already in the `MGSpotyViewController`, you have just to set the `MGSpotyViewControllerDataSource` and `MGSpotyViewControllerDelegate` and use their methods.

You must <b>remember that the section 0 is reserved</b>, so even if you will return 1 section, your delegate will get called for section number 1, not 0. Basically for sections the counter doesn't start from 0 but from 1:

``` objective-c
#pragma mark - MGSpotyViewControllerDataSource

- (NSInteger)numberOfSectionsInSpotyViewController:(MGSpotyViewController *)spotyViewController
{
    return 1;
}

- (NSInteger)spotyViewController:(MGSpotyViewController *)spotyViewController
       numberOfRowsInSection:(NSInteger)section
{
  return 20;
}

- (UITableViewCell *)spotyViewController:(MGSpotyViewController *)spotyViewController
                               tableView:(UITableView *)tableView
                   cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // IndexPath is 1-1, 1-2, 1-3 etc.
  
  UITableViewCell *cell = // Your cell initialisation

  return cell;
}
```

And, if you need to manage <b>sections header title</b> or <b>sections header view</b>:

```objective-c
#pragma mark - MGSpotyViewControllerDelegate

- (CGFloat)spotyViewController:(MGSpotyViewController *)spotyViewController
  heightForHeaderInSection:(NSInteger)section
{
  return 20.0;
}

- (NSString *)spotyViewController:(MGSpotyViewController *)spotyViewController
      titleForHeaderInSection:(NSInteger)section
{
  return @"My Section";
}
```

## Customisations

There are a bunch of properties you can play with to get the best result for your needs:

``` objective-c
/**
 *  The tint color on top of the blur. When alpha is 1.0 
 *  you'll not be able to see the image behind.
 */
@property (nonatomic, strong) UIColor *tintColor;

/**
 *  Indicate if the overView has to fade out when scrolling up
 *  Default value: NO
 */
@property (atomic) BOOL overViewFadeOut;

/**
 *  Indicate if the main image has to get unblurred when scrolling down
 *  Default value: YES
 */
@property (atomic) BOOL shouldUnblur;

/**
 *  Indicate if the overView height is resized automatically when the
 *  device is rotated (ie when the height of the interface change)
 *  Default value: YES
 */
@property (atomic) BOOL flexibleOverviewHeight;

/**
 *  Set the value of the blur radius.
 *  Default value: 20.0
 */
@property (nonatomic) CGFloat blurRadius;
```

And also an initialiser which takes in input a scrolling type which are essentially the 2 kinds of scrolling you see in the previous examples:

```objective-c
- (instancetype)initWithMainImage:(UIImage *)image tableScrollingType:(MGSpotyViewTableScrollingType)scrollingType;
```

## Contact

Matteo Gobbi

- http://www.matteogobbi.it
- http://github.com/matteogobbi
- http://twitter.com/matteo_gobbi
- https://angel.co/matteo-gobbi
- http://www.linkedin.com/profile/view?id=24211474

## License

MGSpotyViewController is available under the MIT license.
