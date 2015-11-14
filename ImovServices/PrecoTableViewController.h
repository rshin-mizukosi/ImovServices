//
//  PrecoTableViewController.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/19/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PrecoTableViewControllerDelegate <NSObject>

- (void)setFaixaPrecoWithMinPreco:(double)minPreco andMaxPreco:(double)maxPreco;

@end

@interface PrecoTableViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *minPreco;
@property (weak, nonatomic) IBOutlet UITextField *maxPreco;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *okButton;

@property (nonatomic) id<PrecoTableViewControllerDelegate> delegate;

- (void)initializeVar;
- (void)showAlerta;

@end
