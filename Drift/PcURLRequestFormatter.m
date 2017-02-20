//
//  PcURLRequestFormatter.m
//  AskNChatEvents
//
//  Created by Gwendal Roué on 27/01/2014.
//  Copyright (c) 2014 Qwiqa. All rights reserved.
//

#import "PcURLRequestFormatter.h"

@implementation PcURLRequestFormatter

- (instancetype)initWithOptions:(PcURLRequestFormatterOptions)options
{
    self = [self init];

    if (self)
		self.options = options;

    return self;
}

- (NSString *)stringForObjectValue:(id)object
{
    if (![object isKindOfClass:[NSURLRequest class]])
        return nil;
    return [self stringFromURLRequest:object];
}

- (NSString *)stringFromURLRequest:(NSURLRequest *)request
{
    return [self stringFromURLRequest:request URLSessionConfiguration:nil];
}

- (NSString *)stringFromURLRequest:(NSURLRequest *)request URLSessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    NSMutableString *string = [NSMutableString string];
    
    [string appendString:@"curl "];
    
    
    if (self.options & PcURLRequestOptionVerbose) {
        [string appendString:@"--verbose "];
        if (self.options & PcURLRequestOptionPretty) {
            [string appendString:@"\\\n     "];
        }
    }
    
    
    // HTTP method
    
    [string appendFormat:@"-X %@ ", request.HTTPMethod];
    if (self.options & PcURLRequestOptionPretty) {
        [string appendString:@"\\\n     "];
    }
    
    
    // HTTP headers
    
    [request.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        NSString *escapedKey = [self singleQuoteEscapedString:key];
        NSString *escapedValue = [self singleQuoteEscapedString:value];
        [string appendFormat:@"-H '%@:%@' ", escapedKey, escapedValue];
        if (self.options & PcURLRequestOptionPretty) {
            [string appendString:@"\\\n     "];
        }
    }];
    
    [configuration.HTTPAdditionalHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        NSString *escapedKey = [self singleQuoteEscapedString:key];
        NSString *escapedValue = [self singleQuoteEscapedString:value];
        [string appendFormat:@"-H '%@:%@' ", escapedKey, escapedValue];
        if (self.options & PcURLRequestOptionPretty) {
            [string appendString:@"\\\n     "];
        }
    }];
    
    
    // HTTP body
    
    if (request.HTTPBody) {
        // Assume UTF-8 encoding
        NSString *body = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
        if (body.length > 0) {
            NSString *escapedBody = [self singleQuoteEscapedString:body];
            [string appendFormat:@"-d '%@' ",escapedBody];
            if (self.options & PcURLRequestOptionPretty) {
                [string appendString:@"\\\n     "];
            }
        }
    }
    
    
    // URL
    
    [string appendString:[NSString stringWithFormat:@"'%@'",[self singleQuoteEscapedString:request.URL.absoluteString]]];
    
    return string;
}

- (NSString *)singleQuoteEscapedString:(NSString *)string
{
    return [string stringByReplacingOccurrencesOfString:@"'" withString:@"'\\''"];
}

@end
