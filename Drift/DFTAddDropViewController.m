//
//  DFTAddDropViewController.m
//  Drift
//
//  Created by Thierry Ng on 17/02/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTAddDropViewController.h"

#import "DFTOptionTableViewCell.h"
#import "DFTDropFormManager.h"
#import "UIColor+DFTStyles.h"
#import "ImageUtils.h"

#import <AMTagListView.h>

@interface DFTAddDropViewController () <UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate, AMTagListDelegate, UITableViewDelegate, UITableViewDataSource>
{
@private
    UIView *activeField;
    CGRect savedTableRect;
    CGPoint savedContentOffset;
    NSArray *uiElementFirstBlock;
    BOOL keyboardActivated;
    NSArray *stepOneDisable, *stepOneRemove, *stepOneAlphaFifty;
    NSArray *stepValidationAlpha, *stepValidateRemove;
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constHeightTagsView;
@property (weak, nonatomic) IBOutlet UIButton *btnTags;
@property (weak, nonatomic) IBOutlet UITextField *tfDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnDescription;

#pragma mark Step 02
@property (weak, nonatomic) IBOutlet UILabel *lblStep2;
@property (weak, nonatomic) IBOutlet UILabel *lblStepNumber2;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constHeightStepOptions;

#pragma mark Step Validation
@property (weak, nonatomic) IBOutlet UIButton *btnDrop;
@property (weak, nonatomic) IBOutlet UILabel *lblDrop;

#pragma mark - Heights -
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstStepHeight;
@property (nonatomic) NSInteger titleHeight;

#pragma mark - Properties -

@property (nonatomic) DFTDropFormManager *manager;
@property (nonatomic) NSInteger currentSection;

@end

@implementation DFTAddDropViewController

static const int MAX_TAG_AUTHORIZED         = 15;
static const int MAX_CARACTERS_AUTHORIZED   = 8;
static const int TAG_VIEW_HEIGHT_EDIT       = 45;
static const int TAG_VIEW_HEIGHT_VISIBLE    = 30;
static const int OPTIONS_VIEW_HEIGHT        = 340;
static const int OPTIONS_VIEW_HEIGHT_REDUCE = 260;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.manager = [DFTDropFormManager new];
        self.currentSection = 0;
    }
    return (self);
}

//- (BOOL)prefersStatusBarHidden {
//    return YES;
//}

#pragma mark
#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    uiElementFirstBlock = @[self.lblStep, self.lblStepNumber, self.vLocation, self.titleTextView, self.lblSeparator, self.tagsView, self.tfDescription, self.btnDescription];
    
    stepOneDisable = @[self.btnTags, self.btnDescription, self.tfTags, self.tfDescription, self.titleTextView];
    stepOneRemove = @[self.lblStep, self.lblStepNumber];
    stepOneAlphaFifty = @[self.vLocation, self.lblSeparator, self.titleTextView];
    
    stepValidationAlpha = @[self.vLocation, self.lblSeparator, self.titleTextView, self.btnTags, self.btnDescription];
    stepValidateRemove = @[self.lblStep2, self.lblStepNumber2];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    
    [self.view addGestureRecognizer:pan];
    [self configureScrollView];
    self.titleTextView.scrollEnabled = NO;
    [self configureTags];
    [self configureTableView];
    [self configureStepOne];
    [self configureStepValidation];
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

- (void)configureStepValidation
{
    [self.lblDrop setText:NSLocalizedString(@"drop", nil)];
    [self.btnDrop setTintColor:[UIColor whiteColor]];
    [ImageUtils roundedBorderImageView:self.btnDrop lineWidth:1.];
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
    [[AMTagView appearance] setAccessoryImage:[UIImage imageNamed:@"drop_tag_close"]];
}

