//
//  DFTAddDropViewController.m
//  Drift
//
//  Created by Thierry Ng on 17/02/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTAddDropViewController.h"

#import "DFTDropFormManager.h"
#import "UIColor+DFTStyles.h"

#import <AMTagListView.h>

@interface DFTAddDropViewController () <UIScrollViewDelegate, UITextFieldDelegate, AMTagListDelegate>
{
@private
    int nbTags;
}

#pragma mark - Outlets -
#pragma mark Global

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

#pragma mark Step 01
@property (weak, nonatomic) IBOutlet UILabel *lblStep;
@property (weak, nonatomic) IBOutlet UILabel *lblStepNumber;
@property (weak, nonatomic) IBOutlet UIView *vLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextField *tfTags;
@property (weak, nonatomic) IBOutlet AMTagListView *tagsView;
@property (weak, nonatomic) IBOutlet UIButton *btnTags;
@property (weak, nonatomic) IBOutlet UITextField *tfDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnDescription;

#pragma mark Step 02
@property (weak, nonatomic) IBOutlet UITableView *tableView;

#pragma mark - Heights -
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstStepHeight;
@property (nonatomic) NSInteger titleHeight;

#pragma mark - Properties -

@property (nonatomic) DFTDropFormManager *manager;
@property (nonatomic) NSInteger currentSection;

@end

@implementation DFTAddDropViewController

static const int MAX_TAG_AUTHORIZED         = 3;
static const int MAX_CARACTERS_AUTHORIZED   = 8;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	if (self = [super initWithCoder:aDecoder])
	{
		self.manager = [DFTDropFormManager new];
		self.currentSection = 0;
	}
	return (self);
}

#pragma mark
#pragma mark - Lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];

	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];

	[self.view addGestureRecognizer:pan];
	[self configureScrollView];
	self.titleTextView.scrollEnabled = NO;
	[self configureTags];
	[self configureTableView];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	self.titleHeight = self.titleTextView.frame.size.height;
}

#pragma mark
#pragma mark - Configure

- (void)configureScrollView
{
	self.scrollView.delegate = self;
	self.scrollView.showsVerticalScrollIndicator = NO;
	self.scrollView.scrollEnabled = NO;
}

- (void)configureTags
{
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTagsTextField)];

	self.tfTags.delegate = self;
	self.tagsView.tagListDelegate = self;

	self.tfTags.hidden = NO;
	[self.tagsView addGestureRecognizer:tap];
	[self.tagsView setTapHandler:^(AMTagView *tag) {
		[self removeTag:tag];
	}];
	[[AMTagView appearance] setTagLength:0];
	[[AMTagView appearance] setTagColor:[UIColor dft_salmonColor]];
	[[AMTagView appearance] setInnerTagColor:[UIColor dft_salmonColor]];
	[[AMTagView appearance] setAccessoryImage:[UIImage imageNamed:@"drop_tab_icon"]];
}

- (void)configureTableView
{
	self.tableView.scrollEnabled = NO;
}

#pragma mark
#pragma mark - Helpers


- (void)didPan:(UIPanGestureRecognizer *)sender
{
	DFTDropFormTransitionBlock block = nil;

	block = ^(kDFTDropFormStepTransition transition)
	{
		[self executeTransition:transition];
	};


	if (sender.state == UIGestureRecognizerStateBegan)
	{
		CGPoint velocity = [sender velocityInView:self.view];
		kDFTDropFormSwipeDirection direction;

		direction = (velocity.y > 0 ? kDFTDropFormSwipeDirectionDown : kDFTDropFormSwipeDirectionUp);

		self.currentSection = [self.manager routeSwipeDirection:direction
													fromSection:self.currentSection
													  withBlock:block];
	}
}

- (void)showTagsTextField
{
	self.tfTags.hidden = NO;
}

- (void)executeTransition:(kDFTDropFormStepTransition)transition
{
	switch (transition)
	{
		case kDFTDropFormStepTransitionDetailsToSettings:
			[self transitionFromDetailsToSettings];
			break;
		case kDFTDropFormStepTransitionSettingsToValidation:
			[self transitionFromSettingsToValidation];
			break;
		case kDFTDropFormStepTransitionValidationToSettings:
			[self transitionFromValidationToSettings];
			break;
		case kDFTDropFormStepTransitionSettingsToDetails:
			[self transitionFromSettingsToDetails];
			break;
	}
}

#pragma mark
#pragma mark - Transition Methods

- (void)transitionFromDetailsToSettings
{
	[UIView animateWithDuration:0.5 animations:
	 ^{
		 CGAffineTransform t = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);

		 t = CGAffineTransformTranslate(t, -(self.titleTextView.frame.size.width * 0.5), -(self.titleHeight * 0.5));
		 self.titleTextView.transform = t;

		 CGAffineTransform t2 = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -(self.titleHeight * 0.5));
		 self.tagsView.transform = t2;
		 self.tfDescription.transform = t2;

		 [self.scrollView setContentOffset:(CGPoint){0, 80} animated:YES];
	 }];
}

- (void)transitionFromSettingsToValidation
{
	NSLog(@"transitionFromSettingsToValidation");
}

- (void)transitionFromValidationToSettings
{
	NSLog(@"transitionFromValidationToSettings");
}

- (void)transitionFromSettingsToDetails
{
	[UIView animateWithDuration:0.5 animations:
	 ^{
		 self.titleTextView.transform = CGAffineTransformIdentity;
		 self.tagsView.transform = CGAffineTransformIdentity;
		 self.tfDescription.transform = CGAffineTransformIdentity;

		 [self.scrollView setContentOffset:(CGPoint){0, 0} animated:YES];
	 }];
}

#pragma mark
#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//	if ([string isEqualToString:@" "])
//	{
//		if (textField.text.length > 0)
//		{
//			[self.tagsView addTag:textField.text];
//			textField.text = @"";
//		}
//        
//		return NO;
//	}
    if( textField.text.length + string.length > MAX_CARACTERS_AUTHORIZED )
        return NO;
	return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self addTag:textField.text];
    return YES;
}

#pragma mark - Gestion Tags

-(void) addTag:(NSString *) tag
{
    NSString *tagStrim = [tag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if( nbTags < MAX_TAG_AUTHORIZED && tag.length > 0)
    {
        [self.tagsView addTag:tagStrim];
        self.tfTags.text = @"";
        self.btnTags.hidden = YES;
        nbTags++;
    }
}

-(void) removeTag:(AMTagView *) tag
{
    [self.tagsView removeTag:tag];
    nbTags--;
    if( nbTags == 0 )
        self.btnTags.hidden = NO;
}

#pragma mark - Actions

- (IBAction)actTags:(id)sender
{
    [self.tfTags setText:@""];
    [self.tfTags becomeFirstResponder];
}

- (IBAction)actDescription:(id)sender
{
    
}
@end
