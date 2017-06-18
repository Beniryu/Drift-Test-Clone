//
//  RadialGradientLayer.m
//  Drift
//
//  Created by Thierry Ng on 15/04/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTRadialGradientLayer.h"

@interface DFTRadialGradientLayer ()

@property NSArray<NSNumber *> *colors;

@end

@implementation DFTRadialGradientLayer

- (instancetype)initWithCenterPoint:(CGPoint)centerPoint
{
	if (self = [super init])
	{
		self.gradientCenterPoint = centerPoint;
		[self setNeedsDisplay];
		self.colors = @[@0, @0, @0, @0, @0.08, @0.09, @0.11, @0.7];
	}
	return (self);
}

- (instancetype)initWithCenterPoint:(CGPoint)centerPoint andColors:(NSArray<NSNumber *> *)colors
{
	if (self = [super init])
	{
		self.gradientCenterPoint = centerPoint;
		self.colors = colors;
		[self setNeedsDisplay];
	}
	return (self);
}

- (void)drawInContext:(CGContextRef)ctx
{
	size_t gradLocationsNb = 2;
	CGFloat gradLocations[2] = {0.0f, 1.0f};
	CGFloat gradColors[8] =
	{
		self.colors[0].floatValue,
		self.colors[1].floatValue,
		self.colors[2].floatValue,
		self.colors[3].floatValue,
		self.colors[4].floatValue,
		self.colors[5].floatValue,
		self.colors[6].floatValue,
		self.colors[7].floatValue
	};
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNb);

	CGColorSpaceRelease(colorSpace);

	CGPoint gradCenter = CGPointMake(self.gradientCenterPoint.x, self.gradientCenterPoint.y);
	float gradRadius = MIN(self.bounds.size.width, self.bounds.size.height);

	CGContextDrawRadialGradient(ctx, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
	CGGradientRelease(gradient);
}

@end
