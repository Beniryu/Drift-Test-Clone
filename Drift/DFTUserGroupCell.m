//
//  DFTUserGroupCell.m
//  Drift
//
//  Created by Thierry Ng on 08/07/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTUserGroupCell.h"

@interface DFTUserGroupCell ()
@property (weak, nonatomic) IBOutlet UIImageView *dropImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

@end

@implementation DFTUserGroupCell

- (void)awakeFromNib {
    [super awakeFromNib];

	self.userImageView.clipsToBounds = YES;
	self.userImageView.layer.cornerRadius = 15.;

	self.groupNameLabel.text = @"Shelter";
	self.subLabel.text = @"Porter, ... +1";
}

@end
