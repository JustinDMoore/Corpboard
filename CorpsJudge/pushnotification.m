//
// Copyright (c) 2014 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Parse/Parse.h>

#import "AppConstant.h"

#import "pushnotification.h"

void ParsePushUserAssign(void) {
    
	PFInstallation *installation = [PFInstallation currentInstallation];
	installation[PF_INSTALLATION_USER] = [PFUser currentUser];
	[installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
		if (error != nil) {
            
			NSLog(@"ParsePushUserAssign save error.");
		}
	}];
}

void ParsePushUserResign(void) {
    
	PFInstallation *installation = [PFInstallation currentInstallation];
	installation[PF_INSTALLATION_USER] = [NSNull null];
	[installation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
		if (error != nil) {
            
			NSLog(@"ParsePushUserResign save error.");
		}
	}];
}

void SendPushNotification(NSString *roomId, NSString *text, BOOL pvt) {
    
    if (pvt) {
        
        PFQuery *query = [PFQuery queryWithClassName:PF_MESSAGES_CLASS_NAME];
        [query whereKey:PF_MESSAGES_ROOMID equalTo:roomId];
        [query whereKey:PF_MESSAGES_USER notEqualTo:[PFUser currentUser]];
        [query includeKey:PF_MESSAGES_USER];
        [query setLimit:1000];
        
        PFQuery *queryInstallation = [PFInstallation query];
        [queryInstallation whereKey:PF_INSTALLATION_USER matchesKey:PF_MESSAGES_USER inQuery:query];
        
        PFUser *user = [PFUser currentUser];
        
        NSDictionary *data = @{
                               @"alert" : [NSString stringWithFormat:@"New message from %@!", user[@"nickname"]],
                               @"badge" : @"Increment",
                               @"sound" : @"default",
                               @"type" : @"Private Message"
                               };
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:queryInstallation];
        [push setData:data];
        [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (error != nil) {
                
                NSLog(@"SendPushNotification send error.");
            }
        }];
        
    } else {
//        
//        PFQuery *query = [PFQuery queryWithClassName:PF_MESSAGES_CLASS_NAME];
//        [query whereKey:PF_MESSAGES_ROOMID equalTo:roomId];
//        [query whereKey:PF_MESSAGES_USER notEqualTo:[PFUser currentUser]];
//        [query includeKey:PF_MESSAGES_USER];
//        [query setLimit:1000];
//        
//        PFQuery *queryInstallation = [PFInstallation query];
//        [queryInstallation whereKey:PF_INSTALLATION_USER matchesKey:PF_MESSAGES_USER inQuery:query];
//        [queryInstallation whereKey:@"channels" containsString:roomId];
//        
//        NSDictionary *data = @{
//                               @"alert" : [NSString stringWithFormat:@"New message from !"],
//                               @"badge" : @"Increment",
//                               @"sound" : @"default",
//                               @"type" : @"Live Chat"
//                               };
        
        
        
        PFQuery *queryInstallation = [PFInstallation query];
        [queryInstallation whereKey:@"chatRooms" equalTo:roomId];
        

        PFPush *push = [[PFPush alloc] init];
        [push setQuery:queryInstallation];

        [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (error != nil) {
                
                NSLog(@"SendPushNotification send error.");
            }
        }];

        
        
        
        
        
        
        
        
//        
//        PFPush *push = [[PFPush alloc] init];
//        //[push setQuery:queryInstallation];
//        //[push setData:data];
//        [push setChannel:roomId];
//        [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            
//            if (error != nil) {
//                
//                NSLog(@"SendPushNotification send error.");
//            }
//        }];
//        
    }
    
}