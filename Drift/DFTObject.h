//
//  DFTObject.h
//  Drift
//
//  Created by Thierry Ng on 03/12/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface DFTObject : MTLModel <MTLJSONSerializing>

+ (NSDateFormatter *)dateFormatter;

+ (MTLValueTransformer *)commonValueTransformerForDate;

@end
