//
//  ScheduleDateCell.m
//  Reservation
//
//  Created by Shiva Sai Rudra on 01/02/17.
//  Copyright © 2017 Shiva. All rights reserved.
//

#import "ScheduleDateCell.h"
#import <IonIcons.h>

@implementation ScheduleDateCell

- (void)prepareForReuse{
    [self setSelected:NO];
}

//Below is the overload method to change the cell view upon selecting
-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if(selected){
        if(![self viewWithTag:111]){
            UIImage *icon = [IonIcons imageWithIcon:ion_ios_checkmark_outline
                                          iconColor:[UIColor whiteColor]
                                           iconSize:30.0f
                                          imageSize:CGSizeMake(55.0f, 75.0f)];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:icon highlightedImage:icon];
            imageView.backgroundColor = [UIColor colorWithRed:58.0/255.0f green:111.0/255.0f blue:143.0/255.0f alpha:0.5f];
            imageView.tag = 111;
            
            [self addSubview:imageView];
        }
    }
    else{
        [[self viewWithTag:111] removeFromSuperview];
    }
}
@end
