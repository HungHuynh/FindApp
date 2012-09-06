//
//  GetProcess.m
//  getProcess
//
//  Created by Showyou Friends on 9/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GetProcess.h"
#import <sys/sysctl.h>

@implementation UIDevice (GetProcess)

-(NSArray*)getProcess {
    
    //Init 4 mib 
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t miblen = 4;
    
    //size 
    size_t size;
    int st = sysctl(mib, miblen, NULL, &size, NULL, 0);
    
    //Create struct for process 
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
    
    //Replay get process 
    do {
        
        size += size / 10;
        newprocess = realloc(process, size);
        
        if (!newprocess){
            
            if (process){
                free(process);
            }
            
            return nil;
        }
        
        process = newprocess;
        st = sysctl(mib, miblen, process, &size, NULL, 0);
        
    } while (st == -1 && errno == ENOMEM);
    
    
    //Get name process : 
    if (st == 0){
        
        //Get number process 
        if (size % sizeof(struct kinfo_proc) == 0){
            int nprocess = size / sizeof(struct kinfo_proc);
            
            //get information from process 
            if (nprocess){
                
                NSMutableArray * array = [[NSMutableArray alloc] init];
                
                for (int i = nprocess - 1; i >= 0; i--){
                    
                    NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
                    NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
                    
                    NSDictionary * dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:processID, processName, nil] 
                                                                        forKeys:[NSArray arrayWithObjects:@"ProcessID", @"ProcessName", nil]];
                    [array addObject:dict];
                    //[processID release];
                    //[processName release];
                    //[dict release];
                }
                
                free(process);
                
                return array; //[array autorelease];
            }
        }
    }
    
    return nil;
}

@end
