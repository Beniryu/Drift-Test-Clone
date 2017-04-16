//
//  RadialGradientLayer.h
//  Drift
//
//  Created by Thierry Ng on 15/04/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface DFTRadialGradientLayer : CALayer

@property (nonatomic) CGPoint gradientCenterPoint;

- (instancetype)initWithCenterPoint:(CGPoint)centerPoint;

@end
