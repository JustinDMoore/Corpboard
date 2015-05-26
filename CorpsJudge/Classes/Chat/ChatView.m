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
#import "KVNProgress.h"

#import "AppConstant.h"
#import "camera.h"
#import "messages.h"
#import "pushnotification.h"

#import "ChatView.h"
#import "CBAppDelegate.h"

#import "CBUserProfileViewController.h"

#import "IQKeyboardManager.h"
#import "CBImageViewController.h"

#import "Configuration.h"

@interface ChatView() {
    
    NSTimer *timer;
    BOOL isLoading;
    
    NSString *roomId;
    
    NSMutableArray *users;
    NSMutableArray *messages;
    NSMutableDictionary *avatars;
    
    JSQMessagesBubbleImage *outgoingBubbleImageData;
    JSQMessagesBubbleImage *incomingBubbleImageData;
    
    JSQMessagesAvatarImage *placeholderImageData;
    
    CBAppDelegate *del;
}
@end

@implementation ChatView

- (id)initWith:(NSString *)roomId_ {
    
    self = [super init];
    roomId = roomId_;
    return self;
}

-(void)setRoomId:(NSString *)roomId_ {
    
    roomId = roomId_;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.backgroundView.backgroundColor = [UIColor blackColor];
    del = [UIApplication sharedApplication].delegate;
    self.title = @"Chat";
    users = [[NSMutableArray alloc] init];
    messages = [[NSMutableArray alloc] init];
    avatars = [[NSMutableDictionary alloc] init];
    
    PFUser *user = [PFUser currentUser];
    self.senderId = user.objectId;
    self.senderDisplayName = user[@"nickname"];
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:del.appTintColor];
    
    placeholderImageData = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageNamed:@"defaultProfilePicture"] diameter:30.0];
    
    isLoading = NO;
    [self loadMessages];
    
    ClearMessageCounter(roomId);
    
    // custom camera button for chat
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, -2, 38, 35)];
    [btn setImage:[UIImage imageNamed:@"chatCamera"] forState:UIControlStateNormal];
    self.inputToolbar.contentView.leftBarButtonItem = btn;
    
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"arrowLeft"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)goback {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(loadMessages) userInfo:nil repeats:YES];
    self.collectionView.collectionViewLayout.springinessEnabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    [timer invalidate];
}

#pragma mark - Backend methods

- (void)loadMessages {
    
    if (isLoading == NO) {
        
        isLoading = YES;
        JSQMessage *message_last = [messages lastObject];
        
        PFQuery *query = [PFQuery queryWithClassName:PF_CHAT_CLASS_NAME];
        [query whereKey:PF_CHAT_ROOMID equalTo:roomId];
        if (self.isPrivate) {
            [query whereKey:@"belongsToUser" equalTo:[PFUser currentUser]];
        }
        if (message_last != nil) [query whereKey:PF_CHAT_CREATEDAT greaterThan:message_last.date];
        [query includeKey:PF_CHAT_USER];
        [query orderByDescending:PF_CHAT_CREATEDAT];
        [query setLimit:50];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            
            if (error == nil) {
                
                for (PFObject *object in [objects reverseObjectEnumerator]) {
                    
                    [self addMessage:object];
                }
                if ([objects count] != 0) [self finishReceivingMessage];
            }
            else  {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [KVNProgress setConfiguration:[Configuration errorProgressConfig]];
                    [KVNProgress showErrorWithStatus:@"Network error"];
                });
            }
            isLoading = NO;
        }];
    }
}

- (void)addMessage:(PFObject *)object {
    
    PFUser *user = object[PF_CHAT_USER];
    [users addObject:user];
    
    if (object[PF_CHAT_PICTURE] == nil) {
        
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:user.objectId senderDisplayName:user[@"nickname"]
                                                              date:object.createdAt text:object[PF_CHAT_TEXT]];
        [messages addObject:message];
    }
    
    if (object[PF_CHAT_PICTURE] != nil) {
        
        JSQPhotoMediaItem *mediaItem = [[JSQPhotoMediaItem alloc] initWithImage:nil];
        mediaItem.appliesMediaViewMaskAsOutgoing = [user.objectId isEqualToString:self.senderId];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:user.objectId senderDisplayName:user[@"nickname"]
                                                              date:object.createdAt media:mediaItem];
        [messages addObject:message];
        
        PFFile *filePicture = object[PF_CHAT_PICTURE];
        [filePicture getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            
            if (error == nil) {
                
                mediaItem.image = [UIImage imageWithData:imageData];
                [self.collectionView reloadData];
            }
        }];
    }
}

