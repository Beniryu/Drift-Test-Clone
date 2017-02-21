//
//  DFTFeedCell.m
//  Drift
//
//  Created by Thierry Ng on 26/11/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTFeedCell.h"
#import "DFTDrop.h"

@interface DFTFeedCell ()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundPictureImageView;


@end

@implementation DFTFeedCell

#pragma mark
#pragma mark - Static

- (void)awakeFromNib
{
	[super awakeFromNib];

	[self configureProfilePic];
	[self configureLocationLabel];
}

- (void)configureProfilePic
{
	CAShapeLayer *border = [CAShapeLayer new];

	border.frame = self.profilePictureImageView.bounds;
	border.lineWidth = 4.;
	border.path = [UIBezierPath bezierPathWithOvalInRect:border.bounds].CGPath;
	border.strokeColor = [UIColor cyanColor].CGColor;
	border.fillColor = [UIColor clearColor].CGColor;
	[self.profilePictureImageView.layer addSublayer:border];
	self.profilePictureImageView.clipsToBounds = YES;
	self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.width / 2.;
}

- (void)configureLocationLabel
{
    self.locationLabel.text = @"LONDON";
    self.locationImageView.image = [self.locationImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.locationImageView setTintColor:[UIColor whiteColor]];
}

#pragma mark
#pragma mark - Dynamic

- (void)configureWithDrop:(DFTDrop *)drop
{
	self.backgroundPictureImageView.image = [UIImage imageNamed:@"feed_cell_placeholder"];
	self.profilePictureImageView.image = [UIImage imageNamed:@"feed_cell_profile_pic_placeholder"];
}

@end
