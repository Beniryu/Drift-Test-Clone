//
//  DFTOpenedDropViewController.h
//  Drift
//
//  Created by Clément Georgel on 17/04/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFTDrop.h"

@interface DFTOpenedDropViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIImageView *imgAnimated;
@property (weak, nonatomic) IBOutlet UIImageView *imgPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *vDetails;
@property (weak, nonatomic) IBOutlet UILabel *lblShares;
@property (weak, nonatomic) IBOutlet UILabel *lblNbShares;
@property (weak, nonatomic) IBOutlet UILabel *lblLikes;
@property (weak, nonatomic) IBOutlet UILabel *lblNbLikes;
@property (weak, nonatomic) IBOutlet UILabel *lblDrifters;
@property (weak, nonatomic) IBOutlet UILabel *lblNbDrifters;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfil;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIView *vLocation;
@property (weak, nonatomic) IBOutlet UIImageView *imgLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;
@property (weak, nonatomic) IBOutlet UILabel *lblDistance;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;
@property (weak, nonatomic) IBOutlet UILabel *lblNameEvent;
@property (weak, nonatomic) IBOutlet UILabel *lblDay;
@property (weak, nonatomic) IBOutlet UILabel *lblMonth;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UILabel *lblTags;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imgDrifter1;
@property (weak, nonatomic) IBOutlet UIImageView *imgDrifter2;
@property (weak, nonatomic) IBOutlet UIImageView *imgDrifter3;

//Menu Side
@property (weak, nonatomic) IBOutlet UIView *vMenuPlaceholder;
@property (weak, nonatomic) IBOutlet UIView *vMenuOrigin;
@property (weak, nonatomic) IBOutlet UIView *vMenuRight;
@property (weak, nonatomic) IBOutlet UIView *vMarkIt;

- (IBAction)actCloseDrop:(id)sender;
- (IBAction)actExpandMenu:(id)sender;
- (IBAction)actMarkIt:(id)sender;

//Drop
@property (nonatomic, retain) DFTDrop *drop;

@end
