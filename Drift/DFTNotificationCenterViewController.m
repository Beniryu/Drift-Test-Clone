//
//  DFTNotificationCenterViewController.m
//  Drift
//
//  Created by Thierry Ng on 21/04/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTNotificationCenterViewController.h"

@interface DFTNotificationCenterViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation DFTNotificationCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notif_center"]];
	self.scrollView.contentSize = (CGSize){self.scrollView.frame.size.width, 876};
	view.contentMode = UIViewContentModeScaleAspectFit;
	[self.scrollView addSubview:view];
}

@end
