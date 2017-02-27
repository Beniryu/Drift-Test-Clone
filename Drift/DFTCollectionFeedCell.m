//
//  DFTCollectionFeedCell.m
//  Drift
//
//  Created by Jonathan Nguyen on 27/02/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTCollectionFeedCell.h"
#import "UIColor+DFTStyles.h"

@interface DFTCollectionFeedCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *dropsNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropsLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainCollectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;

@end

@implementation DFTCollectionFeedCell


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self configureProfilePic];
    [self configureLocationLabel];
    
}

- (void)configureProfilePic
{
    CAShapeLayer *border = [CAShapeLayer new];
    
    border.frame = self.profileImageView.bounds;
    border.lineWidth = 4.;
    border.path = [UIBezierPath bezierPathWithOvalInRect:border.bounds].CGPath;
    border.strokeColor = [UIColor lightGrayColor].CGColor;
    border.fillColor = [UIColor clearColor].CGColor;
    [self.profileImageView.layer addSublayer:border];
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2.;
}

- (void)configureLocationLabel
{
    self.locationLabel.text = @"LONDON";
    self.locationImageView.image = [self.locationImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.locationImageView setTintColor:[UIColor dft_lightGrayColor]];
}


@end
