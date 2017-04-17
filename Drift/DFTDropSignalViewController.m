//
//  DFTDropSignalViewController.m
//  Drift
//
//  Created by Thierry Ng on 16/04/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTDropSignalViewController.h"

@interface DFTDropSignalViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation DFTDropSignalViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

}

#pragma mark
#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return (0);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

	return (cell);
}

@end
