//
//  DFTFeedCell.m
//  Drift
//
//  Created by Thierry Ng on 26/11/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTFeedCell.h"
#import "DFTDrop.h"

#import <UIImageView+WebCache.h>

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
	CAGradientLayer *gradientLayer = [CAGradientLayer layer];
	gradientLayer.frame = self.backgroundPictureImageView.layer.bounds;

	gradientLayer.colors = [NSArray arrayWithObjects:
							(id)[UIColor colorWithWhite:0.0f alpha:0.3f].CGColor,
							(id)[UIColor colorWithWhite:0.0f alpha:0.6f].CGColor,
							nil];

	gradientLayer.locations = [NSArray arrayWithObjects:
							   [NSNumber numberWithFloat:0.0f],
							   [NSNumber numberWithFloat:0.5f],
							   nil];
	[self.backgroundPictureImageView.layer addSublayer:gradientLayer];
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
    self.locationLabel.text = @"distance";
    self.locationImageView.image = [self.locationImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.locationImageView setTintColor:[UIColor whiteColor]];
}

#pragma mark
#pragma mark - Dynamic

#warning Kaan

- (void)configureWithDrop:(DFTDrop *)drop
{
	NSArray *distances = @[@"100m", @"200m", @"500m", @"50m", @"600m"];
	NSArray *times = @[@"10 min", @"1 day", @"1 week", @"2 days", @"2 weeks", @"3 h"];

	self.locationLabel.text = distances[arc4random() % [distances count]];
	self.timeLabel.text = times[arc4random() % [times count]];
	self.titleLabel.text = drop.title;

	self.backgroundPictureImageView.contentMode = UIViewContentModeScaleAspectFill;
	[self.backgroundPictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://drift.braycedenayce.com/drift_api/drop/pic/%@", drop.dropId]]];

	self.profilePictureImageView.image = drop.profilePicture;
}

@end
