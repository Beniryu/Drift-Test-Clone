//
//  UIColor+DFTStyles.m
//  Drift
//
//  Created by Thierry Ng on 10/11/16.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "UIColor+DFTStyles.h"

@implementation UIColor (DFTStyles)

#pragma mark
#pragma mark - Texts

+ (instancetype)dft_slateBlueColor
{
	return ([UIColor colorWithRed:0.60 green:0.69 blue:0.79 alpha:1.0]);
}

#pragma mark
#pragma mark - Backgrounds

+ (instancetype)dft_lightRedColor
{
	return ([UIColor colorWithRed:1.00 green:0.38 blue:0.38 alpha:1.0]);
}

+(instancetype)dft_aquamarineColor
{
	return ([UIColor colorWithRed:0.49 green:0.87 blue:0.82 alpha:1.0]);
}

@end
