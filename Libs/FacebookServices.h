


#import <Foundation/Foundation.h>
#import "FBConnect/FBConnect.h"
#import "Define.h"

#define FacebookNotification @"FacebookNotification"
#define FacebookAuthorizedPermissionsUserDefaults @"FacebookAuthorizedPermissionsUserDefaults"

@interface FacebookServices : NSObject <FBRequestDelegate,
FBDialogDelegate,
FBSessionDelegate, UIAlertViewDelegate> {
    NSArray *permissions;
}

@property (nonatomic, readonly) Facebook *facebook;

+ (FacebookServices *)sharedFacebookServices;

// defaults
- (void)login;
- (BOOL)isAuthenticated;
- (void)getUserInfo;
- (void)postToFeed:(NSString*)message;
- (void)likeToFeed:(NSString*)message;
- (void)postToFeedWithParams:(NSDictionary*)params;
- (void)getEvents;
- (void)getEvent:(NSString*)id;
-(void)postImageToAlbum:(UIImage *)image withDesc:(NSString*) aDesc;

@end
