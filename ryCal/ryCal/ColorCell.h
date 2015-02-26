//
//  ColorCell.h
//  ryCal
//
//  UICollectionViewCell used to select/display a record type's chosen color
//
//  Created by Raylene Yung on 12/27/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorCell : UICollectionViewCell

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) NSString *colorName;
@property (nonatomic, strong) NSString *recordTypeID;

- (void)setSelectedColor:(NSString *)selectedColor;

@end
