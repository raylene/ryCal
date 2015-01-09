//
//  MenuItemCell.m
//  ryCal
//
//  Created by Raylene Yung on 12/30/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import "MenuItemCell.h"
#import "SharedConstants.h"

@interface MenuItemCell()

@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *itemName;

@end

@implementation MenuItemCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setConfig:(NSDictionary *)config {
    _config = config;
    self.itemName.text = config[@"name"];
    self.itemName.textColor = [SharedConstants getMenuTextColor];
    
    // TODO: fix this when I have better icons..
//    self.itemImage.image = [UIImage imageNamed:config[@"img"]];
    self.itemImage.backgroundColor = [UIColor whiteColor];
    
    // Customized selection color
    UIView *backgroundSelectionView = [[UIView alloc] init];
    backgroundSelectionView.backgroundColor = [SharedConstants getMenuSelectedBackgroundColor];
    self.selectedBackgroundView = backgroundSelectionView;
}

@end