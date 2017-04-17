//
//  DFTOptionTableViewCell.m
//  Drift
//
//  Created by Clément Georgel on 17/04/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTOptionTableViewCell.h"
#import "UIColor+DFTStyles.h"

@implementation DFTOptionTableViewCell

@synthesize imgOption, swEnable, lblChoice, lblEdit;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.transform = CGAffineTransformMakeScale(0.75, 0.75);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)actDisable:(UISwitch *)sender
{
    if( sender.isOn )
    {
        imgOption.tintColor = [UIColor dft_lightRedColor];
        lblEdit.text = NSLocalizedString(@"optEdit", nil);
        lblEdit.textColor = [UIColor whiteColor];
        lblChoice.hidden = NO;
    }
    else
    {
        imgOption.tintColor =  [UIColor lightGrayColor];
        lblEdit.text = NSLocalizedString(@"optDisable", nil);
        lblEdit.textColor = [UIColor lightGrayColor];
        lblChoice.hidden = YES;
    }
    
    [self layoutIfNeeded];
}
@end
