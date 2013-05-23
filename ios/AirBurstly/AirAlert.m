//////////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Freshplanet (http://freshplanet.com | opensource@freshplanet.com)
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//////////////////////////////////////////////////////////////////////////////////////

#import "AirAlert.h"

FREContext AirAlertCtx = nil;

@interface AirAlert ()

@property (nonatomic, strong) UIAlertView *alertView;

@end

@implementation AirAlert

#pragma mark - Singleton

static AirAlert *sharedInstance = nil;

+ (AirAlert *)sharedInstance
{
    if (!sharedInstance)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return self;
}

#pragma mark - NSObject

- (void)dealloc
{
    self.alertView = nil;
    [super dealloc];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    FREDispatchStatusEventAsync(AirAlertCtx, (const uint8_t *)"CLICK", (const uint8_t *)[[NSString stringWithFormat:@"%u", buttonIndex] UTF8String]);
}

@end


#pragma mark - C interface

DEFINE_ANE_FUNCTION(AirAlertShowAlert)
{
    uint32_t stringLength;
    
    NSString *title = nil;
    NSString *message = nil;
    NSString *button1 = nil;
    NSString *button2 = nil;
    
    // Retrieve title
    const uint8_t *titleString;
    if (FREGetObjectAsUTF8(argv[0], &stringLength, &titleString) == FRE_OK)
    {
        title = [NSString stringWithUTF8String:(char *)titleString];
    }
    
    // Retrieve message
    const uint8_t *messageString;
    if (FREGetObjectAsUTF8(argv[1], &stringLength, &messageString) == FRE_OK)
    {
        message = [NSString stringWithUTF8String:(char *)messageString];
    }
    
    // Retrieve button 1
    const uint8_t *button1String;
    if (FREGetObjectAsUTF8(argv[2], &stringLength, &button1String) == FRE_OK)
    {
        button1 = [NSString stringWithUTF8String:(char *)button1String];
    }
    
    // Retrieve button 2
    if (argc > 3)
    {
        const uint8_t *button2String;
        if (FREGetObjectAsUTF8(argv[3], &stringLength, &button2String) == FRE_OK)
        {
            button2 = [NSString stringWithUTF8String:(char *)button2String];
        }
    }
    
    // Setup and show the alert
    __block UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:[AirAlert sharedInstance] cancelButtonTitle:button1 otherButtonTitles:nil];
    if (button2) [alertView addButtonWithTitle:button2];
    [[AirAlert sharedInstance] setAlertView:alertView];
    [alertView release];
    
    // We had cases of deadlock when calling directly [alertView show] on iOS 5.
    // When this happens, the app freezes completely without crashing, and the popup is not displayed.
    //
    // Explicitely calling [alertView show] on the main thread fixes the issue. ANE functions are
    // supposed to be called on the main thread so we shouldn't need to do this... But hey, it works!
    //
    // Tested on an iPod Touch (2010) on iOS 5.1.1 with AIR 3.6, AIR 3.7 and AIR 3.8b.
    //
    // Console logs:
    //      <Warning>: *** -[NSLock lock]: deadlock (<NSLock: 0xd5d420> '(null)')
    //      <Warning>: *** Break on _NSLockError() to debug.
    dispatch_async(dispatch_get_main_queue(), ^{
        [alertView show];
    });
    
    return nil;
}


#pragma mark - ANE setup

void AirAlertContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    // Register the links btwn AS3 and ObjC. (dont forget to modify the nbFuntionsToLink integer if you are adding/removing functions)
    NSInteger nbFuntionsToLink = 1;
    *numFunctionsToTest = nbFuntionsToLink;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * nbFuntionsToLink);
    
    func[0].name = (const uint8_t*) "AirAlertShowAlert";
    func[0].functionData = NULL;
    func[0].function = &AirAlertShowAlert;
    
    *functionsToSet = func;
    
    AirAlertCtx = ctx;
}

void AirAlertContextFinalizer(FREContext ctx) { }

void AirAlertInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
	*extDataToSet = NULL;
	*ctxInitializerToSet = &AirAlertContextInitializer;
	*ctxFinalizerToSet = &AirAlertContextFinalizer;
}

void AirAlertFinalizer(void* extData) { }