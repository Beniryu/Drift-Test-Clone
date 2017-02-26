//
//  DFTFormRowTableViewDelegate.m
//  Drift
//
//  Created by Thierry Ng on 25/02/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTFormRowTableViewDelegate.h"

#import "DFTAddDropContentTableView.h"
#import "DFTAddDropSettingsTableView.h"

@implementation DFTFormRowTableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return (tableView.class == [DFTAddDropContentTableView class] ? 4 : 5);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return (44.);
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return (44.);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (tableView.class == [DFTAddDropContentTableView class])
	{
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddDropContentCell"];

		return (cell);
	}
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Test"];

	NSLog(@"WIP");
	return (cell);
}

@end
