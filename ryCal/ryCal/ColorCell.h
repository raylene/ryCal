//
//  ColorCell.h
//  ryCal
//
//  Created by Raylene Yung on 12/27/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorCell : UICollectionViewCell

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) NSString *colorName;

- (void)setSelectedColor:(NSString *)selectedColor;

@end
