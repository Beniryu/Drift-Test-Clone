//
//  DropFormManager.m
//  Drift
//
//  Created by Thierry Ng on 05/03/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import "DFTDropFormManager.h"

@implementation DFTDropFormManager

- (NSInteger)routeSwipeDirection:(kDFTDropFormSwipeDirection)direction
					 fromSection:(NSInteger)section
					   withBlock:(DFTDropFormTransitionBlock)block
{
	kDFTDropFormStepTransition transition;

	if (direction == kDFTDropFormSwipeDirectionUp)
	{
		switch (section)
		{
			case 0:
				transition = kDFTDropFormStepTransitionDetailsToSettings;
				section += 1;
				break;
			case 1:
				transition = kDFTDropFormStepTransitionSettingsToValidation;
				section += 1;
				break;
			default:
				break;
		}
	}
	else
	{
		switch (section)
		{
			case 1:
				transition = kDFTDropFormStepTransitionSettingsToDetails;
				section -= 1;
				break;
			case 2:
				transition = kDFTDropFormStepTransitionValidationToSettings;
				section -= 1;
				break;
			default:
				break;
		}
	}
	block(transition);
	return (section);
}

@end
