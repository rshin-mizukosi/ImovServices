//
//  AreaTableViewController.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/19/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AreaTableViewControllerDelegate <NSObject>

- (void)setFaixaAreaWithMinArea:(int)minArea andMaxArea:(int)maxArea;

@end

@interface AreaTableViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *minArea;
@property (weak, nonatomic) IBOutlet UITextField *maxArea;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *okButton;

@property (nonatomic) id<AreaTableViewControllerDelegate> delegate;

- (void)initializeVar;
- (void)showAlerta;

@end
