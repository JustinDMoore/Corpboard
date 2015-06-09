//
//  CBSelectCoverPhoto.m
//  CorpBoard
//
//  Created by Justin Moore on 12/19/14.
//  Copyright (c) 2014 Justin Moore. All rights reserved.
//

#import "CBSelectCoverPhoto.h"
#import "KVNProgress.h"
#import "Configuration.h"

@interface CBSelectCoverPhoto () {
    PFQuery *queryPhotos;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentAlbum;
@property (strong, nonatomic) IBOutlet UITableView *tablePhotos;
@property (nonatomic, strong) NSMutableArray *arrayOfDefaultPhotoObjects;
@property (nonatomic, strong) NSMutableArray *arrayOfDefaultPhotos;
@property (nonatomic, strong) NSMutableArray *arrayOfUserPhotoObjects;
@property (nonatomic, strong) NSMutableArray *arrayOfUserPhotos;
@end

@implementation CBSelectCoverPhoto

@synthesize delegate;

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:NO animated:NO];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"arrowLeft"];
    [backBtn setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goback) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn] ;
    self.navigationItem.leftBarButtonItem = backButton;
    self.title = @"Cover Image";
}

-(void)viewDidLoad {
    
    [super viewDidLoad];

}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress show];
    });
    self.tablePhotos.hidden = YES;
    [self getPhotos];
    [self.segmentAlbum addTarget:self
                          action:@selector(segmentChanged)
                forControlEvents:UIControlEventValueChanged];
}

-(void)goback {
    
    [queryPhotos cancel];
    [self.navigationController popViewControllerAnimated:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress setConfiguration:[Configuration standardProgressConfig]];
        [KVNProgress dismiss];
    });
}

int progress = 1;
-(void)getPhotos {
    
    queryPhotos = [PFQuery queryWithClassName:@"photos"];
    [queryPhotos whereKey:@"type" equalTo:@"Cover"];
    [queryPhotos whereKey:@"approved" equalTo:[NSNumber numberWithBool:YES]];
    [queryPhotos orderByAscending:@"name"];
    [queryPhotos findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *obj in objects) {
            BOOL isUserSubmitted = [obj[@"isUserSubmitted"] boolValue];
            if (isUserSubmitted) {
                [self.arrayOfUserPhotoObjects addObject:obj];
            } else {
                [self.arrayOfDefaultPhotoObjects addObject:obj];
            }
            
            PFFile *imgFile = obj[@"photo"];
            PFImageView *imgView = [PFImageView new];
            [imgView setFile:imgFile];
            [imgView loadInBackground:^(UIImage *image, NSError *error) {
                
                if (isUserSubmitted) {
                    [self.arrayOfUserPhotos addObject:imgView];
                } else {
                    [self.arrayOfDefaultPhotos addObject:imgView];
                }
                
                if ([self.arrayOfDefaultPhotos count] + [self.arrayOfUserPhotos count] == [objects count]) {
                    self.tablePhotos.hidden = NO;
                    [self reload];
                }
                
            }];
        }
    }];
}

-(void)reload {
    
    [self.tablePhotos reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [KVNProgress dismiss];
    });
}

