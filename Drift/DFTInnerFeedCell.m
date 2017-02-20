//
//  DFTInnerFeedCell.m
//  Drift
//
//  Created by Thierry Ng on 30/01/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTInnerFeedCell.h"

@interface DFTInnerFeedCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;


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
	self.imageView.image = [UIImage imageNamed:@"feed_cell_placeholder"];
}

@end
