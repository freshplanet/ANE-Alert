//
//  AirPicker.h
//  AirAlert
//
//  Created by Mateo Kozomara on 09/07/2019.
//  Copyright © 2019 Mateo Kozomara. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FPANEUtils.h"


@interface AirPicker : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

@end

void AirPickerListFunctions(const FRENamedFunction** functionsToSet, uint32_t* numFunctionsToSet);


