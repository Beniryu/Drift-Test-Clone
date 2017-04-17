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

@interface DFTAddDropViewController () <UIScrollViewDelegate, UITextFieldDelegate, AMTagListDelegate, UITextViewDelegate>
{
@private
    UIControl *activeField;
    CGPoint savedContentOffset;
    NSArray *uiElementFirstBlock;
    BOOL keyboardActivated;
    NSArray *stepOneDisable;
}

#pragma mark - Outlets -
#pragma mark Global

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

#pragma mark Step 01
@property (weak, nonatomic) IBOutlet UILabel *lblStep;
@property (weak, nonatomic) IBOutlet UILabel *lblStepNumber;
@property (weak, nonatomic) IBOutlet UIView *vLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UIImageView *imgLocation;
@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UILabel *lblSeparator;
@property (weak, nonatomic) IBOutlet UITextField *tfTags;
@property (weak, nonatomic) IBOutlet UIButton *btnTagPresent;
@property (weak, nonatomic) IBOutlet UIButton *btnTagArrow;
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

    uiElementFirstBlock = @[self.lblStep, self.lblStepNumber, self.vLocation, self.titleTextView, self.lblSeparator, self.tagsView, self.tfDescription, self.btnDescription];
    
    stepOneDisable = @[self.btnTags, self.btnDescription, self.tfTags, self.tfDescription, self.titleTextView];
    
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];

	[self.view addGestureRecognizer:pan];
	[self configureScrollView];
	self.titleTextView.scrollEnabled = NO;
	[self configureTags];
	[self configureTableView];
    [self configureStepOne];
    [self registerForKeyboardNotifications];
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

- (void)configureStepOne
{
    [self.imgLocation setTintColor:[UIColor dft_lightRedColor]];
    [self.btnTags.imageView setTintColor:[UIColor grayColor]];
    [self.btnDescription.imageView setTintColor:[UIColor grayColor]];
    [self.btnTagPresent.imageView setTintColor:[UIColor grayColor]];
    [self.btnTagArrow.imageView setTintColor:[UIColor whiteColor]];
}

- (void)configureTags
{
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTagsTextField)];
    
	self.tfTags.delegate = self;
	self.tagsView.tagListDelegate = self;
    self.titleTextView.delegate = self;
    
    self.tfTags.hidden = YES;
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
//	self.tfTags.hidden = NO;
}

- (void)executeTransition:(kDFTDropFormStepTransition)transition
{
    if( keyboardActivated )
        return;
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
         self.lblSeparator.transform = t2;
         self.btnTags.transform = t2;
         self.btnDescription.transform = t2;

		 [self.scrollView setContentOffset:(CGPoint){0, 80} animated:YES];
	 }];
    
    for( UIView *element in stepOneDisable )
        element.userInteractionEnabled = NO;
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
         self.lblSeparator.transform = CGAffineTransformIdentity;
         self.btnTags.transform = CGAffineTransformIdentity;
         self.btnDescription.transform = CGAffineTransformIdentity;

		 [self.scrollView setContentOffset:(CGPoint){0, 0} animated:YES];
	 }];
    
    for( UIView *element in stepOneDisable )
        element.userInteractionEnabled = YES;
}

#pragma mark
#pragma mark - UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if ([string isEqualToString:@" "])
	{
		if (textField.text.length > 0)
			[self addTag:textField.text];
        
		return NO;
	}
    if( textField.text.length + string.length > MAX_CARACTERS_AUTHORIZED )
        return NO;
    
	return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self addTag:textField.text];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

#pragma mark - Gestion Tags

-(void) addTag:(NSString *) tag
{
    NSString *tagTrim = [tag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if( self.tagsView.tags.count < MAX_TAG_AUTHORIZED && tagTrim && tagTrim.length > 0)
    {
        BOOL found = NO;
        for( UIView<AMTag> *tag in self.tagsView.tags )
        {
            if( [tag.tagText caseInsensitiveCompare:tagTrim] == NSOrderedSame)
            {
                found = YES;
                break;
            }
        }
        if( !found )
            [self.tagsView addTag:tagTrim];
        
        self.tfTags.text = @"";
        self.btnTags.hidden = YES;
        self.btnTagArrow.hidden = NO;
    }
}

-(void) removeTag:(AMTagView *) tag
{
    [self.tagsView removeTag:tag];
    if( self.tagsView.tags.count == 0 )
    {
        self.btnTags.hidden = NO;
        self.btnTagArrow.hidden = YES;
    }
}

#pragma mark - Actions

- (IBAction)actTags:(id)sender
{
    activeField = self.btnTags;
    
    [UIView animateWithDuration:1.0f animations:^{
        [self.btnTags.imageView setTintColor:[UIColor whiteColor]];
        self.btnTagPresent.alpha = 1;
        for( UIControl *element in uiElementFirstBlock )
        {
            if( ![element isEqual:self.tagsView] )
                [element setAlpha:0];
        }
    } completion:^(BOOL finished)
     {
         self.tfTags.hidden = NO;
     }];
    
    [self.tfTags setText:@""];
    [self.tfTags becomeFirstResponder];
}

- (IBAction)actDescription:(id)sender
{
    activeField = self.btnTags;
}

#pragma mark - Gestion Keyboard

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications

{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    keyboardActivated = YES;
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
 
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGRect convertedRect = [activeField.superview convertRect:activeField.frame toView:self.scrollView];
    convertedRect.origin.y += 8;
    if (!CGRectContainsPoint(aRect, convertedRect.origin) ) {
        savedContentOffset = self.scrollView.contentOffset;
        [self.scrollView scrollRectToVisible:convertedRect animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    keyboardActivated = NO;
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    [self.scrollView setContentOffset:savedContentOffset animated:YES];
    
    [UIView animateWithDuration:1.0f animations:^{
        self.tfTags.hidden = YES;
        for( UIControl *element in uiElementFirstBlock )
            [element setAlpha:1];
    }];
}

#pragma mark - UITextView
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:1.0f animations:^{
        for( id element in uiElementFirstBlock )
        {
            if( [element isEqual:self.vLocation] )
            {
                [element setAlpha:0.5];
                continue;
            }
            if( ![element isEqual:textView] )
                [element setAlpha:0];
        }
    } completion:^(BOOL finished)
     {
         [self.view layoutIfNeeded];
     }];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (IBAction)actTapOut:(id)sender
{
    [activeField resignFirstResponder];
    activeField = nil;
}

@end
