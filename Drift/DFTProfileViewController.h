//
//  DFTProfileViewController.h
//  Drift
//
//  Created by Thierry Ng on 05/04/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFTProfileViewController : UIViewController

// Header
@property (weak, nonatomic) IBOutlet UIImageView *imgCover;
@property (weak, nonatomic) IBOutlet UILabel *lblDrifts;
@property (weak, nonatomic) IBOutlet UILabel *lblNbDrifts;
@property (weak, nonatomic) IBOutlet UILabel *lblDrops;
@property (weak, nonatomic) IBOutlet UILabel *lblNbDrops;
@property (weak, nonatomic) IBOutlet UILabel *lblCountries;
@property (weak, nonatomic) IBOutlet UILabel *lblNbCountries;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblRank;
@property (weak, nonatomic) IBOutlet UILabel *lblPosition;
@property (weak, nonatomic) IBOutlet UIButton *btnSettings;
@property (weak, nonatomic) IBOutlet UIView *vLocation;

- (IBAction)actSettings:(id)sender;

// Row 1
@property (weak, nonatomic) IBOutlet UILabel *lblFollowers;
@property (weak, nonatomic) IBOutlet UILabel *lblNbFollowers;
@property (weak, nonatomic) IBOutlet UILabel *lblFriends;
@property (weak, nonatomic) IBOutlet UILabel *lblNbFriends;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowing;
@property (weak, nonatomic) IBOutlet UILabel *lblNbFollowing;

// Row 2
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;

// Row 3
@property (weak, nonatomic) IBOutlet UIScrollView *driftDropOverviewScrollView;


// Row 4

// Row 5
@property (weak, nonatomic) IBOutlet UILabel *lblHeaderLikedDrops;
@property (weak, nonatomic) IBOutlet UICollectionView *mostLikedCollectionView;


// Row 6
@property (weak, nonatomic) IBOutlet UILabel *lblLastCheck;
@property (weak, nonatomic) IBOutlet UILabel *lblLastCheckTime;
@property (weak, nonatomic) IBOutlet UIImageView *imgMapCheck;

@end
