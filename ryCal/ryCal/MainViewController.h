//
//  MainViewController.h
//  ryCal
//
//  Created by Raylene Yung on 11/23/14.
//  Copyright (c) 2014 rayleney. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (nonatomic, strong) NSDate *referenceDate;

- (id)initWithDate:(NSDate *)date;

@end
