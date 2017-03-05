//
//  DFTAddDropViewController.m
//  Drift
//
//  Created by Thierry Ng on 17/02/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTAddDropViewController.h"
#import "DFTFirstSectionLayout.h"

#import "DFTFormRowTableViewDelegate.h"
#import "DFTAddDropStepCell.h"

#import "UIColor+DFTStyles.h"

#import <AMTagListView.h>

@interface DFTAddDropViewController () <UIScrollViewDelegate, UITextFieldDelegate, AMTagListDelegate>

#pragma mark - Outlets -
#pragma mark Global

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

#pragma mark Step 01
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextField *tagsTextField;
@property (weak, nonatomic) IBOutlet AMTagListView *tagsView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

#pragma mark Step 02
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic) NSInteger currentSection;

@end

@implementation DFTAddDropViewController

#pragma mark
#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.currentSection = 0;

	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];

	[self.view addGestureRecognizer:pan];

	[self configureScrollView];
	[self configureTags];
}

#pragma mark
#pragma mark - Configure
- (void)configureScrollView
{
	self.scrollView.delegate = self;
	self.scrollView.showsVerticalScrollIndicator = NO;
}

- (void)configureTags
{
	self.tagsTextField.delegate = self;

	self.tagsView.tagListDelegate = self;

	[self.tagsView setTapHandler:^(AMTagView *tag) {
		[self.tagsView removeTag:tag];
	}];
	[[AMTagView appearance] setTagLength:0];
	[[AMTagView appearance] setTagColor:[UIColor dft_salmonColor]];
	[[AMTagView appearance] setInnerTagColor:[UIColor dft_salmonColor]];
	[[AMTagView appearance] setAccessoryImage:[UIImage imageNamed:@"drop_tab_icon"]];
}

#pragma mark
#pragma mark - Helpers

- (NSInteger)previousSection
{
	return (self.currentSection == 0 ? self.currentSection : self.currentSection - 1);
}

- (NSInteger)nextSection
{
	return (self.currentSection == 1 ? self.currentSection : self.currentSection + 1);
}

- (void)didPan:(UIPanGestureRecognizer *)sender
{
	if (sender.state == UIGestureRecognizerStateEnded)
	{
		CGPoint velocity = [sender velocityInView:self.view];

		if (velocity.y > 0)
		{
			if (self.currentSection == 0)
				return ;
			self.currentSection = [self previousSection];
			// trigger animation for step 2 inactive
		}
		else
		{
			if (self.currentSection == 1)
				return ;
			self.currentSection = [self nextSection];
			// trigger animation for step 1 inactive
		}
	}
}

#pragma mark
#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if ([string isEqualToString:@" "])
	{
		if (textField.text.length > 0)
		{
			[self.tagsView addTag:textField.text];
			textField.text = @"";
		}
		return (NO);
	}
	return (YES);
}

@end
