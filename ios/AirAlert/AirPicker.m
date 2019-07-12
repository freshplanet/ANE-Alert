//
//  AirPicker.m
//  AirAlert
//
//  Created by Mateo Kozomara on 09/07/2019.
//  Copyright © 2019 Mateo Kozomara. All rights reserved.
//

#import "AirPicker.h"

@interface AirPicker () {
}

@property(nonatomic, assign) FREContext context;
@property(nonatomic, assign) NSArray *items;
@property(nonatomic, assign) UIToolbar *toolbar;
@property(nonatomic, assign) UIPickerView *pickerView;

@end

@implementation AirPicker

@synthesize context;

- (id)initWithContext:(FREContext)extensionContext frame:(CGRect)frame doneLabel:(NSString*)doneLabel cancelLabel:(NSString*)cancelLabel items:(NSArray*)items {
    
    self = [super init];
    
    CGFloat toolbarHeight = 44.0;
    frame.size.height -= toolbarHeight;
    frame.origin.y += toolbarHeight;
    
    _items = [[NSArray alloc] initWithArray:items];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:frame];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.showsSelectionIndicator = true;
    _pickerView.backgroundColor = UIColor.whiteColor;
    
    _toolbar = [[UIToolbar alloc] init];
    _toolbar.frame = CGRectMake(frame.origin.x, frame.origin.y-toolbarHeight, frame.size.width, toolbarHeight);
    _toolbar.barStyle = UIBarStyleBlackTranslucent;
    _toolbar.userInteractionEnabled = true;
    _toolbar.tintColor = UIColor.whiteColor;
    
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc] initWithTitle:cancelLabel
                                                                   style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(cancelClicked)];
    
    UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:doneLabel
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(doneClicked)];

    [_toolbar setItems:[NSArray arrayWithObjects:cancelButton, flexibleSpaceLeft, doneButton, nil]];
    
    if (self) {
        self.context = extensionContext;
    }
    
    return self;
}

-(void)hidePicker
{
    if(_toolbar)
        [_toolbar removeFromSuperview];
    if(_pickerView)
        [_pickerView removeFromSuperview];
}

-(void)showPicker
{
    UIViewController* rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootViewController.view addSubview:_pickerView];
    [rootViewController.view addSubview:_toolbar];
}

-(void)doneClicked
{
    NSInteger row = [_pickerView selectedRowInComponent:0];
    NSString *value = _items[row];
    [self hidePicker];
    [self sendEvent:@"PICKER_SELECTED" level:value];
   
}

-(void)cancelClicked
{
    [self hidePicker];
    [self sendEvent:@"PICKER_CANCELED"];
}

- (void)dealloc {
    [self hidePicker];
    
    if(_pickerView) {
        _pickerView.dataSource = nil;
        _pickerView.delegate = nil;
    }
    
    [super dealloc];
}

# pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _items.count;
}

# pragma mark - UIPickerViewDelegate

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _items[row];
}

- (void) sendEvent:(NSString*)code {
    [self sendEvent:code level:@""];
}

- (void) sendEvent:(NSString*)code level:(NSString*)level {
    FREDispatchStatusEventAsync(context, (const uint8_t*)[code UTF8String], (const uint8_t*)[level UTF8String]);
}

@end

AirPicker* GetAirPickerContextNativeData(FREContext context) {
    
    CFTypeRef controller;
    FREGetContextNativeData(context, (void**)&controller);
    return (__bridge AirPicker*)controller;
}

DEFINE_ANE_FUNCTION(picker_init) {
    
    @try {
        CGFloat screenScale = [UIScreen mainScreen].scale;
        NSString *doneLabel = AirAlert_FPANE_FREObjectToNSString(argv[0]);
        NSString *cancelLabel = AirAlert_FPANE_FREObjectToNSString(argv[1]);
        NSInteger xPos = AirAlert_FPANE_FREObjectToInt(argv[2]) / screenScale;
        NSInteger yPos = AirAlert_FPANE_FREObjectToInt(argv[3]) / screenScale;
        NSInteger width = AirAlert_FPANE_FREObjectToInt(argv[4]) / screenScale;
        NSInteger height = AirAlert_FPANE_FREObjectToInt(argv[5]) / screenScale;
        NSArray *items = AirAlert_FPANE_FREObjectToNSArrayOfNSString(argv[6]);
      
        AirPicker* picker = [[AirPicker alloc] initWithContext:context frame:CGRectMake(xPos, yPos, width, height) doneLabel:doneLabel cancelLabel:cancelLabel items:items];
        
        FRESetContextNativeData(context, (__bridge void*)(picker));
        
    }
    @catch (NSException *exception) {}
    
    return nil;
}

DEFINE_ANE_FUNCTION(picker_show) {
    
    @try {
        AirPicker* controller = GetAirPickerContextNativeData(context);

        if (!controller || controller.toolbar == nil || controller.pickerView == nil)
            return AirAlert_FPANE_CreateError(@"context's AirPicker is null or toolbar is null", 0);

        [controller showPicker];
        
    }
    @catch (NSException *exception) {
        NSLog([@"AirPicker ERROR  " stringByAppendingString:exception.reason]);
    }
    
   
    
    return nil;
}

DEFINE_ANE_FUNCTION(picker_hide) {
    
    AirPicker* controller = GetAirPickerContextNativeData(context);
    
    if (!controller || controller.toolbar == nil || controller.pickerView == nil)
        return AirAlert_FPANE_CreateError(@"context's AirPicker is null", 0);
    
    [controller hidePicker];
    
    
   return nil;
}

# pragma mark - list functions

void AirPickerListFunctions(const FRENamedFunction** functionsToSet, uint32_t* numFunctionsToSet) {
    
    static FRENamedFunction functions[] = {
        MAP_FUNCTION(picker_init, NULL),
        MAP_FUNCTION(picker_show, NULL),
        MAP_FUNCTION(picker_hide, NULL)
    };
    
    *numFunctionsToSet = sizeof(functions) / sizeof(FRENamedFunction);
    *functionsToSet = functions;
}

