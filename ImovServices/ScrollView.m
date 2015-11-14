//
//  ScrollView.m
//  ImovServices
//
//  Created by Renan Shin Mizukosi on 10/14/15.
//  Copyright © 2015 Renan Shin Mizukosi. All rights reserved.
//

#import "ScrollView.h"

@implementation ScrollView

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!self.dragging)
        [[self.nextResponder nextResponder] touchesEnded:touches withEvent:event];
    else
        [super touchesEnded:touches withEvent:event];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
