//
//  AppViewController.h
//  getProcess
//
//  Created by Showyou Friends on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Define.h"
#import "GetProcess.h"

@interface AppViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *utbMyApp;
    
    NSArray * arrProcess;
}

@end
