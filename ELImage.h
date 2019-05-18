//
//  ELImage.h
//
//  Created by tasue on 2019/05/18.
//  Updated by tasue on 2019/05/18.
//

#import <UIKit/UIKit.h>

@interface ELImage : NSObject

#pragma mark -
#pragma mark UIImage

+ (UIImage *)getImageWithImageName:(NSString *)imageName
                   isFillColor:(BOOL)isFillColorMode;

+ (UIImage *)copyImage:(UIImage*)image;

+ (UIImage *)resizeImageWithImageName:(NSString *)imageName
                           resizeSize:(CGSize)resizeSize
                      isFillColor:(BOOL)isFillColorMode;

+ (UIImage *)captureView:(UIView *)view;

+ (UIImage *)trimCenterImage:(UIImage*)image trimSize:(CGSize)trimSize;

+ (UIImage *)composeImagesWithImages:(NSArray *)images
                          imageRects:(NSArray *)imageRects
                          canvasSize:(CGSize)canvasSize;

+ (UIImage *)exchangeViewToImage:(UIView *)view;

#pragma mark -
#pragma mark UIImageView

+ (UIImageView *)initImageViewWithImageName:(NSString *)imageName
                                  imageRect:(CGRect)imageRect;

+ (UIImageView *)initImageViewWithImageName:(NSString *)imageName
                                  imageRect:(CGRect)imageRect
                                 imageColor:(UIColor *)imageColor;

+ (UIImageView *)copyImageView:(UIImageView *)view;

@end
