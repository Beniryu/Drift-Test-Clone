//
//  DFTInnerFeedCell.m
//  Drift
//
//  Created by Thierry Ng on 30/01/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTInnerFeedCell.h"
#import "UIColor+DFTStyles.h"
#import "DFTMapManager.h"
#import "ImageUtils.h"

#import <UIImageView+WebCache.h>

@interface DFTInnerFeedCell ()

// Right part
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *formattedLikesLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainFeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *hashTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingConstraint;

@end

@implementation DFTInnerFeedCell

@synthesize imageView;

- (void)awakeFromNib
{
    [super awakeFromNib];
	self.layer.cornerRadius = 7;
	self.clipsToBounds = YES;
	[self configureLocationImage];
	[self configureProfileImage];
}

- (void)configureWithItem:(DFTDrop *)drop
{
	self.imageView.contentMode = UIViewContentModeScaleAspectFill;
	self.imageView.clipsToBounds = YES;
	[self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://drift.braycedenayce.com/drift_api/drop/pic/%@", drop.dropId]]];

	//    self.nameLabel.text = @"Flavio";
    self.formattedLikesLabel.text = @"20 | 5 min";
    self.mainFeedLabel.text = drop.title;
    self.hashTagLabel.text = @"#burgeraddict #junkfood";
    self.distanceLabel.text = @"200m";
	self.profileImageView.image = drop.profilePicture;
}

- (void)updateConstraintWithValue:(NSInteger)value
{
    self.leadingConstraint.constant = value;
    self.trailingConstraint.constant = value;
}

- (void)configureProfileImage
{
    [ImageUtils roundedBorderImageView:self.profileImageView];
}

- (void)configureLocationImage
{
    self.locationImageView.image = [self.locationImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.locationImageView setTintColor:[UIColor dft_darkGrayColor]];
}

@end