- (void)sendMessage:(NSString *)text Picture:(UIImage *)picture {
    
    CreateMessageItem([PFUser currentUser], self.user2, roomId, self.user2[PF_USER_FULLNAME], text);
    CreateMessageItem(self.user2, [PFUser currentUser], roomId, [PFUser currentUser][PF_USER_FULLNAME], text);
    
    PFFile *filePicture = nil;
    
    if (picture != nil) {
        
        filePicture = [PFFile fileWithName:@"picture.jpg" data:UIImageJPEGRepresentation(picture, 0.6)];
        [filePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
         {
             if (error != nil) NSLog(@"sendMessage picture save error.");
         }];
    }
    
    PFObject *object = [PFObject objectWithClassName:PF_CHAT_CLASS_NAME];
    object[PF_CHAT_USER] = [PFUser currentUser];
    object[PF_CHAT_ROOMID] = roomId;
    object[PF_CHAT_TEXT] = text;
    if (self.isPrivate) {
        object[@"belongsToUser"] = [PFUser currentUser];
    }
    if (filePicture != nil) {
        object[PF_CHAT_PICTURE] = filePicture;
    }
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (error == nil) {
            
            [JSQSystemSoundPlayer jsq_playMessageSentSound];
            [self loadMessages];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [KVNProgress setConfiguration:[Configuration errorProgressConfig]];
                [KVNProgress showErrorWithStatus:@"Network error"];
            });
            
        }
    }];
    
    if (self.isPrivate) {
        
        PFObject *object = [PFObject objectWithClassName:PF_CHAT_CLASS_NAME];
        object[PF_CHAT_USER] = [PFUser currentUser];
        object[PF_CHAT_ROOMID] = roomId;
        object[PF_CHAT_TEXT] = text;
        object[@"belongsToUser"] = self.user2;
        if (filePicture != nil) object[PF_CHAT_PICTURE] = filePicture;
        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [KVNProgress setConfiguration:[Configuration errorProgressConfig]];
                    [KVNProgress showErrorWithStatus:@"Network error"];
                });
            }
        }];
    }
    
    SendPushNotification(roomId, text, self.isPrivate);
    UpdateMessageCounter(roomId, text);
    
    [self finishSendingMessage];
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
    
    [self sendMessage:text Picture:nil];
}

- (void)didPressAccessoryButton:(UIButton *)sender {
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                                               otherButtonTitles:@"Take photo", @"Choose existing photo", nil];
    [action showInView:self.view];
}

#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return messages[indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
             messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessage *message = messages[indexPath.item];
    if ([message.senderId isEqualToString:self.senderId])
    {
        return outgoingBubbleImageData;
    }
    return incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView
                    avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PFUser *user = users[indexPath.item];
    if (avatars[user.objectId] == nil) {
        NSLog(@"yes");
        PFFile *fileThumbnail = user[PF_USER_THUMBNAIL];
        
        [fileThumbnail getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            
            if (error == nil) {
                
                avatars[user.objectId] = [JSQMessagesAvatarImageFactory avatarImageWithImage:[UIImage imageWithData:imageData] diameter:30.0];
                [self.collectionView reloadData];
            }
        }];
        return placeholderImageData;
    }
    else {
        NSLog(@"no");
        return avatars[user.objectId];
    }
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item % 3 == 0) {
        
        JSQMessage *message = messages[indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessage *message = messages[indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        
        JSQMessage *previousMessage = messages[indexPath.item-1];
        if ([previousMessage.senderId isEqualToString:message.senderId]) {
            
            return nil;
        }
    }
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    cell.textView.keyboardAppearance = UIKeyboardAppearanceDark;
    [cell setBackgroundColor:[UIColor blackColor]];
    
    JSQMessage *message = messages[indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        
        cell.textView.textColor = [UIColor whiteColor];
    }
    else {
        
        cell.textView.textColor = [UIColor blackColor];
    }
    
    return cell;
}

#pragma mark - JSQMessages collection view flow layout delegate

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.item % 3 == 0) {
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    JSQMessage *message = messages[indexPath.item];
    if ([message.senderId isEqualToString:self.senderId]) {
        
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        
        JSQMessage *previousMessage = messages[indexPath.item-1];
        if ([previousMessage.senderId isEqualToString:message.senderId]) {
            
            return 0.0f;
        }
    }
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender {
    
    NSLog(@"didTapLoadEarlierMessagesButton");
}

PFUser *userForProfile;
- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView
           atIndexPath:(NSIndexPath *)indexPath {
    
    userForProfile = [users objectAtIndex:indexPath.row];
    if (userForProfile) {
        [self performSegueWithIdentifier:@"profile" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"profile"]) {
        CBUserProfileViewController *vc = [segue destinationViewController];
        [vc setUser:userForProfile];
    } else if ([[segue identifier] isEqualToString:@"picture"]) {
        
        CBImageViewController *vc = [segue destinationViewController];
        
        JSQPhotoMediaItem *pic = (JSQPhotoMediaItem *)messageToView.media;
        NSLog(@"%@", pic);
        UIImage *p = (UIImage *)pic.image;
        NSLog(@"%@", [p class]);
        vc.imgPicture = pic.image;
    }
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"didTapMessageBubbleAtIndexPath");
    JSQMessage *message = messages[indexPath.item];
    if (message.isMediaMessage) {
        messageToView = message;
        [self performSegueWithIdentifier:@"picture" sender:self];
    }
}

JSQMessage *messageToView;

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation {
    
    NSLog(@"didTapCellAtIndexPath %@", NSStringFromCGPoint(touchLocation));
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        
        if (buttonIndex == 0)	ShouldStartCamera(self, YES);
        if (buttonIndex == 1)	ShouldStartPhotoLibrary(self, YES);
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *picture = info[UIImagePickerControllerEditedImage];
    [self sendMessage:@"[Picture message]" Picture:picture];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
