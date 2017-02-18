//
//  UIViewController+FPS.m
//  BigFan
//
//  Created by hechao on 16/12/2.
//  Copyright © 2016年 hc. All rights reserved.
//

#import "UIViewController+FPS.h"
#import "HCFPSHelper.h"
#import <objc/runtime.h>

static NSArray *_ignoreControllers;
static const char Params_Key;

@implementation UIViewController (FPS)

+ (void)load
{
#if DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method didLoadMethod = class_getInstanceMethod(self, @selector(viewDidLoad));
        Method fps_didLoadMethod = class_getInstanceMethod(self, @selector(fps_viewDidLoad));
        method_exchangeImplementations(didLoadMethod, fps_didLoadMethod);
        
        Method viewWillDisappearMethod = class_getInstanceMethod(self, @selector(viewWillDisappear:));
        Method fps_viewWillDisappearMethod = class_getInstanceMethod(self, @selector(fps_viewWillDisappear:));
        method_exchangeImplementations(viewWillDisappearMethod, fps_viewWillDisappearMethod);
    });
#endif
}

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ignoreControllers = @[@"UICompatibilityInputViewController",
                              @"UIAlertController",
                              @"UISplitViewController",
                              @"UIInputWindowController"];
    });
}

- (void)fps_viewDidLoad
{
    [self fps_viewDidLoad];
    //这个弹出的控件，不要统计
    if ([_ignoreControllers containsObject:NSStringFromClass([self class])])
    {
        return;
    }
    [[HCFPSHelper sharedInstance] enterPage:NSStringFromClass([self class])];
}

- (void)fps_viewWillDisappear:(BOOL)animated
{
    [self fps_viewWillDisappear:animated];
    if ([_ignoreControllers containsObject:NSStringFromClass([self class])])
    {
        return;
    }
    [[HCFPSHelper sharedInstance] leavePage:NSStringFromClass([self class])];
}

#pragma mark - Getter && Setter

- (void)setParams:(id)params
{
    objc_AssociationPolicy policy;
    if ([params isKindOfClass:[NSObject class]])
    {
        policy = OBJC_ASSOCIATION_COPY;
    }else
    {
        policy = OBJC_ASSOCIATION_ASSIGN;
    }
    objc_setAssociatedObject(self, &Params_Key, params, policy);
}

- (id)params
{
    return objc_getAssociatedObject(self, &Params_Key);
}

@end
