//
//  ViewController.h
//  CustomRevelDemo
//
//  Created by Abhishek Shinde on 16/05/15.
//  Copyright (c) 2015 Abhishek Shinde. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *revealView;
@property (weak, nonatomic) IBOutlet UIView *switchView;
@property (weak, nonatomic) IBOutlet UIView *rightSliderView;
@property (weak, nonatomic) IBOutlet UIView *leftSliderView;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *switchViewVerticleConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *switchViewHorizontalConstraint;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightViewOffsetConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftViewOffsetConstraint;


-(void)updateConstraints;
- (IBAction)rightViewBackButtonClicked:(id)sender;
-(IBAction)leftViewBackButtonClicked:(id)sender;
@end

