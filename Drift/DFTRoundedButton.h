//
//  DFTRoundButton.h
//  Drift
//
//  Created by Thierry Ng on 10/11/16.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, kDFTRoundedButtonStyle)
{
	kDFTRoundedButtonStyleRed  = 0,
	kDFTRoundedButtonStyleAqua  = 1,
	kDFTRoundedButtonStyleGold  = 2,
	kDFTRoundedButtonStylePurple  = 3,
	kDFTRoundedButtonStyleBordered = 4
};

@interface DFTRoundedButton : UIButton

@property (nonatomic) kDFTRoundedButtonStyle style;

@end