//
//  DFTDrop.h
//  Drift
//
//  Created by Thierry Ng on 24/11/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapbox/Mapbox.h>
#import <UIKit/UIKit.h>
#import "DFTObject.h"

typedef NS_ENUM(NSUInteger, kDFTDropPrivacyLevel)
{
	kDFTDropPrivacyLevelPublic,
	kDFTDropPrivacyLevelFriends,
	kDFTDropPrivacyLevelCustom
};

@interface DFTDrop : DFTObject <MGLAnnotation>

@property (nonatomic) NSNumber *dropId;
@property (nonatomic) NSNumber *ownerId;

@property (nonatomic, copy) NSString *title;
@property (nonatomic) NSDate *dropDate;
@property (nonatomic) NSString *backgroundPicture;
@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;

//@property (nonatomic) kDFTDropPrivacyLevel mapVisibility;
//@property (nonatomic) kDFTDropPrivacyLevel contentVisibility;

@property (nonatomic) NSUInteger likes;
@property (nonatomic) NSUInteger drifts;
@property (nonatomic) NSUInteger shares;

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) UIImage *profilePicture;

@end