- (void)configureTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"optionCell";
    DFTOptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if( cell == nil )
        cell = [[DFTOptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    cell.backgroundColor = [UIColor clearColor];
    
    switch (indexPath.row)
    {
        case 0:
            cell.imgOption.image =  [UIImage imageNamed:@"opt_signal"];
            cell.lblChoice.text = NSLocalizedString(@"optionSignalPlaceholder", nil);
            break;
        case 1:
            cell.imgOption.image =  [UIImage imageNamed:@"opt_triggerzone"];
            cell.lblChoice.text = NSLocalizedString(@"optionTriggerZonePlaceholder", nil);
            break;
        case 2:
            cell.imgOption.image =  [UIImage imageNamed:@"opt_display"];
            cell.lblChoice.text = NSLocalizedString(@"optionDisplayPlaceholder", nil);
            break;
            
        case 3:
            cell.imgOption.image =  [UIImage imageNamed:@"opt_time"];
            cell.lblChoice.text = NSLocalizedString(@"optionTimePlaceholder", nil);
            break;
            
        case 4:
            cell.imgOption.image =  [UIImage imageNamed:@"opt_lockcontent"];
            cell.lblChoice.text = NSLocalizedString(@"optionLockContentPlaceholder", nil);
            break;
        default:
            break;
    }
    
    [cell actDisable:cell.swEnable];
    
    [cell setNeedsLayout];
    [cell layoutIfNeeded];
    return cell;
}

#pragma mark
#pragma mark - Helpers

- (void)didPan:(UIPanGestureRecognizer *)sender
{
    DFTDropFormTransitionBlock block = nil;
    
    block = ^(kDFTDropFormStepTransition transition){
        [self executeTransition:transition];
    };
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        CGPoint velocity = [sender velocityInView:self.view];
        kDFTDropFormSwipeDirection direction;
        
        direction = (velocity.y > 0 ? kDFTDropFormSwipeDirectionDown : kDFTDropFormSwipeDirectionUp);
        
        self.currentSection = [self.manager routeSwipeDirection:direction fromSection:self.currentSection withBlock:block];
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
         
         t = CGAffineTransformTranslate(t, -(self.titleTextView.frame.size.width * 0.5), (self.titleHeight * 0.5));
         self.titleTextView.transform = t;
         CGAffineTransform t2 = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, (self.titleHeight * 0.5));
         self.vLocation.transform = t2;
         
         for( UIView *element in stepOneRemove )
             element.alpha = 0;
         
         for( UIView *element in stepOneAlphaFifty )
             element.alpha = 0.5;
         
         [self.btnDescription setImage:[UIImage imageNamed:@"drop_description_b"] forState:UIControlStateNormal];
         
         CGRect convertedRect = [self.tableView.superview convertRect:self.tableView.frame toView:self.scrollView];
         convertedRect.origin.y += 40;
         [self.scrollView scrollRectToVisible:convertedRect animated:YES];
     }];
    
    for( UIView *element in stepOneDisable )
        element.userInteractionEnabled = NO;
}

- (void)transitionFromSettingsToDetails
{
    [UIView animateWithDuration:0.5 animations:
     ^{
         self.titleTextView.transform = CGAffineTransformIdentity;
         self.vLocation.transform = CGAffineTransformIdentity;
         
         for( UIView *element in stepOneRemove )
             element.alpha = 1;
         
         for( UIView *element in stepOneAlphaFifty )
             element.alpha = 1;
         
         [self.btnDescription setImage:[UIImage imageNamed:@"drop_description"] forState:UIControlStateNormal];
         
         [self.scrollView setContentOffset:(CGPoint){0, 0} animated:YES];
     }];
    
    for( UIView *element in stepOneDisable )
        element.userInteractionEnabled = YES;
}

