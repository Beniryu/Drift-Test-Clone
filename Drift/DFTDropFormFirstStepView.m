//
//  DFTDropFormFirstStepView.m
//  Drift
//
//  Created by Thierry Ng on 02/06/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTDropFormFirstStepView.h"
#import "UIColor+DFTStyles.h"
#import "DFTDrop.h"
#import <UITextView+Placeholder.h>
#import <AMTagListView.h>

@interface DFTDropFormFirstStepView () <UITextViewDelegate, UITextFieldDelegate, AMTagListDelegate>

@property (weak, nonatomic) IBOutlet UIView *stepView;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (weak, nonatomic) IBOutlet AMTagListView *tagList;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *descriptionImageView;
@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tagsImageView;

@property NSString *descriptionText;

@end

@implementation DFTDropFormFirstStepView

- (void)awakeFromNib
{
	[super awakeFromNib];

	self.titleTextView.scrollEnabled = NO;
	self.descriptionTextView.scrollEnabled = NO;

	self.titleTextView.delegate = self;
	self.descriptionTextView.delegate = self;

	self.titleTextView.placeholder = @"Lorem ipsum machin";
	self.titleTextView.placeholderLabel.font = self.titleTextView.font;
	self.titleTextView.text = @"";
	self.titleTextView.textContainer.maximumNumberOfLines = 3;
	self.titleTextView.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;

	self.stepView.transform = CGAffineTransformMakeTranslation(0, 200);
	self.stepView.alpha = 0.;
	self.titleTextView.transform = CGAffineTransformMakeTranslation(0, 200);
	self.titleTextView.alpha = 0.;
	self.tagView.transform = CGAffineTransformMakeTranslation(0, 200);
	self.tagView.alpha = 0.;
	self.descriptionTextView.transform = CGAffineTransformMakeTranslation(0, 200);
	self.descriptionTextView.alpha = 0.;
	self.descriptionText = @"";

	self.locationImageView.tintColor = [UIColor dft_salmonColor];
	self.tagsImageView.tintColor = [UIColor grayColor];
	self.descriptionImageView.tintColor = [UIColor grayColor];
	self.tagTextField.delegate = self;

	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateTagForward)];
	[self.tagList addGestureRecognizer:tap];
	self.tagList.tagListDelegate = self;
	[self.tagList setTapHandler:^(AMTagView *view) {
		[self.tagList removeTag:view];

	}];
	[AMTagView appearance].tagLength = 0.;
	[AMTagView appearance].accessoryImage = [UIImage imageNamed:@"picto_location"];
	[AMTagView appearance].tagColor = [UIColor dft_salmonColor];
	[AMTagView appearance].innerTagColor = [UIColor dft_salmonColor];
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

	self.userInteractionEnabled = NO;
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
		 self.titleTextView.alpha = 0.4;
		 self.separator.alpha = 0.4;
		 // Top
		 self.stepView.transform = CGAffineTransformMakeTranslation(0, rect.size.height * 0.5);
		 self.locationView.transform = CGAffineTransformMakeTranslation(0, rect.size.height * 0.5);

		 self.tagsImageView.alpha = 1;
		 self.tagList.alpha = 0;

		 // description
		 self.descriptionText = self.descriptionTextView.text;
		 self.descriptionTextView.text = @"";
		 self.descriptionImageView.alpha = 1;

	 } completion:nil];
}

- (void)animateReverse
{
	self.userInteractionEnabled = YES;
	[UIView animateWithDuration:0.4 animations:
	 ^{
		 self.titleTextView.transform = CGAffineTransformIdentity;
		 self.titleTextView.alpha = 1;
		 self.separator.alpha = 1;
		 self.stepView.transform = CGAffineTransformIdentity;
		 self.locationView.transform = CGAffineTransformIdentity;
		 self.tagList.alpha = 1;
		 if (self.tagList.tags.count > 0)
			 self.tagsImageView.alpha = 0;

		 if (self.descriptionText.length != 0)
			 self.descriptionImageView.alpha = 0;
	 } completion:^(BOOL finished) {
		 self.descriptionTextView.text = self.descriptionText;
	 }];
}

