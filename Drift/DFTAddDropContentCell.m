//
//  DFTAddDropContentCell.m
//  Drift
//
//  Created by Thierry Ng on 26/02/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTAddDropContentCell.h"

@implementation DFTAddDropContentCell

- (void)awakeFromNib
{
    [super awakeFromNib];

	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

	if (selected)
		[self expand];
	else
		[self collapse];
}

- (void)expand
{
	NSLog(@"EXPAND");
	self.backgroundColor = [UIColor orangeColor];
}

- (void)collapse
{
	NSLog(@"COLLAPSE");
	self.backgroundColor = [UIColor lightGrayColor];
}

@end
