//
//  ViewController.h
//  getProcess
//
//  Created by Showyou Friends on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetProcess.h"
#import "Define.h"
#import "FacebookServices.h"

@interface ViewController : UIViewController <UIScrollViewDelegate>{
    
    __weak IBOutlet UIButton *btnLoginFace;
    __weak IBOutlet UIPageControl *upcSelectPage;
    __weak IBOutlet UIScrollView *usvViewStart;
}
- (IBAction)doLogin:(id)sender;

@end
