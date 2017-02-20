//
//  DFTGlobalFeedHeaderView.m
//  Drift
//
//  Created by Thierry Ng on 10/01/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTFeedHeaderView.h"

@interface DFTFeedHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;

@end

@implementation DFTFeedHeaderView

- (void)awakeFromNib
{
	[super awakeFromNib];

	CAShapeLayer *border = [CAShapeLayer new];

	border.frame = self.profilePicture.bounds;
	border.lineWidth = 8.;
	border.path = [UIBezierPath bezierPathWithOvalInRect:border.bounds].CGPath;
	border.strokeColor = [UIColor whiteColor].CGColor;
	border.fillColor = [UIColor clearColor].CGColor;
	border.masksToBounds = YES;
	[self.profilePicture.layer addSublayer:border];
	self.profilePicture.clipsToBounds = YES;
	self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2.;
	self.profilePicture.image = [UIImage imageNamed:@"profile_pic_big"];
}

@end
