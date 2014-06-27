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

The best `overView` to set should be a <b>squared view</b> with <b>transparent background</b>, with the same <b>width</b> and <b>height</b> of `self.overView` which is a <b>flexible container view</b> in the class `MGSpotyViewController`.
<b>Width and height are so equal and they correspond with the width of the screen</b>.

So for a classic iPhone the best frame would be: `{0, 0, 320.0, 320.0}` with flexible width and height.

But to make the size adaptable to the screen starting from the first time, the best thing to do would be <b>set the same bounds of the property</b> `self.overView`.

For this reason you see the line:

``` objective-c
    UIView *view = [[UIView alloc] initWithFrame:self.overView.bounds];
```

The other thing to configure is the `tableView`. The `tableView` is already in the `MGSpotyViewController`, you have just to override the `UITableViewDelegate` and `UITableViewDatasource` methods.

You have just to <b>remember that the section 0 is reserved, so you have to return 1 section in more and managing only your sections (section > 0)</b>:

``` objective-c
    #pragma mark - UITableView Delegate & Datasource

    - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        NSInteger mySections = 1;
        
        return mySections + 1;
    }
    
    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
        if (section == 1)
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
```

And, if you need to manage <b>sections header title</b> or <b>sections header view, for the section 0 you should call the superclass method</b>, like in the example below:

```objective-c

    //Here call the superclass method
    - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        if(section == 0)
            return [super tableView:tableView viewForHeaderInSection:section];
        
        return nil;
    }
    
    - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
        if(section == 1)
            return @"My Section";
        
        return nil;
    }
    
    //Here call the superclass method
    - (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        if(section == 0)
            return [super tableView:tableView heightForHeaderInSection:section];
        
        if(section == 1)
            return 20.0;
        
        return 0.0;
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
