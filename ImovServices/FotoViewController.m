//
//  FotoViewController.m
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/14/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import "FotoViewController.h"

@interface FotoViewController ()

@end

@implementation FotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.imagem.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationBarIsShowing = YES;
    
    self.imagem.image = self.foto;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imagem;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationDelegate:self];
    
    if(self.navigationBarIsShowing)
        [self hideNavigationBar];
    else
        [self showNavigationBar];
    
    [UIView commitAnimations];
}

- (void)showNavigationBar {
    self.navigationController.navigationBar.alpha = 1.0;
    //self.navigationController.toolbar.alpha = 1.0;
    self.navigationBarIsShowing = YES;
}

- (void)hideNavigationBar {
    self.navigationController.navigationBar.alpha = 0.0;
    //self.navigationController.toolbar.alpha = 0.0;
    self.navigationBarIsShowing = NO;
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
