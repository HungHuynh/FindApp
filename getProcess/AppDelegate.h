//
//  AppDelegate.h
//  getProcess
//
//  Created by Showyou Friends on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppViewController.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    AppViewController *appView;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

-(void)goMainView;

@end