-(void)segmentChanged {
    
    [self reload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark - UITableview Delegates
#pragma mark

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.segmentAlbum.selectedSegmentIndex == 0) { //default
        if (!tableView.hidden)
            return [self.arrayOfDefaultPhotoObjects count] + 1;
        else
            return 0;
    } else { //user submitted
        if ([self.arrayOfUserPhotoObjects count]) {
            return [self.arrayOfUserPhotoObjects count] + 1;
        } else {
            return 2;
        }
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    
    if (indexPath.row == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"custom"];
        
        UIButton *btnCamera = (UIButton *)[cell viewWithTag:1];
        UIButton *btnUpload = (UIButton *)[cell viewWithTag:2];
        UIButton *btnCamera2 = (UIButton *)[cell viewWithTag:3];
        UIButton *btnUpload2 = (UIButton *)[cell viewWithTag:4];
        
        [btnCamera addTarget:self action:@selector(camera) forControlEvents:UIControlEventTouchUpInside];
        [btnUpload addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];
        [btnCamera2 addTarget:self action:@selector(camera) forControlEvents:UIControlEventTouchUpInside];
        [btnUpload2 addTarget:self action:@selector(upload) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell"];
        cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, cell.bounds.size.width);
        PFObject *obj;
        
        if (self.segmentAlbum.selectedSegmentIndex == 0) {
            obj = [self.arrayOfDefaultPhotoObjects objectAtIndex:indexPath.row - 1];
        } else {
            if ([self.arrayOfUserPhotoObjects count]) {
                obj = [self.arrayOfUserPhotoObjects objectAtIndex:indexPath.row - 1];
            } else { //no user pictures yet
                obj = nil;
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"blank"];
                cell.textLabel.text = @"No user submitted cover images yet. Be the first to submit yours!";
                cell.textLabel.font = [UIFont systemFontOfSize:12];
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.backgroundColor = [UIColor blackColor];
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                [cell.textLabel sizeToFit];
            }
        }
        
        if (obj) {
            PFFile *imgFile = obj[@"photo"];
            PFImageView *imgView = (PFImageView *)[cell viewWithTag:1];
            [imgView setFile:imgFile];
            [imgView loadInBackground];
            imgView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 139;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 139;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0){
        return;
    }
    
    PFObject *imgObject;
    
    if (self.segmentAlbum.selectedSegmentIndex == 0) {
        imgObject = [self.arrayOfDefaultPhotoObjects objectAtIndex:indexPath.row - 1];
    } else {
        imgObject = [self.arrayOfUserPhotoObjects objectAtIndex:indexPath.row - 1];
    }
    
    if (imgObject) {
        
        [self goback];
        [delegate coverPhotoObject:imgObject];
    }
}

-(void)camera {
    
    upload = NO;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

BOOL upload = NO;
-(void)upload {
    
    upload = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Cover Image" message:@"\rHave a corp themed cover image that you want to share with other users? \r \rFor best quality, images should be 320w x 290h and must be less than 10MB. \r \rTERMS \rAny user will be able to use your uploaded cover image in their profile. By uploading an image, you agree to allow Corpboard and it's users to use the image. Your image will be reviewed, usually within a few minutes, prior to being made available to users."  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"I Agree", nil];
    alert.delegate = self;
    [alert show];
    
}

-(void)submitCoverPhotoForApproval {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newCoverPhoto" object:self];
}

#pragma mark
#pragma mark - UIAlertView Delegates
#pragma mark

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        //cancelled
    } else {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark
#pragma mark - UIImagePickerControler Delegates
#pragma mark

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (upload) {
        [self.delegate coverSubmitForApproval:image];
        [self goback];
    } else {
        [self.delegate coverImage:image];
        [self goback];
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(NSMutableArray *)arrayOfDefaultPhotoObjects {
    if (!_arrayOfDefaultPhotoObjects) {
        _arrayOfDefaultPhotoObjects = [[NSMutableArray alloc] init];
    }
    return _arrayOfDefaultPhotoObjects;
}

-(NSMutableArray *)arrayOfDefaultPhotos {
    if (!_arrayOfDefaultPhotos) {
        _arrayOfDefaultPhotos = [[NSMutableArray alloc] init];
    }
    return _arrayOfDefaultPhotos;
}

-(NSMutableArray *)arrayOfUserPhotoObjects {
    if (!_arrayOfUserPhotoObjects) {
        _arrayOfUserPhotoObjects = [[NSMutableArray alloc] init];
    }
    return _arrayOfUserPhotoObjects;
}

-(NSMutableArray *)arrayOfUserPhotos {
    if (!_arrayOfUserPhotos) {
        _arrayOfUserPhotos = [[NSMutableArray alloc] init];
    }
    return _arrayOfUserPhotos;
}

@end
