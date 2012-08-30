//
//  IPenController.h
//  iNpen
//
//  Created by Lin Chuankai on 8/24/12.
//  Copyright (c) 2012 KILAB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPenController : NSObject

+ (id)sharedController;
- (void)start;
- (void)stop;

@end
