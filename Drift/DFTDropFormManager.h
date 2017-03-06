//
//  DropFormManager.h
//  Drift
//
//  Created by Thierry Ng on 05/03/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFTDropFormManager : NSObject

typedef NS_ENUM(NSUInteger, kDFTDropFormSwipeDirection)
{
	kDFTDropFormSwipeDirectionUp,
	kDFTDropFormSwipeDirectionDown
};

typedef NS_ENUM(NSUInteger, kDFTDropFormStepTransition)
{
	kDFTDropFormStepTransitionDetailsToSettings,
	kDFTDropFormStepTransitionSettingsToValidation,
	kDFTDropFormStepTransitionValidationToSettings,
	kDFTDropFormStepTransitionSettingsToDetails
};

typedef void (^DFTDropFormTransitionBlock)(kDFTDropFormStepTransition transition);

- (NSInteger)routeSwipeDirection:(kDFTDropFormSwipeDirection)direction
					 fromSection:(NSInteger)section
					   withBlock:(DFTDropFormTransitionBlock)block;

@end
