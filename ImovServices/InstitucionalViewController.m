//
//  InstitucionalViewController.m
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/14/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import "InstitucionalViewController.h"
#import "SWRevealViewController.h"

@interface InstitucionalViewController ()

@end

@implementation InstitucionalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if(revealViewController) {
        [self.menuBar setTarget:self.revealViewController];
        [self.menuBar setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
