//
//  DFTTabBarController.m
//  Drift
//
//  Created by Thierry Ng on 19/01/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTTabBarController.h"
#import "UIColor+DFTStyles.h"

@interface DFTTabBarController ()

@end

@implementation DFTTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.selectedIndex = 0;
	self.tabBar.tintColor = [UIColor dft_salmonColor];
	self.tabBar.unselectedItemTintColor = [UIColor dft_grayColor];
	self.tabBar.barTintColor = [UIColor dft_darkGrayColor];
	self.tabBar.translucent = NO;
	self.tabBar.barStyle = UIBarStyleBlackOpaque;

	for (UITabBarItem *item in self.tabBar.items)
		item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
}

@end
