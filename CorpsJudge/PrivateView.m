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
#import "messages.h"
#import "utilities.h"

#import "PrivateView.h"
#import "ChatView.h"
#import "Configuration.h"
#import "Corpsboard-Swift.h"

@interface PrivateView() {
    
    NSMutableArray *users;
    NSMutableArray *arrayOfChatsForCurrentUser;
    NSMutableArray *arrayOfChatsForOtherUsers;
}

@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation PrivateView

@synthesize viewHeader, searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self.tabBarItem setImage:[UIImage imageNamed:@"tab_private"]];
        self.tabBarItem.title = @"Messages";
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    AppDelegate *del =  [[UIApplication sharedApplication]delegate];
    //[del setDelegate:self];
    
    self.title = @"Messages";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableHeaderView = viewHeader;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    users = [[NSMutableArray alloc] init];
    arrayOfChatsForCurrentUser = [[NSMutableArray alloc] init];
    arrayOfChatsForOtherUsers = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionCleanup) name:NOTIFICATION_USER_LOGGED_OUT object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [arrayOfChatsForCurrentUser removeAllObjects];
    [arrayOfChatsForOtherUsers removeAllObjects];
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    UIButton *backBtn = [UISingleton.sharedInstance getBackButton];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)goback {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if ([PFUser currentUser] != nil) {
        
        [self loadMessages];
    }
    else LoginUser(self);
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self searchBarCancelled];
}

#pragma mark - User actions

- (void)actionCleanup {
    
    [users removeAllObjects];
    [self.tableView reloadData];
}

#pragma mark - Backend methods

BOOL isLoading = NO;

-(void)loadMessages {
    
    if (self.isViewLoaded && self.view.window) {
        
        if (isLoading == NO) {
            
            isLoading = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
                [KVNProgress show];
            });
            
            [arrayOfChatsForCurrentUser removeAllObjects];
            [arrayOfChatsForOtherUsers removeAllObjects];
            
            PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
            [query whereKey:PF_CHAT_ROOMID containsString:[PFUser currentUser].objectId];
            
            //[query whereKey:@"belongsToUser" equalTo:[PFUser currentUser]];
            [query includeKey:@"user"];
            [query orderByDescending:@"updatedAt"];
            [query setLimit:50];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                
                if (error == nil) {
                    
                    for (PFObject *obj in objects) {
                        
                        PFUser *belongsTo = obj[@"belongsToUser"];
                        if ([belongsTo.objectId isEqualToString:[PFUser currentUser].objectId]) {
                            
                            [arrayOfChatsForCurrentUser addObject:obj];
                        } else {
                            
                            [arrayOfChatsForOtherUsers addObject:obj];
                        }
                        
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [KVNProgress setConfiguration:[Configuration errorProgressConfig]];
                        [KVNProgress showErrorWithStatus:@"Network error"];
                    });
                }
                
                isLoading = NO;
                [self.tableView reloadData];
                if ([arrayOfChatsForCurrentUser count] < 1) {
                    UILabel *lblNoMessages = [[UILabel alloc] init];
                    lblNoMessages.text = @"You have no messages.";
                    lblNoMessages.textColor = [UIColor lightGrayColor];
                    lblNoMessages.font = [UIFont systemFontOfSize:12];
                    [lblNoMessages sizeToFit];
                    [self.view addSubview:lblNoMessages];
                    lblNoMessages.center = self.view.center;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [KVNProgress dismiss];
                });
            }];
        }
    }
}

