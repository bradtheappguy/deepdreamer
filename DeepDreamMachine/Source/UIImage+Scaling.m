//
//  UIImage+Scaling.m
//  Impressionism
//
//  Created by Brad on 5/3/14.
//  Copyright (c) 2014 Jet. All rights reserved.
//


//Lifted from http://stackoverflow.com/a/1262395/42323

#import "UIImage+Scaling.h"
#import <ImageIO/ImageIO.h>

static inline double radians (double degrees) {return degrees * M_PI/180;}


@implementation UIImage (Scaling)

-(UIImage*)imageByScalingToSize:(CGSize)targetSize
{
	UIImage* sourceImage = self;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;

	CGImageRef imageRef = [sourceImage CGImage];
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);

	if (bitmapInfo == kCGImageAlphaNone) {
		bitmapInfo = kCGImageAlphaNoneSkipLast;
	}

	CGContextRef bitmap;

	if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
   	bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), targetWidth*4, colorSpaceInfo, bitmapInfo);

	} else {
		bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), targetHeight*4, colorSpaceInfo, bitmapInfo);

	}

	if (sourceImage.imageOrientation == UIImageOrientationLeft) {
		CGContextRotateCTM (bitmap, radians(90));
		CGContextTranslateCTM (bitmap, 0, -targetHeight);

	} else if (sourceImage.imageOrientation == UIImageOrientationRight) {
		CGContextRotateCTM (bitmap, radians(-90));
		CGContextTranslateCTM (bitmap, -targetWidth, 0);

	} else if (sourceImage.imageOrientation == UIImageOrientationUp) {
		// NOTHING
	} else if (sourceImage.imageOrientation == UIImageOrientationDown) {
		CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
		CGContextRotateCTM (bitmap, radians(-180.));
	}

	CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage* newImage = [UIImage imageWithCGImage:ref];

	CGContextRelease(bitmap);
	CGImageRelease(ref);
  
	return newImage; 
}

- (UIImage *) scaleToSize: (CGSize)size
{
  // Scalling selected image to targeted size
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast);
  CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));

  if(self.imageOrientation == UIImageOrientationRight)
  {
  CGContextRotateCTM(context, -M_PI_2);
  CGContextTranslateCTM(context, -size.height, 0.0f);
  CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), self.CGImage);
  }
  else
  CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), self.CGImage);

  CGImageRef scaledImage=CGBitmapContextCreateImage(context);

  CGColorSpaceRelease(colorSpace);
  CGContextRelease(context);

  UIImage *image = [UIImage imageWithCGImage: scaledImage];

  CGImageRelease(scaledImage);

  return image;
}

- (UIImage *) scaleProportionalToMaxDimension: (CGFloat)dimension
{
 /* CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)url, NULL);
  if (!imageSource)
  return nil;

  CFDictionaryRef options = (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                       (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailWithTransform,
                                                       (id)kCFBooleanTrue, (id)kCGImageSourceCreateThumbnailFromImageIfAbsent,
                                                       (id)[NSNumber numberWithFloat:max], (id)kCGImageSourceThumbnailMaxPixelSize,
                                                       nil];
  CGImageRef imgRef = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options);

  UIImage* scaled = [UIImage imageWithCGImage:imgRef];


  self.originalImage = [UIImage imageWithContentsOfFile:url.path];

  scaled = self.originalImage;

  CGImageRelease(imgRef);
  CFRelease(imageSource);

  return scaled;
*/


  CGSize size1;
  if(self.size.width>self.size.height)
  {
  NSLog(@"LandScape");
  size1=CGSizeMake(dimension,(self.size.height/self.size.width)*dimension);
  }
  else
  {
  NSLog(@"Potrait");
  size1=CGSizeMake((self.size.width/self.size.height)*dimension,dimension);
  }

  return [self scaleToSize:size1];
}

@end
