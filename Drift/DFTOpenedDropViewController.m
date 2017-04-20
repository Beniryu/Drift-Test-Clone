//
//  DFTOpenedDropViewController.m
//  Drift
//
//  Created by Clément Georgel on 17/04/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTOpenedDropViewController.h"
#import <UIImageView+WebCache.h>
#import "ImageUtils.h"

@interface DFTOpenedDropViewController ()
{
    @private
    NSArray *optionPanelToAnimate;
}
@end

@implementation DFTOpenedDropViewController

@synthesize drop;

static const double OPTION_PANEL_TIMER          = 0.3;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_btnClose.imageView setTintColor:[UIColor lightGrayColor]];
    [self configureDetails];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)configureDetails
{
    if( drop )
    {
        optionPanelToAnimate = @[_vMarkIt, _vShareIt, _vJoinIt, _vBack];
        [_imgPlaceholder sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://drift.braycedenayce.com/drift_api/drop/pic/%@", drop.dropId]]];
        _imgPlaceholder.contentMode = UIViewContentModeScaleAspectFill;
        _imgPlaceholder.frame = _imgPlaceholder.frame;
        _imgPlaceholder.layer.cornerRadius = 6.;
        _imgPlaceholder.clipsToBounds = YES;
        _imgPlaceholder.alpha = 1;
        
        _lblNbLikes.text = [NSString stringWithFormat:@"%d", (int)drop.likes];
        _lblNbDrifters.text = [NSString stringWithFormat:@"%d", (int)drop.drifts];
        _lblNbShares.text = [NSString stringWithFormat:@"%d", (int)drop.shares];
        
        _lblNameEvent.text = drop.title;
        _lblDay.text = @"24";//[dateDayFormatter stringFromDate:drop.dropDate];
        _lblMonth.text = @"APR";//[dateMonthFormatter stringFromDate:drop.dropDate];
        
        _imgProfil.image = drop.profilePicture;
        [ImageUtils roundedBorderImageView:_imgProfil];
        
        [ImageUtils roundedBorderImageView:_imgDrifter1];
        [ImageUtils roundedBorderImageView:_imgDrifter2];
        [ImageUtils roundedBorderImageView:_imgDrifter3];
    }
}

#pragma mark - IBAction

- (IBAction)actCloseDrop:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Menu

- (IBAction)actExpandMenu:(id)sender
{
    [UIView animateWithDuration:0.8
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _vMenuRight.frame = _vMenuPlaceholder.frame;
                     } completion:^(BOOL finished){
                     }];
    
    for(int i = 0; i < optionPanelToAnimate.count; i++ )
    {
        int index = ((int)optionPanelToAnimate.count)-1-i;
        [UIView animateWithDuration:OPTION_PANEL_TIMER
                              delay:(OPTION_PANEL_TIMER * i)
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             ((UIView *)optionPanelToAnimate[index]).alpha = 1;
                         } completion:nil];
    }
}

- (IBAction)actMarkIt:(id)sender
{
    for(int i = 0; i < optionPanelToAnimate.count; i++ )
    {
        [UIView animateWithDuration:OPTION_PANEL_TIMER
                              delay:(OPTION_PANEL_TIMER * i)
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             ((UIView *)optionPanelToAnimate[i]).alpha = 0;
                         } completion:nil];
    }
    
    [UIView animateWithDuration:0.5
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _vMenuRight.frame = _vMenuOrigin.frame;
                     } completion:nil];
}
@end
