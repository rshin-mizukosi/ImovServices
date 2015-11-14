//
//  FotosCollectionViewController.h
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/14/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FotosCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain) NSMutableArray *imagens;

@end
