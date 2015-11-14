//
//  FotoViewController.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/14/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FotoViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIImageView *imagem;

@property (nonatomic, retain) UIImage *foto;
@property (nonatomic) BOOL navigationBarIsShowing;

- (void)hideNavigationBar;
- (void)showNavigationBar;

@end
