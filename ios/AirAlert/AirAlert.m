/*
 * Copyright 2017 FreshPlanet
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "AirAlert.h"


@interface AirAlert ()
@property (nonatomic, readonly) FREContext context;
@end

@implementation AirAlert

- (instancetype)initWithContext:(FREContext)extensionContext {
    
    if ((self = [super init])) {
        
        _context = extensionContext;
    }
    
    return self;
}

- (void) sendLog:(NSString*)log {
    [self sendEvent:@"log" level:log];
}

- (void) sendEvent:(NSString*)code {
    [self sendEvent:code level:@""];
}

- (void) sendEvent:(NSString*)code level:(NSString*)level {
    FREDispatchStatusEventAsync(_context, (const uint8_t*)[code UTF8String], (const uint8_t*)[level UTF8String]);
}
@end

AirAlert* GetAirAlertContextNativeData(FREContext context) {
    
    CFTypeRef controller;
    FREGetContextNativeData(context, (void**)&controller);
    return (__bridge AirAlert*)controller;
}

DEFINE_ANE_FUNCTION(showAlert) {
    
    AirAlert* controller = GetAirAlertContextNativeData(context);
    
    if (!controller)
        return AirAlert_FPANE_CreateError(@"context's AirAlert is null", 0);
    
    @try {
        
        NSString *title = AirAlert_FPANE_FREObjectToNSString(argv[0]);
        NSString *message = AirAlert_FPANE_FREObjectToNSString(argv[1]);
        NSString *button1 = AirAlert_FPANE_FREObjectToNSString(argv[2]);
        NSString *button2 = argc > 3 ? AirAlert_FPANE_FREObjectToNSString(argv[3]) : nil;
        
        
        UIViewController* rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:title  message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:button1 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [rootViewController dismissViewControllerAnimated:YES completion:nil];
            [controller sendEvent:@"CLICK" level:@"0"];
        }]];
        if (button2 != nil) {
            [alertController addAction:[UIAlertAction actionWithTitle:button2 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [rootViewController dismissViewControllerAnimated:YES completion:nil];
                [controller sendEvent:@"CLICK" level:@"1"];
            }]];
        }
        
        [rootViewController presentViewController:alertController animated:YES completion:nil];
        
    }
    @catch (NSException *exception) {
        [controller sendLog:[@"Exception occured while trying to showAlert : " stringByAppendingString:exception.reason]];
    }
    
    
    
    return nil;
}

#pragma mark - ANE setup

void AirAlertContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
                                      uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet) {
    
    AirAlert* controller = [[AirAlert alloc] initWithContext:ctx];
    FRESetContextNativeData(ctx, (void*)CFBridgingRetain(controller));
    
    static FRENamedFunction functions[] = {
        MAP_FUNCTION(showAlert, NULL)
    };
    
    *numFunctionsToTest = sizeof(functions) / sizeof(FRENamedFunction);
    *functionsToSet = functions;
    
}

void AirAlertContextFinalizer(FREContext ctx) {
    CFTypeRef controller;
    FREGetContextNativeData(ctx, (void **)&controller);
    CFBridgingRelease(controller);
}

void AirAlertInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet ) {
    *extDataToSet = NULL;
    *ctxInitializerToSet = &AirAlertContextInitializer;
    *ctxFinalizerToSet = &AirAlertContextFinalizer;
}

void AirAlertFinalizer(void *extData) {}
