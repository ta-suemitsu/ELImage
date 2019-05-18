//
//  ELImage.m
//
//  Created by tasue on 2019/05/18.
//  Updated by tasue on 2019/05/18.
//

#import "ELImage.h"

@implementation ELImage

#pragma mark -
#pragma mark UIImage

/**
 Get UIImage with image's name and isFillColorMode.
 
 @param imageName Image name(ex. example.jpg, example.png)
 @param isFillColor In case of filling a image by a color, specify true. This argument use with UIImageView.
 @return Getted image
 */
+ (UIImage *)getImageWithImageName:(NSString *)imageName
                       isFillColor:(BOOL)isFillColor {
    
    if(isFillColor == YES) {
        return [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    } else {
        return [UIImage imageNamed:imageName];
    }
}

/**
 Copy image.
 
 @param image Image to copy
 @return Copied image
 */
+ (UIImage *)copyImage:(UIImage*)image {
    
    return [UIImage imageWithCGImage:image.CGImage];
}

/**
 Resize image.
 
 @param imageName Image name(ex. example.jpg, example.png)
 @param imageSize Image size to resize
 @param isFillColor In case of filling a image by a color, specify true. This argument use with UIImageView.
 @return Resized image
 */
+ (UIImage *)resizeImageWithImageName:(NSString *)imageName
                           resizeSize:(CGSize)resizeSize
                          isFillColor:(BOOL)isFillColor {
    
    UIImage *image = [ELImage getImageWithImageName:imageName isFillColor:isFillColor];
    
    UIGraphicsBeginImageContextWithOptions(resizeSize, NO, 0);
    [image drawInRect:CGRectMake(0, 0, resizeSize.width, resizeSize.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(isFillColor == YES) {
        return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    } else {
        return image;
    }
}

/**
 Capture view.
 
 @param view View to capture
 @return Captured image
 */
+ (UIImage *)captureView:(UIView *)view {
    
    CGRect rect = view.frame;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextFillRect(ctx, rect);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *capture = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return capture;
}

/**
 Trim center image.
 
 @param image Image to trim
 @param trimSize Image size to trim
 @return Trimmed image
 */
+ (UIImage *)trimCenterImage:(UIImage*)image
                    trimSize:(CGSize)trimSize {
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CGSize imageSize = CGSizeMake(image.size.width * image.scale,
                                  image.size.height * image.scale);
    
    CGSize realTrimSize = CGSizeMake(trimSize.width * [UIScreen mainScreen].scale,
                                     trimSize.height * [UIScreen mainScreen].scale);
    
    CIImage *filteredImage = [ciImage imageByCroppingToRect:CGRectMake(imageSize.width/2.f - realTrimSize.width/2.f,
                                                                       imageSize.height/2.f - realTrimSize.height/2.f,
                                                                       realTrimSize.width,
                                                                       realTrimSize.height)];
    // Exchange UIImage
    UIImage *exchangeImage = [[UIImage alloc] initWithCIImage:filteredImage
                                                        scale:[UIScreen mainScreen].scale
                                                  orientation:UIImageOrientationUp];
    
    UIGraphicsBeginImageContextWithOptions(trimSize, NO, 0);
    [exchangeImage drawInRect:CGRectMake(
                                         (trimSize.width - exchangeImage.size.width) / 2,
                                         (trimSize.height - exchangeImage.size.height) / 2,
                                         exchangeImage.size.width,
                                         exchangeImage.size.height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

/**
 Compose images.
 
 @param images Images to compose. The elements in the array are UIImage.
 @param imageRects Rects of image for compose. The elements in the array are NSValue.
 @param canvasSize Canvas size to compose images
 @return Composed image
 */
+ (UIImage *)composeImagesWithImages:(NSArray *)images
                          imageRects:(NSArray *)imageRects
                          canvasSize:(CGSize)canvasSize {
    
    UIImage *copositeImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(canvasSize, NO, 0);
    
    for(NSInteger index = 0; index < images.count; index++) {
        UIImage *image = images[index];
        NSValue *rectValue = imageRects[index];
        CGRect rect = rectValue.CGRectValue;
        [image drawInRect:rect];
    }
    
    copositeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copositeImage;
}

/**
 Exchange UIView to UIImage.
 
 @param view UIView
 @return Exchanged image.
 */
+ (UIImage *)exchangeViewToImage:(UIView *)view {
    
    CGRect rect = view.bounds;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark -
#pragma mark UIImageView

/**
 Initialize UIImageView with image name.
 
 @param imageName Image name(ex. example.jpg, example.png)
 @param imageRect Image rect
 @return UIImageView
 */
+ (UIImageView *)initImageViewWithImageName:(NSString *)imageName
                                  imageRect:(CGRect)imageRect
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self getImageWithImageName:imageName
                                                                                isFillColor:NO]];
    imageView.frame = imageRect;
    
    return imageView;
}

/**
 Initialize UIImageView with image name. Image of UIImageView is fill by image color.
 
 @param imageName Image name(ex. example.jpg, example.png)
 @param imageRect Image rect
 @param imageColor Image color
 @return UIImageView
 */
+ (UIImageView *)initImageViewWithImageName:(NSString *)imageName
                                  imageRect:(CGRect)imageRect
                                 imageColor:(UIColor *)imageColor {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self getImageWithImageName:imageName
                                                                                isFillColor:YES]];
    imageView.frame = imageRect;
    imageView.tintColor = imageColor;
    
    return imageView;
}

/**
 Copy UIImageView.
 
 @param imageView UIImageView
 @return Copied UIImageView
 */
+ (UIImageView *)copyImageView:(UIImageView *)imageView {
    
    UIGraphicsBeginImageContextWithOptions(imageView.frame.size, NO, 0);
    
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [[UIImageView alloc] initWithImage:viewImage];
}

@end
