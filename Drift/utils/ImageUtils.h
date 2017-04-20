//
//  ImageUtils.h
//  Drift
//
//  Created by Clément Georgel on 10/04/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageUtils : NSObject

+(UIImageView *) roundedBorderImageView:(UIImageView *) imgView;
+(UIImageView *) roundedBorderImageView:(UIImageView *) imgView lineWidth:(double) lineWidth;

@end
