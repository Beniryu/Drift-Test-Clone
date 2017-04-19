//
//  ImageUtils.m
//  Drift
//
//  Created by Clément Georgel on 10/04/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "ImageUtils.h"

@implementation ImageUtils

+(UIImageView *) roundedBorderImageView:(UIImageView *) imgView
{
    return [ImageUtils roundedBorderImageView:imgView lineWidth:4.];
}

+(UIImageView *) roundedBorderImageView:(UIImageView *) imgView lineWidth:(double) lineWidth
{
    CAShapeLayer *border = [CAShapeLayer new];
    
    border.frame = imgView.bounds;
    border.lineWidth = lineWidth;
    border.path = [UIBezierPath bezierPathWithOvalInRect:border.bounds].CGPath;
    border.strokeColor = [UIColor whiteColor].CGColor;
    border.fillColor = [UIColor clearColor].CGColor;
    [imgView.layer addSublayer:border];
    imgView.clipsToBounds = YES;
    imgView.layer.cornerRadius = imgView.frame.size.width / 2.;
    return imgView;
}

@end
