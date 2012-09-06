//
//  AppViewController.m
//  getProcess
//
//  Created by Showyou Friends on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppViewController.h"

@interface AppViewController ()

@end

@implementation AppViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    arrProcess = [[UIDevice currentDevice] getProcess];
    
    //[[NSThread mainThread] setThreadPriority:1.0];
    //[self performSelectorInBackground:@selector(getProcess:) withObject:arrProcess];
}

-(void)getProcess:(NSArray*)processArray {
    processArray = [[UIDevice currentDevice] getProcess];
    
    [utbMyApp reloadData];
    [self performSelectorOnMainThread:@selector(loadData) withObject:nil waitUntilDone:NO];
}

-(void)loadData {
    [utbMyApp reloadData];
}

- (void)viewDidUnload
{
    [utbMyApp release];
    utbMyApp = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)dealloc {
    [utbMyApp release];
    [super dealloc];
}

#pragma mark - TableView DataSource

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrProcess count];
}

#pragma mark - TableView Delegate

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    if (cell != nil) {
        cell.textLabel.text = [[arrProcess objectAtIndex:indexPath.row] objectForKey:@"ProcessName"]; // ProcessID
        cell.detailTextLabel.text = [[arrProcess objectAtIndex:indexPath.row] objectForKey:@"ProcessName"];
        [cell.imageView setImage:[UIImage imageNamed:@""]];
    }
    
    
    return cell;
}

@end
