//
//  DFTDropViewController.h
//  Drift
//
//  Created by Thierry Ng on 19/01/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFTDropViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnBulle;
@property (weak, nonatomic) IBOutlet UIImageView *imgLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentPosition;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;

@end
