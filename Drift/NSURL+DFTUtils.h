//
//  NSURL+DFTUtils.h
//  Drift
//
//  Created by Thierry Ng on 17/11/2016.
//  Copyright © 2016 Thierry Ng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (DFTUtils)

+ (NSURL *)dft_baseURL:(NSString *)url secured:(BOOL)secured;

@end