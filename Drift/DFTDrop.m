//
//  DFTDrop.m
//  Drift
//
//  Created by Thierry Ng on 24/11/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import "DFTDrop.h"
#import <Mantle.h>

#pragma mark
#pragma mark - JSON Keys

const NSString *kDFTModelKeyDropId = @"IdDrop";
const NSString *kDFTModelKeyDropLatitude = @"Latitude";
const NSString *kDFTModelKeyDropLongitude = @"Longitude";
const NSString *kDFTModelKeyDropDate = @"DateTime";
const NSString *kDFTModelKeyDropOwnerId = @"IdUser";
const NSString *kDFTModelKeyDropTitle = @"Title";
const NSString *kDFTModelKeyDropTags = @"TabTags";
const NSString *kDFTModelKeyDropDescription = @"Description";
const NSString *kDFTModelKeyDropPicture = @"Picture";
const NSString *kDFTModelKeyDropMapVisibility = @"MapVisibility";
const NSString *kDFTModelKeyDropContentVisibility = @"ContentVisibility";
const NSString *kDFTModelKeyDropLikes = @"Likes";
const NSString *kDFTModelKeyDropDrifts = @"Drifts";
const NSString *kDFTModelKeyDropShares = @"Share";

@implementation DFTDrop

#pragma mark
#pragma mark - De-serialization Protocol

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
	return (@{
			  NSStringFromSelector(@selector(dropId)) : kDFTModelKeyDropId,
			  NSStringFromSelector(@selector(latitude)) : kDFTModelKeyDropLatitude,
			  NSStringFromSelector(@selector(longitude)) : kDFTModelKeyDropLongitude,
			  NSStringFromSelector(@selector(dropDate)) : kDFTModelKeyDropDate,
			  NSStringFromSelector(@selector(ownerId)) : kDFTModelKeyDropOwnerId,
			  NSStringFromSelector(@selector(title)) : kDFTModelKeyDropTitle,
			  NSStringFromSelector(@selector(dropDescription)) :
				  kDFTModelKeyDropDescription,
			  NSStringFromSelector(@selector(backgroundPicture)) : kDFTModelKeyDropPicture,
			  NSStringFromSelector(@selector(dropTags)) : kDFTModelKeyDropTags,
//			  NSStringFromSelector(@selector(mapVisibility)) : kDFTModelKeyDropMapVisibility,
//			  NSStringFromSelector(@selector(contentVisibility)) : kDFTModelKeyDropContentVisibility,
			  NSStringFromSelector(@selector(likes)) : kDFTModelKeyDropLikes,
			  NSStringFromSelector(@selector(drifts)) : kDFTModelKeyDropDrifts,
			  NSStringFromSelector(@selector(shares)) : kDFTModelKeyDropShares,
			  });
}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key
{
	if ([key isEqualToString:NSStringFromSelector(@selector(dropDate))])
		return ([self commonValueTransformerForDate]);
	return (nil);
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error
{
	if (self = [super initWithDictionary:dictionaryValue error:error])
	{
		NSDictionary *array =
		@{
		  @"Une bouffe avec des potes, what else ?" : @"img-8",
		  @"Meilleure absinthe de Paris !" : @"img-4",
		  @"Un bon lit et un petit-dés hmm …" : @"img-3",
		  @"J’adore ma nouvelle couleur !" : @"img-5",
		  @"Retour en enfance" : @"img-6",
		  @"Le serveur m’a dédicacé le café :’D" : @"img-7",
		  @"Du savoir-faire à l’oeuvre" : @"img-1",
		  @"Avec mon chérie :D" : @"img-2",
		  @"Une pizza avec le sourire ! J’adore" : @"img-9",
		  @"Le rôle des start-up dans la croissance" : @"img-11",
		  @"No pain, no gain !" : @"img-14",
		  @"Best concert ever" : @"img-13",
		  @"Nike Run C4" : @"img-12",
		  @"Le chocolat et moi, une folle histoire d’amour …" : @"img-10"
		  };

		self.profilePicture = [UIImage imageNamed:array[self.title]];
		self.coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
	}
	return (self);
}

@end
