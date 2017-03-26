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


@interface DFTInnerFeedCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

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

- (void)awakeFromNib
{
    [super awakeFromNib];
	self.layer.cornerRadius = 7;
	self.clipsToBounds = YES;
}

- (void)configureWithItem:(id)item
{
    
    MGLPointAnnotation *point = item;
	self.imageView.image = [UIImage imageNamed:@"feed_cell_placeholder"];
    self.profileImageView.image =  [UIImage imageNamed:@"feed_cell_profile_pic_placeholder"];
    self.nameLabel.text = @"Flavio";
    self.formattedLikesLabel.text = @"20 | 5 min";
    self.mainFeedLabel.text = point.title;
    self.hashTagLabel.text = @"#burgeraddict #junkfood";
    self.distanceLabel.text = @"200m";
    
    [self configureLocationImage];
    [self configureProfileImage];
}

- (void)updateConstraintWithValue:(NSInteger)value
{
    self.leadingConstraint.constant = value;
    self.trailingConstraint.constant = value;
}

- (void)configureProfileImage
{
    // TODO: - Duplicate code
    CAShapeLayer *border = [CAShapeLayer new];
    
    border.frame = self.profileImageView.bounds;
    border.lineWidth = 4.;
    border.path = [UIBezierPath bezierPathWithOvalInRect:border.bounds].CGPath;
    border.strokeColor = [UIColor dft_lightGrayColor].CGColor;
    border.fillColor = [UIColor clearColor].CGColor;
    [self.profileImageView.layer addSublayer:border];
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2.;
}

- (void)configureLocationImage
{
    self.locationImageView.image = [self.locationImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.locationImageView setTintColor:[UIColor dft_darkGrayColor]];
}

@end