- (void)searchUsers:(NSString *)search_lower {
    
    PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
    [query whereKey:PF_USER_OBJECTID notEqualTo:[PFUser currentUser].objectId];
    [query whereKey:PF_USER_FULLNAME_LOWER containsString:search_lower];
    [query orderByAscending:PF_USER_FULLNAME];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error == nil) {
            
            [users removeAllObjects];
            [users addObjectsFromArray:objects];
            [self.tableView reloadData];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [KVNProgress setConfiguration:[Configuration errorProgressConfig]];
                [KVNProgress showErrorWithStatus:@"Network error"];
            });
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([arrayOfChatsForCurrentUser count]) return [arrayOfChatsForCurrentUser count];
    else return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"privateCell"];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PrivateMessageCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    PFObject *lastMessage = arrayOfChatsForCurrentUser[indexPath.row];
    
    UIImageView *imgNew = (UIImageView *)[cell viewWithTag:2];
    UILabel *lblUser = (UILabel *)[cell viewWithTag:3];
    UILabel *lblLastMessageHidden = (UILabel *)[cell viewWithTag:5];
    lblLastMessageHidden.hidden = YES;
    
    int numOfUnreadMessages = [lastMessage[@"counter"] intValue];
    if (numOfUnreadMessages == 0) {
        imgNew.hidden = YES;
    } else {
        imgNew.hidden = NO;
    }
    
    PFUser *user = lastMessage[@"user"];
    lblUser.text = user[@"nickname"];
    [lblUser sizeToFit];
    
    //clears the old message label
    for (UIView *view in cell.subviews) {
        if (view.tag == 10) {
            [view removeFromSuperview];
        }
    }
    
    UILabel *lblLastMessage = [[UILabel alloc] initWithFrame:CGRectMake(30, 45, 282, 41)];
    lblLastMessage.tag = 10;
    lblLastMessage.text = lastMessage[@"lastMessage"];
    lblLastMessage.textColor = [UIColor lightGrayColor];
    lblLastMessage.font = [UIFont systemFontOfSize:14];
    lblLastMessage.numberOfLines = 2;
    [lblLastMessage sizeToFit];
    [cell addSubview:lblLastMessage];
    return cell;
}

#pragma mark - Table view delegate
PFObject *chatForOtherUser;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    chat = arrayOfChatsForCurrentUser[indexPath.row];
    
    if ([arrayOfChatsForOtherUsers count] > 0) {
        chatForOtherUser = arrayOfChatsForOtherUsers[indexPath.row];
    }
    
    user2 = chat[@"user"];
    
    PFObject *lastMessage = arrayOfChatsForCurrentUser[indexPath.row];
    roomIdForChat = lastMessage[@"roomId"];
    //user2 = user2;
    [self performSegueWithIdentifier:@"chat" sender:self];
}

PFObject *chat;
PFUser *user2;
NSString *roomIdForChat;
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"chat"]) {
        
        ChatView *vc = [segue destinationViewController];
        if (chatForOtherUser) {
            vc.chatroomForPrivateChat = chat;
        }
        vc.isPrivate = YES;
        vc.user2 = user2;
        [vc setRoomId:roomIdForChat];
        vc.hidesBottomBarWhenPushed = YES;
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 88;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 88;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if ([arrayOfChatsForCurrentUser count] > 0) {
            
            PFObject *chat = arrayOfChatsForCurrentUser[indexPath.row];
            [arrayOfChatsForCurrentUser removeObjectAtIndex:indexPath.row];
            
            if ([arrayOfChatsForOtherUsers count] > 0) {
                
                [arrayOfChatsForOtherUsers removeObjectAtIndex:indexPath.row];
            }
            // This delete call only deletes the 'master' chat in Messages Class
            // The cloud function then calls another cloud function to delete the messages within the chat
            NSMutableDictionary * params = [NSMutableDictionary new];
            
            NSString *roomId = chat[@"roomId"];
            params[@"roomId"] = roomId;
            
            [tableView beginUpdates];
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView endUpdates];
            
            [PFCloud callFunctionInBackground:@"deleteChat"
                               withParameters:params];
        }
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if ([searchText length] > 0) {
        
        [self searchUsers:[searchText lowercaseString]];
    }
    //else [self loadUsers];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar_ {
    
    [searchBar_ setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar_ {
    
    [searchBar_ setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [self searchBarCancelled];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar_ {
    
    [searchBar_ resignFirstResponder];
}

- (void)searchBarCancelled {
    
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
    
    //[self loadUsers];
}

-(void)messageReceived {
    
    [self loadMessages];
}

@end