- (void)transitionFromSettingsToValidation
{
    savedTableRect = self.tableView.frame;
    
    [UIView animateWithDuration:0.5 animations:
     ^{
         self.constHeightStepOptions.constant = OPTIONS_VIEW_HEIGHT_REDUCE;
         [self.view layoutIfNeeded];
     }];
    [UIView animateWithDuration:0.5 animations:
     ^{
         for( UIView *element in stepValidateRemove )
             element.alpha = 0;
         
         CGAffineTransform t = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, -(self.tableView.frame.size.height * 0.5));
         self.tableView.transform = t;
         
         for( UIView *element in stepValidationAlpha )
             element.alpha = 1;
         
         [self.btnTags.imageView setTintColor:[UIColor whiteColor]];
         [self.btnDescription.imageView setTintColor:[UIColor whiteColor]];
         
         CGRect tableRect = self.tableView.frame;
         tableRect.origin.y = 0;
         tableRect.size.height = OPTIONS_VIEW_HEIGHT_REDUCE;
         self.tableView.frame = tableRect;
         
         //        CGRect convertedRect = [self.lblDrop.superview convertRect:self.lblDrop.frame toView:self.scrollView];
         //        convertedRect.origin.y += 20;
         //        [self.scrollView scrollRectToVisible:convertedRect animated:YES];
         //        savedContentOffset = self.scrollView.contentOffset;
     }];
}

- (void)transitionFromValidationToSettings
{
    
    [UIView animateWithDuration:0.5 animations:
     ^{
         self.constHeightStepOptions.constant = OPTIONS_VIEW_HEIGHT;
         [self.view layoutIfNeeded];
     }];
    [UIView animateWithDuration:0.5 animations:
     ^{
         for( UIView *element in stepValidateRemove )
             element.alpha = 1;
         
         self.tableView.transform = CGAffineTransformIdentity;
         CGRect tableRect = self.tableView.frame;
         tableRect.size.height = savedTableRect.size.height;
         self.tableView.frame = tableRect;
         
         for( UIView *element in stepValidationAlpha )
             element.alpha = 0.5;
         
         [self.btnTags.imageView setTintColor:[UIColor grayColor]];
         [self.btnDescription.imageView setTintColor:[UIColor grayColor]];
         
         //		 [self.scrollView setContentOffset:savedContentOffset animated:YES];
     }];
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

#pragma mark - UITextView
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.scrollEnabled = YES;
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
    textView.scrollEnabled = NO;
    textView.text = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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

- (IBAction)actClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actTags:(id)sender
{
    [UIView animateWithDuration:1.0f animations:^{
        [self.btnTags.imageView setTintColor:[UIColor whiteColor]];
        self.btnTagPresent.alpha = 1;
        for( UIControl *element in uiElementFirstBlock )
        {
            if( ![element isEqual:self.tagsView] )
                [element setAlpha:0];
        }
    } completion:^(BOOL finished){
         self.tfTags.hidden = NO;
         self.constHeightTagsView.constant = TAG_VIEW_HEIGHT_EDIT;
         [self.tfTags setText:@""];
         [self.tfTags becomeFirstResponder];
     }];
}

- (IBAction)actDescription:(id)sender
{
    [UIView animateWithDuration:1.0f animations:^{
        self.btnTagPresent.alpha = 0;
        self.btnTags.alpha = 0;
        for( UIControl *element in uiElementFirstBlock )
        {
            if( ![element isEqual:self.tfDescription] )
                [element setAlpha:0];
        }
    } completion:^(BOOL finished)
     {
         self.tfDescription.hidden = NO;
     }];
    
    [self.tfDescription becomeFirstResponder];
}

- (IBAction)actDrop:(id)sender
{
    //TODO: drop sur le serveur
}

- (IBAction)actTapOut:(id)sender
{
    if( [self.tfTags isFirstResponder] )
    {
        self.constHeightTagsView.constant = TAG_VIEW_HEIGHT_VISIBLE;
        [self.btnTags.imageView setTintColor:[UIColor grayColor]];
        [self.tfTags resignFirstResponder];
        activeField = nil;
    }
    else if( [self.tfDescription isFirstResponder] )
    {
        [self.tfDescription resignFirstResponder];
        activeField = nil;
    }
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
//    if( [self.tfTags isFirstResponder] )
//        convertedRect.origin.y += activeField.frame.size.height;
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
        self.btnTagPresent.alpha = 0;
        self.btnTagArrow.hidden = YES;
        for( UIView *element in uiElementFirstBlock )
            [element setAlpha:1];
        
        if( [self.tfDescription isFirstResponder] )
            self.btnTags.alpha = 1;
        
        self.btnDescription.alpha = !( self.tfDescription.text.length > 0 );
    }];
}
@end
