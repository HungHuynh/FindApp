

#import "FacebookServices.h"
#import "SynthesizeSingleton.h"
//#import "UIImage+Resize.h"

@implementation FacebookServices

SYNTHESIZE_SINGLETON_FOR_CLASS(FacebookServices)

@synthesize facebook;

/**
 * Login.
 */
- (void)login {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!facebook){
        facebook = [[Facebook alloc] initWithAppId:FacebookApplicationId];
        facebook.sessionDelegate = self;
        permissions =  [[NSArray arrayWithObjects:
                         @"email", 
                         @"read_stream", 
                         @"user_about_me", 
                         @"user_events", 
                         @"friends_events", 
                         @"publish_stream", 
                         @"offline_access", nil] retain];
    }

    facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
    
    facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    
    // only authorize if the access token isn't valid
    // if it *is* valid, no need to authenticate. just move on
    if (![facebook isSessionValid]) {
        [facebook authorize:permissions delegate:self];
    }
}

- (BOOL)isAuthenticated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!facebook){
        facebook = [[Facebook alloc] initWithAppId:FacebookApplicationId];
        facebook.sessionDelegate = self;
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        permissions =  [[NSArray arrayWithObjects:
                         @"email", 
                         @"read_stream", 
                         @"user_about_me", 
                         @"user_events", 
                         @"friends_events", 
                         @"publish_stream", 
                         @"offline_access", nil] retain];
    }
    return [facebook isSessionValid];
}


#pragma mark -
#pragma mark FBSessionDelegate

- (void)fbDidLogin {

    NSLog(@"Facebook Did Log In");
    NSLog(@"Access Token is %@", facebook.accessToken );
    NSLog(@"Expiration Date is %@", facebook.expirationDate );

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];

    [[NSNotificationCenter defaultCenter]postNotificationName:FacebookNotification object:nil];

}

- (void)fbDidNotLogin:(BOOL)cancelled {
    [[NSNotificationCenter defaultCenter]postNotificationName:NotificationFBNotLogin object:nil];
}

- (void)getUserInfo {
    [facebook requestWithGraphPath:@"me" andDelegate:self];
}

- (void)postToFeed:(NSString*)message {
    
    NSArray *obj = [NSArray arrayWithObjects:message, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"message", nil];
    
    // There are many other params you can use, check the API
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:obj forKeys:keys];
    
    [facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:self];
}

- (void)postToFeedWithParams:(NSMutableDictionary*)params {
    
    [facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:nil];
}

- (void)likeToFeed:(NSString*)message {
    
    NSArray *obj = [NSArray arrayWithObjects:message, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"message", nil];
    
    // There are many other params you can use, check the API
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:obj forKeys:keys];
    
    [facebook requestWithGraphPath:@"me/feed" andParams:params andHttpMethod:@"POST" andDelegate:nil];
}

-(void)getEvents {

    NSArray *obj = [NSArray arrayWithObjects:@"25",@"id,owner,name,description,start_time,end_time,location,venue,privacy,updated_time", nil];
    NSArray *keys = [NSArray arrayWithObjects:@"limit",@"fields", nil];
    
    // There are many other params you can use, check the API
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjects:obj forKeys:keys];

    [facebook requestWithGraphPath:@"me/events" andParams:params andHttpMethod:@"GET" andDelegate:self];
    
}

- (void)getEvent:(NSString*)id {

    [facebook requestWithGraphPath:id andParams:nil andHttpMethod:@"GET" andDelegate:self];

}

-(void)postImageToAlbum:(UIImage *)image withDesc:(NSString*) aDesc{
    //UIImage *imgPost = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(image.size.width/2,image.size.height/2) interpolationQuality:kCGInterpolationHigh];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   image, @"source",
                                   aDesc, @"message",
                                   nil];
    [facebook requestWithGraphPath:[NSString stringWithFormat:@"/me/photos?access_token=%@", self.facebook.accessToken]
                         andParams:params andHttpMethod:@"POST" andDelegate:self];
}



////////////////////////////////////////////////////////////////////////////////
// FBRequestDelegate

/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"Inside didReceiveResponse: received response");
    //NSLog(@"Status Code @", [response statusCode]);
    NSLog(@"URL %@", [response URL]);
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"Inside didLoad");
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPostFBSuccessful object:nil];
//    if ([result isKindOfClass:[NSArray class]]) {
//        result = [result objectAtIndex:0];
//    }
//    // When we ask for user infor this will happen.
//    if ([result isKindOfClass:[NSDictionary class]]){
//
//        if ([[request url] rangeOfString:@"/events"].location != NSNotFound) {
//            // Events info
//            //DLog(@"data FB event =>%@", result);
//
//        }
//        else if ([[request url] rangeOfString:@"/me"].location != NSNotFound) {
//            // Profile info
//                      
//        }
//        else {
//            
//            // Event Detail?
//            NSLog(@"Event Details?");
//
//        }
//        
//
//        
//    }
//    if ([result isKindOfClass:[NSData class]])
//    {
//        NSLog(@"Profile Picture");
//        //[profilePicture release];
//        //profilePicture = [[UIImage alloc] initWithData: result];
//    }
//    NSLog(@"request returns %@",result);
    [defaults synchronize];
    
};

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: request returns %@",[error localizedDescription]);
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationPostFBFail object:NO];
};


////////////////////////////////////////////////////////////////////////////////
// FBDialogDelegate

/**
 * Called when a UIServer Dialog successfully return.
 */
- (void)dialogDidComplete:(FBDialog *)dialog {
    //[self.label setText:@"publish successfully"];
}



#pragma mark -
#pragma mark Deallo

- (void)dealloc {
    [facebook release];
	
    [super dealloc];
}


@end
