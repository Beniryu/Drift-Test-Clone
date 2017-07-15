//
//  DFTMiniOptionCell.m
//  Drift
//
//  Created by Thierry Ng on 15/07/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTMiniOptionCell.h"

@interface DFTMiniOptionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *cellLogo;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

@property (weak, nonatomic) IBOutlet UILabel *extraContentLabel;

@end

@implementation DFTMiniOptionCell

- (void)awakeFromNib {
    [super awakeFromNib];

	self.contentView.backgroundColor = [UIColor clearColor];
	self.backgroundColor = [UIColor clearColor];
}

- (void)configureCell
{
	
}

@end
