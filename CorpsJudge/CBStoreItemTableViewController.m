////
////  CBStoreItemTableViewController.m
////  Corpboard
////
////  Created by Justin Moore on 8/20/15.
////  Copyright (c) 2015 Justin Moore. All rights reserved.
////
//
//#import "CBStoreItemTableViewController.h"
//#import "CBStoreModel.h"
//#import "CBStoreItemSelectorType.h"
//#import "CBPaymentModel.h"
//#import "Corpsboard-Swift.h"
//
////CBPaymentModel *payment;
////CBStoreModel *store;
//Store *store;
//Payment *payment;
//
//NSString *const _GOLD = @"c78e34";
//NSString *const _MAROON = @"782025";
//UIView *viewFade;
//PFImageView *imgVToAnimate;
//PFImageView *imgOriginal;
//int buttonBorderWidth;
//int buttonCornerRadius;
//UIColor *buttonBorderColor;
//UIColor *buttonTitleColor;
//UIColor *buttonBackgroundColor;
//UIButton *btnCart;
//int numOfItemsInCart;
//
//BOOL colors, sizes;
//@interface CBStoreItemTableViewController ()
//@property (nonatomic, strong) CBStoreItemSelector *viewSelector;
//@property (nonatomic) selectType selectorType;
//@property (nonatomic) int indexOfSize;
//@property (nonatomic) int indexOfColor;
//@property (nonatomic) int indexOfQuantity;
//@property (nonatomic, strong) NSArray *arrayOfSizeChoices;
//@property (nonatomic, strong) NSArray *arrayOfColorChoices;
//@end
//
//@implementation CBStoreItemTableViewController
//
//-(void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    store = [Store model];
//    [store setTheDelegate:self];
//    numOfItemsInCart = (int)[store numberOfItemsInCart] - 1;
//    [self updateCart];
//    self.navigationItem.titleView = [store getStoreTitleView];
//    UIButton *backButton = [[UIButton alloc] init];
//    UIImage *imgBack = [UIImage imageNamed:@"storeBack"];
//    [backButton setBackgroundImage:imgBack forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
//    backButton.frame = CGRectMake(0, 0, 30, 30);
//    UIBarButtonItem *backButtonBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
//    self.navigationItem.leftBarButtonItem = backButtonBarItem;
//    
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.itemErrors = errorNone;
//    buttonBorderWidth = 1;
//    buttonCornerRadius = 8;
//    buttonBorderColor = [UIColor blackColor];
//    buttonBackgroundColor = [UIColor clearColor];
//    buttonTitleColor = [UIColor blackColor];
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 100.0;
//    self.clearsSelectionOnViewWillAppear = YES;
//    self.arrayOfSizeChoices = self.item[@"itemSizes"];
//    self.arrayOfColorChoices = self.item[@"itemColors"];
//    if ([self.arrayOfColorChoices count]) colors = YES;
//    else colors = NO;
//    if ([self.arrayOfSizeChoices count]) sizes = YES;
//    else sizes = NO;
//    self.indexOfQuantity = 0;
//    self.indexOfColor = -1;
//    self.indexOfSize = -1;
//    // Uncomment the following line to preserve selection between presentations.
//    // self.clearsSelectionOnViewWillAppear = NO;
//    
//    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//}
//
//-(void)goBack {
//    [self.navigationController popViewControllerAnimated:YES];
//    if (self.viewSelector) [self.viewSelector closeView:NO];
//}
//
//-(void)updateCart {
//    // cart button
//    btnCart = [[UIButton alloc] init];
//    numOfItemsInCart = numOfItemsInCart + 1;
//    int num = numOfItemsInCart;
//    if (num > 20) num = 21;
//    UIImage *imgCart = [UIImage imageNamed:[NSString stringWithFormat:@"cart%i", + num]];
//    [btnCart addTarget:self action:@selector(openCart) forControlEvents:UIControlEventTouchUpInside];
//    [btnCart setBackgroundImage:imgCart forState:UIControlStateNormal];
//    btnCart.frame = CGRectMake(0, 0, 30, 30);
//    UIBarButtonItem *cartBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnCart];
//    self.navigationItem.rightBarButtonItem = cartBarButtonItem;
//    
//}
//
//-(void)openCart {
//    [self performSegueWithIdentifier:@"cart" sender:self];
//}
//
//#pragma mark - Table view data source
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView == self.tableView) {
//        if (indexPath.row == 0) return 300;
//        else if (indexPath.row == 1) return 52;
//        else if (indexPath.row == 4) return 100;
//        else return 48;
//    } else {
//        return 44;
//    }
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (tableView == self.tableView) {
//        NSString *desc = self.item[@"itemDescription"];
//        if ([desc length]) return 5;
//        else return 4;
//    } else {
//        NSArray *array;
//        switch (self.selectorType) {
//            case SIZE:
//                array = self.item[@"itemSizes"];
//                return [array count];
//                break;
//            case COLOR:
//                array = self.item[@"itemColors"];
//                return [array count];
//                break;
//            case QUANTITY:
//                return 9; //1-9
//                break;
//            default:
//                break;
//        }
//    }
//}
//
//-(UITableViewCell *)descriptionCellForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewCell *cell = cell = [tableView dequeueReusableCellWithIdentifier:@"description" forIndexPath:indexPath];
//    UILabel *lblItemDescription = (UILabel *)[cell viewWithTag:5];
//    UILabel *lblItemPrice = (UILabel *)[cell viewWithTag:6];
//    UILabel *lblItemSalePrice = (UILabel *)[cell viewWithTag:7];
//    UILabel *lblError = (UILabel *)[cell viewWithTag:10];
//    if (self.itemErrors == errorColor) {
//        lblError.hidden = NO;
//        lblError.text = @"Please select an available color.";
//    } else if (self.itemErrors == errorSize) {
//        lblError.hidden = NO;
//        lblError.text = @"Please select an available size.";
//    } else {
//        lblError.hidden = YES;
//    }
//    lblItemDescription.text = self.item[@"itemName"];
//    
//    double itemPrice = [self.item[@"itemPrice"] doubleValue];
//    double itemSalePrice = [self.item[@"itemSalePrice"] doubleValue];
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
//    NSString *strPrice = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:itemPrice]];
//    NSString *strSalePrice = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:itemSalePrice]];
//    if (itemSalePrice > 0) {
//        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:strPrice];
//        [attributeString addAttribute:NSStrikethroughStyleAttributeName
//                                value:@2
//                                range:NSMakeRange(0, [attributeString length])];
//        lblItemPrice.attributedText = attributeString;
//        lblItemSalePrice.text = strSalePrice;
//    } else {
//        lblItemPrice.text = strPrice;
//        lblItemSalePrice.hidden = YES;
//    }
//    return cell;
//}
//
//-(UITableViewCell *)imageCellForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"image" forIndexPath:indexPath];
//    PFImageView *imgItem = (PFImageView *)[cell viewWithTag:1];
//    PFFile *imgFile = self.item[@"itemImage"];
//    if (imgFile) {
//        [imgItem setFile:imgFile];
//        [imgItem loadInBackground:^(UIImage *image, NSError *error) {
//            imgVToAnimate = [[PFImageView alloc] initWithFrame:[imgItem convertRect:imgItem.frame toView:self.navigationController.view]];
//            [imgVToAnimate setFile:imgFile];
//            [imgVToAnimate loadInBackground];
//        }];
//    } else {
//        [imgItem setImage:[UIImage imageNamed:@"StoreError"]];
//        imgVToAnimate = [[PFImageView alloc] initWithFrame:[imgItem convertRect:imgItem.frame toView:self.navigationController.view]];
//        [imgVToAnimate setImage:[UIImage imageNamed:@"StoreError"]];
//    }
//    imgVToAnimate.frame = [imgItem convertRect:imgItem.frame toView:self.navigationController.view];
//    imgVToAnimate.contentMode = UIViewContentModeScaleAspectFit;
//    imgOriginal = imgItem;
//    return cell;
//}
//
//-(UITableViewCell *)buttonsCellForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewCell *cell;
//    if (!colors && !sizes) cell = [tableView dequeueReusableCellWithIdentifier:@"quantity" forIndexPath:indexPath];
//    else if (sizes && !colors) cell = [tableView dequeueReusableCellWithIdentifier:@"sizequantity" forIndexPath:indexPath];
//    else if (sizes && colors) cell = [tableView dequeueReusableCellWithIdentifier:@"sizecolorquantity" forIndexPath:indexPath];
//    
//    UIButton *btnPickASize = (UIButton *)[cell viewWithTag:1];
//    UIButton *btnPickAColor = (UIButton *)[cell viewWithTag:2];
//    UIButton *btnPickQuantity = (UIButton *)[cell viewWithTag:3];
//    
//    btnPickASize.layer.borderWidth = buttonBorderWidth;
//    btnPickAColor.layer.borderWidth = buttonBorderWidth;
//    btnPickQuantity.layer.borderWidth = buttonBorderWidth;
//    btnPickQuantity.layer.borderColor = buttonBorderColor.CGColor;
//    
//    [btnPickQuantity setBackgroundColor: buttonBackgroundColor];
//    [btnPickQuantity setTitleColor:buttonTitleColor forState:UIControlStateNormal];
//    [btnPickASize setBackgroundColor:buttonBackgroundColor];
//    [btnPickAColor setBackgroundColor:buttonBackgroundColor];
//    [btnPickASize setTitleColor:buttonTitleColor forState:UIControlStateNormal];
//    [btnPickAColor setTitleColor:buttonTitleColor forState:UIControlStateNormal];
//    
//    if (self.itemErrors == errorSize) {
//        btnPickASize.layer.borderColor = [UIColor redColor].CGColor;
//    } else if (self.itemErrors == errorColor) {
//        btnPickAColor.layer.borderColor = [UIColor redColor].CGColor;
//    } else {
//        btnPickASize.layer.borderColor = buttonBorderColor.CGColor;
//        btnPickAColor.layer.borderColor = buttonBorderColor.CGColor;
//    }
//    
//    [btnPickASize addTarget:self action:@selector(showSelector:) forControlEvents:UIControlEventTouchUpInside];
//    [btnPickAColor addTarget:self action:@selector(showSelector:) forControlEvents:UIControlEventTouchUpInside];
//    [btnPickQuantity addTarget:self action:@selector(showSelector:) forControlEvents:UIControlEventTouchUpInside];
//    [btnPickQuantity setTitle:[NSString stringWithFormat:@"QTY: %i", self.indexOfQuantity + 1] forState:UIControlStateNormal];
//    if (self.indexOfSize > -1) {
//        NSString *sizeSelected = self.arrayOfSizeChoices[self.indexOfSize];
//        [btnPickASize setTitle:[NSString stringWithFormat:@"Size: %@", sizeSelected] forState:UIControlStateNormal];
//    } else {
//        [btnPickASize setTitle:@"PICK A SIZE" forState:UIControlStateNormal];
//    }
//    
//    if (self.indexOfColor > -1) {
//        NSString *colorSelected = self.arrayOfColorChoices[self.indexOfColor];
//        [btnPickAColor setTitle:[NSString stringWithFormat:@"Color: %@", colorSelected] forState:UIControlStateNormal];
//    } else {
//        [btnPickAColor setTitle:@"PICK A COLOR" forState:UIControlStateNormal];
//    }
//    return cell;
//}
//
//-(UITableViewCell *)cartCellForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addtocart" forIndexPath:indexPath];
//    UIButton *btnAddToCart = (UIButton *)[cell viewWithTag:4];
//    btnAddToCart.layer.borderWidth = buttonBorderWidth;
//    btnAddToCart.layer.borderColor = buttonBorderColor.CGColor;
//    [btnAddToCart setTitleColor:[self colorFromHexString:_GOLD] forState:UIControlStateNormal];
//    [btnAddToCart setBackgroundColor:[self colorFromHexString:_MAROON]];
//    [btnAddToCart addTarget:self action:@selector(addItemToCartAndBuy:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *btnApplePay = (UIButton *)[cell viewWithTag:40];
//    [btnApplePay addTarget:self action:@selector(applePay) forControlEvents:UIControlEventTouchUpInside];
//    return cell;
//}
//
//-(UITableViewCell *)detailsCellForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"details" forIndexPath:indexPath];
//    UILabel *lblDesc = (UILabel *)[cell viewWithTag:1];
//    [lblDesc setFont:[UIFont systemFontOfSize:12]];
//    lblDesc.text = self.item[@"itemDescription"];
//    return cell;
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    UITableViewCell *cell;
//    if (tableView == self.tableView) {
//        switch (indexPath.row) {
//            case 0: //image
//                return [self imageCellForTableView:tableView cellForRowAtIndexPath:indexPath];
//                break;
//            case 1: //description
//                return [self descriptionCellForTableView:tableView cellForRowAtIndexPath:indexPath];
//                break;
//            case 2: //size, quantity, and colors (depending on item)
//                return [self buttonsCellForTableView:tableView cellForRowAtIndexPath:indexPath];
//                break;
//            case 3: //add to cart
//                return [self cartCellForTableView:tableView cellForRowAtIndexPath:indexPath];
//                break;
//            case 4: //details
//                return [self detailsCellForTableView:tableView cellForRowAtIndexPath:indexPath];
//                break;
//            default:
//                break;
//        }
//    } else if (tableView == self.viewSelector.tableSelector) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        NSArray *array;
//        switch (self.selectorType) {
//            case SIZE:
//                array = self.item[@"itemSizes"];
//                [cell.textLabel setText:array[indexPath.row]];
//                if (self.indexOfSize == (int)indexPath.row) {
//                    cell.backgroundColor = [UIColor blackColor];
//                    cell.textLabel.textColor = [UIColor whiteColor];
//                } else {
//                    cell.backgroundColor = [UIColor clearColor];
//                    cell.textLabel.textColor = [UIColor blackColor];
//                }
//                break;
//            case COLOR:
//                array = self.item[@"itemColors"];
//                [cell.textLabel setText:array[indexPath.row]];
//                if (self.indexOfColor == (int)indexPath.row) {
//                    cell.backgroundColor = [UIColor blackColor];
//                    cell.textLabel.textColor = [UIColor whiteColor];
//                } else {
//                    cell.backgroundColor = [UIColor clearColor];
//                    cell.textLabel.textColor = [UIColor blackColor];
//                }
//                break;
//            case QUANTITY:
//                [cell.textLabel setText:[NSString stringWithFormat:@"%i", (int)indexPath.row + 1]];
//                if (self.indexOfQuantity == (int)indexPath.row) {
//                    cell.backgroundColor = [UIColor blackColor];
//                    cell.textLabel.textColor = [UIColor whiteColor];
//                } else {
//                    cell.backgroundColor = [UIColor clearColor];
//                    cell.textLabel.textColor = [UIColor blackColor];
//                }
//                break;
//            default:
//                break;
//        }
//        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
//        [cell.textLabel setFont:[UIFont systemFontOfSize:10]];
//    }
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (tableView == self.viewSelector.tableSelector) {
//        switch (self.selectorType) {
//            case SIZE: self.indexOfSize = (int)indexPath.row;
//                break;
//            case COLOR: self.indexOfColor = (int)indexPath.row;
//                break;
//            case QUANTITY: self.indexOfQuantity = (int)indexPath.row;
//                break;
//            default:
//                break;
//        }
//        [self.viewSelector.tableSelector reloadData];
//        [self.viewSelector closeView:NO];
//        self.itemErrors = errorNone;
//        [self.tableView reloadData];
//    }
//}
//
//-(void)selectCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)path onOrOff:(BOOL)on {
//    if (on) {
//        [self.viewSelector.tableSelector selectRowAtIndexPath:path animated:NO
//                                               scrollPosition:UITableViewScrollPositionNone];
//        cell.backgroundColor = [UIColor blackColor];
//        cell.textLabel.textColor = [UIColor whiteColor];
//    } else {
//        [self.viewSelector.tableSelector deselectRowAtIndexPath:path animated:NO];
//        cell.backgroundColor = [UIColor clearColor];
//        cell.textLabel.textColor = [UIColor blackColor];
//    }
//}
//
//-(UIColor*)colorFromHexString:(NSString*)hex {
//    
//    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
//    
//    // String should be 6 or 8 characters
//    if ([cString length] < 6) return [UIColor grayColor];
//    
//    // strip 0X if it appears
//    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
//    
//    if ([cString length] != 6) return  [UIColor grayColor];
//    
//    // Separate into r, g, b substrings
//    NSRange range;
//    range.location = 0;
//    range.length = 2;
//    NSString *rString = [cString substringWithRange:range];
//    
//    range.location = 2;
//    NSString *gString = [cString substringWithRange:range];
//    
//    range.location = 4;
//    NSString *bString = [cString substringWithRange:range];
//    
//    // Scan values
//    unsigned int r, g, b;
//    [[NSScanner scannerWithString:rString] scanHexInt:&r];
//    [[NSScanner scannerWithString:gString] scanHexInt:&g];
//    [[NSScanner scannerWithString:bString] scanHexInt:&b];
//    
//    return [UIColor colorWithRed:((float) r / 255.0f)
//                           green:((float) g / 255.0f)
//                            blue:((float) b / 255.0f)
//                           alpha:1.0f];
//}
//
//-(void)showSelector:(UIButton *)sender {
//    
//    switch (sender.tag) {
//        case 1: //size
//            self.selectorType = SIZE;
//            break;
//        case 2: //color
//            self.selectorType = COLOR;
//            break;
//        case 3: //quantity
//            self.selectorType = QUANTITY;
//            break;
//        default:
//            break;
//    }
//    [self setFade:YES];
//    [self.navigationController.view addSubview:self.viewSelector];
//    [self.viewSelector showInParentWithSelectorType:self.selectorType];
//    [self.viewSelector.tableSelector reloadData];
//}
//
//-(void)setFade:(BOOL)on {
//    if (!viewFade) {
//        viewFade = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
//        viewFade.backgroundColor = [UIColor blackColor];
//        viewFade.alpha = .6;
//    }
//    if (on) {
//        [self.navigationController.view addSubview:viewFade];
//    } else {
//        [viewFade removeFromSuperview];
//    }
//}
//
//-(void)addItemToCartAndBuy:(BOOL)buyNow {
//    //make sure size, color exists
//    if ([self.arrayOfSizeChoices count]) {
//        if (self.indexOfSize < 0) {
//            self.itemErrors = errorSize;
//            [self.tableView reloadData];
//            return;
//        }
//    } else self.itemErrors = errorNone;
//    if ([self.arrayOfColorChoices count]) {
//        if (self.indexOfColor < 0) {
//            self.itemErrors = errorColor;
//            [self.tableView reloadData];
//            return;
//        }
//    }
//    
//    PFObject *cartItem = [PFObject objectWithClassName:@"Orders"];
//    cartItem[@"status"] = @"IN CART";
//    cartItem[@"user"] = [PFUser currentUser];
//    cartItem[@"item"] = self.item;
//    int qty = self.indexOfQuantity + 1;
//    cartItem[@"quantity"] = [NSNumber numberWithInt:qty];
//    if ([self.arrayOfSizeChoices count]) {
//        NSString *sizeChoice = self.arrayOfSizeChoices[self.indexOfSize];
//        cartItem[@"size"] = sizeChoice;
//    }
//    if ([self.arrayOfColorChoices count]) {
//        NSString *colorChoice = self.arrayOfColorChoices[self.indexOfColor];
//        cartItem[@"color"] = colorChoice;
//    }
//    
//    [store.arrayOfItemsInCart addObject:cartItem];
//    if (!buyNow) {
//        [cartItem saveEventually];
//        CFTimeInterval intv = 0;
//        for (int i = qty; i > 0; i--) {
//            [self performSelector:@selector(animateItemToCart) withObject:nil afterDelay:intv];
//            intv = intv + .6;
//        }
//    } else {
//        [cartItem saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//            if (succeeded) {
//                payment = [[Payment alloc] init];
//                
////                payment = [CBPaymentModel paymentModel];
//                NSMutableArray *arrayOfItems = [[NSMutableArray alloc] init];
//                [arrayOfItems addObject:cartItem];
//                [payment purchaseItemsWithApplePay:arrayOfItems
//                                          discount:0.00
//                                fromViewController:self];
////                [payment purchaseItemsWithApplePay:arrayOfItems
////                                      withDiscount:0.00
////                                fromViewController:self];
//            }
//        }];
//    }
//}
//
//
//-(void)animateItemToCart {
//        
//        //CFTimeInterval fullDuration = 0.6f;
//        imgVToAnimate.alpha = 1.0f;
//        
//        PFImageView *viewAnimate = [[PFImageView alloc] initWithFrame:imgVToAnimate.frame];
//        viewAnimate.image = imgVToAnimate.image;
//        viewAnimate.contentMode = UIViewContentModeScaleAspectFit;
//        viewAnimate.alpha = 1.0f;
//        
//        CGRect imageFrame = viewAnimate.frame;
//        //Your image frame.origin from where the animation need to get start
//        CGPoint viewOrigin = viewAnimate.frame.origin;
//        viewOrigin.y = viewOrigin.y + imageFrame.size.height / 2.0f;
//        viewOrigin.x = viewOrigin.x + imageFrame.size.width / 2.0f;
//        
//        viewAnimate.frame = imageFrame;
//        viewAnimate.layer.position = viewOrigin;
//        [self.navigationController.view addSubview:viewAnimate];
//        
//        // Set up fade out effect
//        CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//        [fadeOutAnimation setToValue:[NSNumber numberWithFloat:0.3]];
//        fadeOutAnimation.fillMode = kCAFillModeForwards;
//        fadeOutAnimation.removedOnCompletion = NO;
//        
//        // Set up scaling
//        CABasicAnimation *resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size"];
//        [resizeAnimation setToValue:[NSValue valueWithCGSize:CGSizeMake(0.0, 0.0)]];
//        resizeAnimation.fillMode = kCAFillModeForwards;
//        resizeAnimation.removedOnCompletion = NO;
//        
//        // Set up path movement
//        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//        pathAnimation.calculationMode = kCAAnimationPaced;
//        pathAnimation.fillMode = kCAFillModeForwards;
//        pathAnimation.removedOnCompletion = NO;
//        //Setting Endpoint of the animation
//        CGPoint endP = CGPointMake([UIScreen mainScreen].bounds.size.width - 30, 45);
//        //CGPoint endPoint = CGPointMake(480.0f - 30.0f, 40.0f);
//        //to end animation in last tab use
//        //CGPoint endPoint = CGPointMake( 320-40.0f, 480.0f);
//        CGMutablePathRef curvedPath = CGPathCreateMutable();
//        CGPathMoveToPoint(curvedPath, NULL, viewOrigin.x, viewOrigin.y);
//        CGPathAddCurveToPoint(curvedPath, NULL, endP.x, viewOrigin.y, endP.x, viewOrigin.y, endP.x, endP.y);
//        pathAnimation.path = curvedPath;
//        CGPathRelease(curvedPath);
//        
//        CAAnimationGroup *group = [CAAnimationGroup animation];
//        group.fillMode = kCAFillModeForwards;
//        group.removedOnCompletion = NO;
//        [group setAnimations:[NSArray arrayWithObjects:fadeOutAnimation, pathAnimation, resizeAnimation, nil]];
//        group.duration = fullDuration;
//        group.delegate = self;
//        [group setValue:viewAnimate forKey:@"imageViewBeingAnimated"];
//        
//        [viewAnimate.layer addAnimation:group forKey:@"savingAnimation"];
//        [self performSelector:@selector(updateCart) withObject:nil afterDelay:fullDuration];
//        //[self performSelector:@selector(reload) withObject:nil afterDelay:fullDuration];
//        
//        //animate replacement item
//        imgOriginal.alpha = 0;
//        imgOriginal.transform = CGAffineTransformScale(imgOriginal.transform, 0.8, 0.8);
//        [UIView animateWithDuration:0.4
//                              delay:0
//                            options:0
//                         animations:^{
//                             imgOriginal.alpha = 1;
//                             imgOriginal.transform = CGAffineTransformIdentity;
//                         } completion:^(BOOL finished) {
//                             [self.tableView reloadData];
//                         }];
//    
//}
//
//-(void)reload {
//    [self.tableView reloadData];
//}
//
//#pragma mark
//#pragma mark - Store Item Selector Protocol
//#pragma mark
//-(void)selectorRemovedFromSuperview {
//    self.viewSelector = nil;
//}
//
//-(void)selectorWillClose {
//    [self setFade:NO];
//}
//
//-(void)applePay {
//    [self addItemToCartAndBuy:YES];
//}
//
//-(CBStoreItemSelector *)viewSelector {
//    if (!_viewSelector) {
//        _viewSelector = [[[NSBundle mainBundle] loadNibNamed:@"CBStoreItemSelector"
//                                                             owner:self
//                                                           options:nil]
//                               objectAtIndex:0];
//        [_viewSelector setDelegate:self];
//        [_viewSelector.tableSelector setDelegate:self];
//        [_viewSelector.tableSelector setDataSource:self];
//        _viewSelector.tableSelector.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    }
//    return _viewSelector;
//}
//@end
