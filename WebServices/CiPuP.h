//
//  CiPuP.h
//  WebServices
//
//  Created by Marian PAUL on 22/03/12.
//  Copyright (c) 2012 iPuP SARL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface CiPuP : NSObject
+(void) displayAlertWithMessage:(NSString *)message;
+(BOOL) isNetworkAvailable;
@end
