MGSpotyViewController
=====================

Beautiful viewController with a tableView and amazing effects like a viewController in the Spotify app.

<img src="http://www.matteogobbi.it/files-hosting/MGSpotyViewVideo-smaller.gif" alt="MGSpotyViewController Gif" />

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

The best `overView` to create would be a <b>squared view</b> with a <b>transparent background</b>, and with the same <b>size</b> of `self.overView` which is a <b>flexible container view</b> in the class `MGSpotyViewController`.
<b>Width and height should be therefore equal, and they should correspond to the width of the screen</b>.

So for an iPhone 4s, the best frame would be: `{0, 0, 320.0, 320.0}` with flexible width and height.

But to make the size adaptable to the screen without any issue, the best thing would be to <b>set the same bounds of the view</b> `self.overView`:

``` objective-c
UIView *view = [[UIView alloc] initWithFrame:self.overView.bounds];
```

Another thing to configure is the `tableView`. The `tableView` is already in the `MGSpotyViewController`, you have just to set the `MGSpotyViewControllerDataSource` and `MGSpotyViewControllerDelegate` and use their methods.

You must <b>remember that the section 0 is reserved, so you have to return 1 section in more and managing only your sections (section > 0)</b>:

``` objective-c
#pragma mark - MGSpotyViewControllerDataSource

- (NSInteger)spotyViewController:(MGSpotyViewController *)spotyViewController
       numberOfRowsInSection:(NSInteger)section
{
  return 20;
}

- (UITableViewCell *)spotyViewController:(MGSpotyViewController *)spotyViewController
               cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *identifier = @"CellID";
  UITableViewCell *cell = [spotyViewController.tableView dequeueReusableCellWithIdentifier:identifier];

  if(!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
      cell.backgroundColor = [UIColor darkGrayColor];
      cell.textLabel.textColor = [UIColor whiteColor];
  }

  cell.textLabel.text = @"Cell";

  return cell;
}
```

And, if you need to manage <b>sections header title</b> or <b>sections header view, for the section 0 you should use the</b> `MGSpotyViewControllerDelegate` <b>methods</b>, like in the example below:

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

## Contact

Matteo Gobbi

- http://www.matteogobbi.it
- http://github.com/matteogobbi
- http://twitter.com/matteo_gobbi
- https://angel.co/matteo-gobbi
- http://www.linkedin.com/profile/view?id=24211474

## License

MGSpotyViewController is available under the MIT license.
