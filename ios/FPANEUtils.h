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
#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"
#import <UIKit/UIKit.h>

#define DEFINE_ANE_FUNCTION(fn) FREObject fn(FREContext context, void* functionData, uint32_t argc, FREObject argv[])
#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }
#define ROOT_VIEW_CONTROLLER [[[UIApplication sharedApplication] keyWindow] rootViewController]

void AirAlert_FPANE_DispatchEvent(FREContext context, NSString* eventName);
void AirAlert_FPANE_DispatchEventWithInfo(FREContext context, NSString* eventName, NSString* eventInfo);
void AirAlert_FPANE_Log(FREContext context, NSString* message);

NSString* AirAlert_FPANE_FREObjectToNSString(FREObject object);
NSArray* AirAlert_FPANE_FREObjectToNSArrayOfNSString(FREObject object);
NSDictionary* AirAlert_FPANE_FREObjectsToNSDictionaryOfNSString(FREObject keys, FREObject values);
BOOL AirAlert_FPANE_FREObjectToBool(FREObject object);
NSInteger AirAlert_FPANE_FREObjectToInt(FREObject object);
double AirAlert_FPANE_FREObjectToDouble(FREObject object);

FREObject AirAlert_FPANE_BOOLToFREObject(BOOL boolean);
FREObject AirAlert_FPANE_IntToFREObject(NSInteger i);
FREObject AirAlert_FPANE_DoubleToFREObject(double d);
FREObject AirAlert_FPANE_NSStringToFREObject(NSString* string);
FREObject AirAlert_FPANE_CreateError(NSString* error, NSInteger* id);
FREObject AirAlert_FPANE_UIImageToFREBitmapData(UIImage *image);
FREObject AirAlert_FPANE_UIImageToFREByteArray(UIImage *image);

UIImage* AirAlert_FPANE_FREBitmapDataToUIImage(FREObject object);
NSArray* AirAlert_FPANE_FREObjectToNSArrayOfUIImage(FREObject object);
