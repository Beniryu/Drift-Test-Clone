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
	imgOption.tintColor = [UIColor dft_lightRedColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
}

- (void)configureWithIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row)
	{
		case 0:
			self.imgOption.image =  [UIImage imageNamed:@"opt_signal"];
			self.lblChoice.text = NSLocalizedString(@"optionSignalPlaceholder", nil);
			break;
		case 1:
			self.imgOption.image =  [UIImage imageNamed:@"opt_triggerzone"];
			self.lblChoice.text = NSLocalizedString(@"optionTriggerZonePlaceholder", nil);
			break;
		case 2:
			self.imgOption.image =  [UIImage imageNamed:@"opt_display"];
			self.lblChoice.text = NSLocalizedString(@"optionDisplayPlaceholder", nil);
			break;

		case 3:
			self.imgOption.image =  [UIImage imageNamed:@"opt_time"];
			self.lblChoice.text = NSLocalizedString(@"optionTimePlaceholder", nil);
			break;

		case 4:
			self.imgOption.image =  [UIImage imageNamed:@"opt_lockcontent"];
			self.lblChoice.text = NSLocalizedString(@"optionLockContentPlaceholder", nil);
			break;
		default:
			break;
	}
}

- (void)changeModeView:(BOOL) minimize
{
	if( minimize )
	{
		lblChoice.hidden = YES;
		lblEdit.text = [lblChoice.text stringByReplacingOccurrencesOfString:NSLocalizedString(@"defaultPlaceholder", nil) withString:@""];
		swEnable.hidden = YES;
	}
	else
	{
		lblChoice.hidden = NO;
		lblEdit.text = NSLocalizedString(@"optEdit", nil);
		swEnable.hidden = NO;
	}
}

- (IBAction)actDisable:(UISwitch *)sender
{
	[UIView animateWithDuration:0.4 animations:^{
		if (sender.isOn)
		{
			imgOption.tintColor = [UIColor dft_lightRedColor];
			lblEdit.text = NSLocalizedString(@"optEdit", nil);
			lblEdit.textColor = [UIColor whiteColor];
			lblChoice.hidden = NO;
		}
		else
		{
			imgOption.tintColor = [UIColor lightGrayColor];
			lblEdit.text = NSLocalizedString(@"optDisable", nil);
			lblEdit.textColor = [UIColor lightGrayColor];
			lblChoice.hidden = YES;
		}

		[self layoutIfNeeded];
	}];
}

@end