- (void)arrangeForCamera
{
	[UIView animateWithDuration:0.4 animations:^{
		self.stepView.alpha = 0;
	}];
}

- (void)arrangeForCameraDismissal
{
	[UIView animateWithDuration:0.4 animations:^{
		self.stepView.alpha = 1;
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

- (void)animateTagForward
{
	[self.tagTextField becomeFirstResponder];
	[UIView animateWithDuration:0.5 animations:^{
		self.stepView.alpha = 0;
		self.titleTextView.alpha = 0;
		self.descriptionTextView.alpha = 0;
		self.tagsImageView.alpha = 0;
	}];
}

- (void)animateTagReverse
{
	[UIView animateWithDuration:0.5 animations:^{
		self.stepView.alpha = 1;
		self.titleTextView.alpha = 1;
		self.descriptionTextView.alpha = 1;
	}];
}

- (void)animateDescriptionEditForward
{
	[UIView animateWithDuration:0.5 animations:^{
		self.stepView.alpha = 0;
		self.titleTextView.alpha = 0;
		self.tagView.alpha = 0;
		self.descriptionImageView.alpha = 0;
	}];
}

- (void)animateDescriptionEditReverse
{
	[UIView animateWithDuration:0.5 animations:^{
		self.stepView.alpha = 1;
		self.titleTextView.alpha = 1;
		self.tagView.alpha = 1;
		if (self.descriptionTextView.text.length == 0)
			self.descriptionImageView.alpha = 1;
	}];
}

- (void)fillDrop:(DFTDrop *)drop
{
	drop.title = self.titleTextView.text;
	drop.dropDescription = self.descriptionText;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if ([string isEqualToString:@" "])
	{
		if (textField.text.length > 0)
		{
			[self.tagList addTag:textField.text];
			textField.text = @"";
		}
		return NO;
	}
	if (textField.text.length + string.length > 30)
		return NO;
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	[self animateTagForward];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	[self animateTagReverse];
	if (textField.text.length > 0)
	{
		[self.tagList addTag:textField.text];
		textField.text = @"";
	}
	if (self.tagList.tags.count == 0)
	{
		[UIView animateWithDuration:0.4 animations:^{
			self.tagsImageView.alpha = 1;
		}];
	}
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.tagList addTag:textField.text];
	textField.text = @"";
	[self.tagTextField resignFirstResponder];
	return YES;
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	NSString *newText = [textView.text stringByReplacingCharactersInRange:range withString:text];
	NSDictionary *textAttributes = @{NSFontAttributeName : textView.font};
	CGFloat textWidth = CGRectGetWidth(UIEdgeInsetsInsetRect(textView.frame, textView.textContainerInset));
	NSString *checkString;

	textWidth -= 2.0f * textView.textContainer.lineFragmentPadding;

	checkString = ([text isEqualToString:@" "] ? [textView.text stringByAppendingString:@"w"] : newText);

	CGRect boundingRect = [checkString boundingRectWithSize:CGSizeMake(textWidth, 0)
												options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
											 attributes:textAttributes
												context:nil];

	CGFloat numberOfLines = CGRectGetHeight(boundingRect) / textView.font.lineHeight;
	NSUInteger targetNumberOfLines = (textView == self.titleTextView ? 3 : 5);
	NSLog(@"line height : %ld\n", (long)textView.font.lineHeight);
	NSLog(@"Bounding rect w:%ld h:%ld", (long)boundingRect.size.width, (long)boundingRect.size.height);
	NSLog(@"number of lines : %f - %f", numberOfLines, boundingRect.size.height / textView.font.lineHeight);

	return floorf(numberOfLines) <= targetNumberOfLines;
}

- (BOOL)tagList:(AMTagListView *)tagListView shouldAddTagWithText:(NSString *)text resultingContentSize:(CGSize)size
{
	return (YES);
}

- (void)tagList:(AMTagListView *)tagListView didRemoveTag:(UIView<AMTag> *)tag
{
	if (tagListView.tags.count == 0)
	{
		[UIView animateWithDuration:0.4 animations:^{
			self.tagsImageView.alpha = 1;
		}];
	}
}

@end
