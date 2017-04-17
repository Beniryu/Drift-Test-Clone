//
//  DFTOptionTableViewCell.h
//  Drift
//
//  Created by Clément Georgel on 17/04/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFTOptionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgOption;
@property (weak, nonatomic) IBOutlet UILabel *lblEdit;
@property (weak, nonatomic) IBOutlet UILabel *lblChoice;
@property (weak, nonatomic) IBOutlet UISwitch *swEnable;

- (IBAction)actDisable:(UISwitch *)sender;

@end
