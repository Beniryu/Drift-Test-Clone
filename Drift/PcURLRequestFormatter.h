//
//  PcURLRequestFormatter.h
//  AskNChatEvents
//
//  Created by Gwendal Roué on 27/01/2014.
//  Copyright (c) 2014 Qwiqa. All rights reserved.
//

#import <Foundation/Foundation.h>


//==============================================================================
#pragma mark - PcURLRequestFormatter options

typedef NS_OPTIONS(NSUInteger, PcURLRequestFormatterOption) {
    PcURLRequestOptionVerbose   = 1 << 0,   // Adds the `--verbose` option to the curl command.
    PcURLRequestOptionPretty    = 1 << 1,   // Adds newlines so that the curl command is easier to the human eye.
};
typedef NSUInteger PcURLRequestFormatterOptions;


//==============================================================================
#pragma mark - PcURLRequestFormatter

@interface PcURLRequestFormatter : NSFormatter
@property (nonatomic) PcURLRequestFormatterOptions options;

// convenience initializer
- (instancetype)initWithOptions:(PcURLRequestFormatterOptions)options;

- (NSString *)stringFromURLRequest:(NSURLRequest *)request;
- (NSString *)stringFromURLRequest:(NSURLRequest *)request URLSessionConfiguration:(NSURLSessionConfiguration *)configuration;
@end
