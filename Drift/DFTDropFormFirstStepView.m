//
//  DFTDropFormFirstStepView.m
//  Drift
//
//  Created by Thierry Ng on 02/06/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTDropFormFirstStepView.h"

@interface DFTDropFormFirstStepView () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *stepView;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@end

@implementation DFTDropFormFirstStepView

- (void)awakeFromNib
{
	[super awakeFromNib];

	self.titleTextView.scrollEnabled = NO;
	self.descriptionTextView.scrollEnabled = NO;

	self.titleTextView.delegate = self;
	self.descriptionTextView.delegate = self;

	self.stepView.transform = CGAffineTransformMakeTranslation(0, 200);
	self.stepView.alpha = 0.;
	self.titleTextView.transform = CGAffineTransformMakeTranslation(0, 200);
	self.titleTextView.alpha = 0.;
	self.tagView.transform = CGAffineTransformMakeTranslation(0, 200);
	self.tagView.alpha = 0.;
	self.descriptionTextView.transform = CGAffineTransformMakeTranslation(0, 200);
	self.descriptionTextView.alpha = 0.;
}

- (void)appear
{
	[UIView animateWithDuration:0.5 animations:^{
		self.stepView.transform = CGAffineTransformIdentity;
		self.stepView.alpha = 1;
	}];
	[UIView animateWithDuration:0.5 delay:0.15 options:UIViewAnimationOptionTransitionNone animations:^{
		self.titleTextView.transform = CGAffineTransformIdentity;
		self.titleTextView.alpha = 1;
	} completion:nil];
	[UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionTransitionNone animations:^{
		self.tagView.transform = CGAffineTransformIdentity;
		self.tagView.alpha = 1;
	} completion:nil];
	[UIView animateWithDuration:0.5 delay:0.45 options:UIViewAnimationOptionTransitionNone animations:^{
		self.descriptionTextView.transform = CGAffineTransformIdentity;
		self.descriptionTextView.alpha = 1;
	} completion:nil];
}

- (void)animateForward
{
	CGRect rect = self.titleTextView.bounds;

	[UIView animateWithDuration:1
						  delay:0
		 usingSpringWithDamping:1
		  initialSpringVelocity:1
						options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
					 animations:
	 ^{
		 // Title
		 CGAffineTransform t = CGAffineTransformMakeScale(0.5, 0.5);
		 self.titleTextView.transform = CGAffineTransformTranslate(t, -(rect.size.width * 0.5), rect.size.height * 0.5);

		 // Top
		 self.stepView.transform = CGAffineTransformMakeTranslation(0, rect.size.height * 0.5);
	 } completion:nil];
}

- (void)animateReverse
{
	[UIView animateWithDuration:0.4 animations:
	 ^{
		 if (CGAffineTransformIsIdentity(self.titleTextView.transform) == NO)
			 self.titleTextView.transform = CGAffineTransformIdentity;
		 self.stepView.transform = CGAffineTransformIdentity;

	 }];
}

- (void)arrangeForCamera
{
	[UIView animateWithDuration:0.4 animations:^{
		self.stepView.alpha = 0;
	}];
}

- (void)animateTitleEditForward
{
	[UIView animateWithDuration:0.5 animations:^{
		self.stepView.alpha = 0;
		self.tagView.alpha = 0;
		self.descriptionTextView.alpha = 0;
	}];
}

- (void)animateTitleEditReverse
{
	[UIView animateWithDuration:0.5 animations:^{
		self.stepView.alpha = 1;
		self.tagView.alpha = 1;
		self.descriptionTextView.alpha = 1;
	}];
}

- (void)animateDescriptionEditForward
{
	[UIView animateWithDuration:0.5 animations:^{
		self.stepView.alpha = 0;
		self.titleTextView.alpha = 0;
		self.tagView.alpha = 0;
	}];
}

- (void)animateDescriptionEditReverse
{
	[UIView animateWithDuration:0.5 animations:^{
		self.stepView.alpha = 1;
		self.titleTextView.alpha = 1;
		self.tagView.alpha = 1;
	}];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	if (textView == self.titleTextView)
		[self animateTitleEditForward];
	else if (textView == self.descriptionTextView)
		[self animateDescriptionEditForward];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	if (textView == self.titleTextView)
		[self animateTitleEditReverse];
	else if (textView == self.descriptionTextView)
		[self animateDescriptionEditReverse];
}

@end
