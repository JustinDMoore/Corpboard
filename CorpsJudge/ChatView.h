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

#import "JSQMessages.h"

@interface ChatView : JSQMessagesViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) BOOL isPrivate;
@property (nonatomic, strong) PFUser *user2; // user that the current user is chatting with -- ONLY FOR PRIVATE MESSAGES
@property (nonatomic, strong) PFObject *chatroomForPrivateChat;

-(id)initWith:(NSString *)roomId_;
-(void)setRoomId:(NSString *)roomId_;
-(void)sendMessage:(NSString *)text Picture:(UIImage *)picture;
@end