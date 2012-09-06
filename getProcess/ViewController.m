//
//  ViewController.m
//  getProcess
//
//  Created by Showyou Friends on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (iPad) 
        [usvViewStart setContentSize:CGSizeMake(2295, 800)];
    else {
        [usvViewStart setContentSize:CGSizeMake(960, 370)];
    }
    usvViewStart.pagingEnabled = YES;
    
    upcSelectPage.numberOfPages = 3;
    upcSelectPage.currentPage = 0;
}

- (void)viewDidUnload
{
    usvViewStart = nil;
    upcSelectPage = nil;
    btnLoginFace = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)doLogin:(id)sender {
    if (![[FacebookServices sharedFacebookServices] isAuthenticated]) {
        [[FacebookServices sharedFacebookServices] login];
    }
    
     [self getProcess];
}

-(void) getProcess {
    NSArray * processes = [[UIDevice currentDevice] getProcess];
    for (NSDictionary * dict in processes){
        NSLog(@"%@ - %@", [dict objectForKey:@"ProcessID"], [dict objectForKey:@"ProcessName"]);
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"process.plist"];
    
    if ([processes writeToFile:filePath atomically:YES]){
        NSLog(@"Save success");
    }
    else 
        NSLog(@"Save error");
}

#pragma mark - ScrollView delegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"scroll view");
    
    CGFloat pageWidth =  scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    upcSelectPage.currentPage = page;
    
    if (page == 2) {
        [btnLoginFace setBackgroundColor:[UIColor blueColor]];
    }
}

@end
