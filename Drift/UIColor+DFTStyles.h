//
//  UIColor+DFTStyles.h
//  Drift
//
//  Created by Thierry Ng on 10/11/16.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DFTStyles)

#pragma mark
#pragma mark - Texts

/**
 gray/blue color for some texts (#fff)

 @return Color #fff
 */
+ (instancetype)dft_slateBlueColor;

#pragma mark
#pragma mark - Backgrounds

/**
 Gray backgrounds

 @return Color #23252B
 */
+ (instancetype)dft_darkGrayColor;

/**
 Light Gray backgrounds
 @return Color #ECECEC
 */
+ (instancetype)dft_lightGrayColor;

/**
 Dark Gray backgrounds
 23252B
 @return Color #40464B
 */
+ (instancetype)dft_grayColor;

/**
 Light red color used in button backgrounds

 @return Color #F3F3F3
 */
+ (instancetype)dft_lightRedColor;

/**
 Dark red color used in button backgrounds
 
 @return Color #852F2F
 */
+ (instancetype)dft_darkRedColor;


/**
 Aquamarine (greenish light blue) color used in button backgrounds

 @return Color #3A3A3A
 */
+ (instancetype)dft_aquamarineColor;

/**
 Salmon (pink-ish light red) color

 @return Color #FE5F5F
 */
+ (instancetype)dft_salmonColor;

@end

NS_ASSUME_NONNULL_END
