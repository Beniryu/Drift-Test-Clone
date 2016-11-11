//
//  DFTRoundButton.m
//  Drift
//
//  Created by Thierry Ng on 10/11/16.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTRoundedButton.h"
#import "UIColor+DFTStyles.h"

@interface DFTRoundedButton ()

@property (nonatomic) UIColor *customBackgroundHighlightedColor;
@property (nonatomic) UIColor *customBackgroundNormalColor;

@end

@implementation DFTRoundedButton

- (instancetype)init
{
	if (self = [super init])
		[self commonInit];
	return (self);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
		[self commonInit];
	return (self);
}

- (instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
		[self commonInit];
	return (self);
}

- (void)commonInit
{
	self.layer.cornerRadius = self.bounds.size.height / 2.;
	self.layer.shouldRasterize = YES;
	self.layer.rasterizationScale = [[UIScreen mainScreen] scale];

	self.clipsToBounds = YES;
}

- (void)setStyle:(kDFTRoundedButtonStyle)style
{
	_style = style;
	[self configureStyle];
}

- (void)configureStyle
{
	switch (self.style)
	{
		case kDFTRoundedButtonStyleRed:
			[self configureForRedStyle];
			break;
		case kDFTRoundedButtonStyleAqua:
			[self configureForAquaStyle];
			break;
		case kDFTRoundedButtonStyleBordered:
			[self configureForBorderedStyle];
			break;
		default:
			break;
	}
}

- (void)configureForRedStyle
{
	self.customBackgroundNormalColor = [UIColor dft_lightRedColor];
	self.customBackgroundHighlightedColor = [[UIColor dft_lightRedColor] colorWithAlphaComponent:0.5];
	self.backgroundColor = self.customBackgroundNormalColor;
	self.tintColor = [UIColor whiteColor];
	[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)configureForAquaStyle
{
	self.customBackgroundNormalColor = [UIColor dft_aquamarineColor];
	self.customBackgroundHighlightedColor = [[UIColor dft_aquamarineColor] colorWithAlphaComponent:0.5];
	self.backgroundColor = self.customBackgroundNormalColor;
	self.tintColor = [UIColor whiteColor];
	[self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)configureForBorderedStyle
{
	self.customBackgroundNormalColor = [UIColor clearColor];
	self.customBackgroundHighlightedColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];

	self.backgroundColor = self.customBackgroundNormalColor;

	self.layer.borderWidth = 2.;
	self.layer.borderColor = [UIColor dft_slateBlueColor].CGColor;
	self.tintColor = [UIColor dft_slateBlueColor];

	[self setTitleColor:[UIColor dft_slateBlueColor] forState:UIControlStateNormal];
}

@end