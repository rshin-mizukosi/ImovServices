//
//  NavigationTableViewController.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 9/21/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface NavigationTableViewController : UITableViewController <MFMailComposeViewControllerDelegate> {
    NSMutableArray *principal, *sobre, *login;
    NSMutableArray *imagensPrincipal, *imagensSobre, *imagensLogin;
}

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

- (void)setItemsMenu;
- (void)avisoLogout;
- (void)avisoLoginWithTitle:(NSString *)title andMessage:(NSString *)message;
- (void)enviarEmail;

@end
