//
//  DFTFeedContainerViewController.h
//  Drift
//
//  Created by Thierry Ng on 10/01/2017.
//  Copyright © 2017 Thierry Ng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, kScrollDirection)
{
	ScrollDirectionNone,
	ScrollDirectionRight,
	ScrollDirectionLeft,
	ScrollDirectionUp,
	ScrollDirectionDown,
	ScrollDirectionCrazy,
};


typedef enum FeedType : NSInteger {
    GlobalFeed = 0,
    InnerFeed = 1,
    CollectionFeed = 2
} FeedType;


@protocol DFTFeedScreenProtocol <NSObject>

- (void)feedScreenDidScroll:(CGFloat)offset;

@end

@interface DFTFeedContainerViewController : UIViewController <DFTFeedScreenProtocol>

@end
