//
//  DFTSegmentedControl.m
//  Drift
//
//  Created by Jonathan Nguyen on 02/03/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTSegmentedControl.h"
#import "UIColor+DFTStyles.h"


@interface DFTSegmentedControl() <DFTSegmentedControlDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic) UIView *currentSegmentedIndexView;
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger segmentWidth;

@end

@implementation DFTSegmentedControl
@synthesize delegate;

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor dft_salmonColor];
    self.tintColor = [UIColor clearColor];
    self.layer.cornerRadius = self.frame.size.height / 2.;
    self.segmentWidth = ceil(self.segmentedControl.bounds.size.width / self.segmentedControl.numberOfSegments);
    [self.segmentedControl addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self prepareCurrentSegmentedIndexView];
   }

- (void)prepareCurrentSegmentedIndexView
{
    /* Preparing currentSegmentedView:
     It corresponds to the view that is animated to expand and move on selected index
     */
    self.currentSegmentedIndexView = [UIView new];
    self.currentSegmentedIndexView.backgroundColor = [UIColor dft_darkRedColor];
    CGRect segmentedControlFrame = self.segmentedControl.bounds;
    segmentedControlFrame.size.width = self.segmentWidth;
    self.currentSegmentedIndexView.frame = segmentedControlFrame;
    self.currentSegmentedIndexView.layer.cornerRadius = self.segmentWidth / 2;
    [self.segmentedControl addSubview:self.currentSegmentedIndexView];
}

- (void)valueChanged:(id)sender
{
    // Final frame
    CGRect finalSelectedIndexFrame = self.currentSegmentedIndexView.bounds;
    finalSelectedIndexFrame.origin.x = self.segmentWidth * self.segmentedControl.selectedSegmentIndex;
    
    // Temporary frame for animation
    CGRect expandAnimationTemporaryFrame = self.currentSegmentedIndexView.frame;
    
    BOOL isForwardAnimating = self.currentPage < self.segmentedControl.selectedSegmentIndex;
    NSInteger indexDifference = labs(self.segmentedControl.selectedSegmentIndex - self.currentPage);
    NSInteger expandingWidth = expandAnimationTemporaryFrame.size.width * (isForwardAnimating ? (indexDifference + 1) : indexDifference);
    
    if (!isForwardAnimating)
    {
        expandAnimationTemporaryFrame.origin.x -= expandingWidth;
        expandAnimationTemporaryFrame.size.width += expandingWidth;
    } else
    {
        expandAnimationTemporaryFrame.size.width = expandingWidth;
    }

    // Animation: expand then set final size
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.currentSegmentedIndexView.frame = expandAnimationTemporaryFrame;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              self.currentSegmentedIndexView.frame = finalSelectedIndexFrame;
                                          }];
                     }];
    self.currentPage = self.segmentedControl.selectedSegmentIndex;
    
    [delegate segmentedControlValueChanged:self.segmentedControl.selectedSegmentIndex];
}





@end
