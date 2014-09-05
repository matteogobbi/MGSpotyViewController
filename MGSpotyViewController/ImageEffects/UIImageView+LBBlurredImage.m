//
//  UIImageView+LBBlurredImage.m
//  LBBlurredImage
//
//  Created by Luca Bernardi on 11/11/12.
//  Copyright (c) 2012 Luca Bernardi. All rights reserved.
//

#import "UIImageView+LBBlurredImage.h"
#import "UIImage+ImageEffects.h"

CGFloat const kLBBlurredImageDefaultBlurRadius            = 20.0;
CGFloat const kLBBlurredImageDefaultSaturationDeltaFactor = 1.0;

@implementation UIImageView (LBBlurredImage) 

#pragma mark - LBBlurredImage Additions

- (void)setImageToBlur:(UIImage *)image
               onQueue:(NSOperationQueue *)queue
       completionBlock:(LBBlurredImageCompletionBlock)completion
{
    [self setImageToBlur:image
              blurRadius:kLBBlurredImageDefaultBlurRadius
                 onQueue:queue completionBlock:completion];

}

- (void)setImageToBlur:(UIImage *)image
            blurRadius:(CGFloat)blurRadius
               onQueue:(NSOperationQueue *)queue
       completionBlock:(LBBlurredImageCompletionBlock) completion
{
    NSParameterAssert(image);
    NSParameterAssert(blurRadius >= 0);
    
    [queue addOperationWithBlock:^{
        UIImage *blurredImage = [image applyBlurWithRadius:blurRadius
                                                 tintColor:nil
                                     saturationDeltaFactor:kLBBlurredImageDefaultSaturationDeltaFactor
                                                 maskImage:nil];
        
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            self.image = blurredImage;
            if(completion) {
                completion();
            }
        }];
    }];
}

@end
