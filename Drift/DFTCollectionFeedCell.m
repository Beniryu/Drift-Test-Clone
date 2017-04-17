//
//  DFTCollectionFeedCell.m
//  Drift
//
//  Created by Jonathan Nguyen on 27/02/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTCollectionFeedCell.h"
#import "UIColor+DFTStyles.h"
#import "ImageUtils.h"

@interface DFTCollectionFeedCell ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *dropsNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropsLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainCollectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;

// Collection Images
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

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
    [ImageUtils roundedBorderImageView:self.profileImageView];
}

- (void)configureLocationLabel
{
    self.locationLabel.text = @"LONDON";
    self.locationImageView.image = [self.locationImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.locationImageView setTintColor:[UIColor dft_lightGrayColor]];
}


@end
