//
//  ATUtils.m
//  ATAuthFlutterPlugin
//
//  Created by ningcol on 2020/9/15.
//

#import "ATUtils.h"

@implementation ATUtils
//字典转JSON
+ (NSString *)dictionary2Json:(NSDictionary *)dict {
    NSError *err;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&err];
    if (err) {
        return err.description;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
