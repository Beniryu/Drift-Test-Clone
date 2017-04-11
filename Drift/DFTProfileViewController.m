//
//  DFTProfileViewController.m
//  Drift
//
//  Created by Thierry Ng on 05/04/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTProfileViewController.h"

#import "DFTSegmentedControl.h"

@interface DFTProfileViewController () <DFTSegmentedControlDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *coverView;

@property (weak, nonatomic) IBOutlet UIView *segmentedContainerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *profilePictureBottomMargin;

@property (strong, nonatomic) DFTSegmentedControl *segmentedControl;

@end

@implementation DFTProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self configureScrollView];
	[self configureSegmentedControl];
	[self configureHeader];
}

- (void)configureHeader
{
	self.profilePictureView.image = [UIImage imageNamed:@"feed_cell_profile_pic_placeholder"];
}

- (void)configureScrollView
{
//	self.scrollView.contentSize = (CGSize){self.view.bounds.size.width, self.view.bounds.size.height * 2};
	self.scrollView.delegate = self;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.bounces = NO;
}

- (void)configureSegmentedControl
{
	self.segmentedControl = [[[NSBundle mainBundle] loadNibNamed:@"DFTSegmentedControl" owner:self options:nil] lastObject];
	self.segmentedControl.delegate = self;
	[self.segmentedContainerView addSubview:self.segmentedControl];
}

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	self.headerTopConstraint.constant = -((scrollView.contentOffset.y) / 7);
	self.headerView.alpha = (1 - (scrollView.contentOffset.y / self.headerView.frame.size.height));
}

#pragma mark - DFTSegmentedControl Delegate
- (void)segmentedControlValueChanged:(NSInteger)index
{
	// Replace by custon self-made views
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Titre" message:@"message message message message message message message" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Fermer" style:UIAlertActionStyleDefault handler:nil];

	[alert addAction:okAction];
	[self presentViewController:alert animated:YES completion:nil];
}

@end
