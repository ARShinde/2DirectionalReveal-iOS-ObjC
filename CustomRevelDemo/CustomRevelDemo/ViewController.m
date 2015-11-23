//
//  ViewController.m
//  CustomRevelDemo
//
//  Created by Abhishek Shinde on 16/05/15.
//  Copyright (c) 2015 Abhishek Shinde. All rights reserved.
//

#import "ViewController.h"
#define SWIPE_RIGHT_THRESHOLD -500.0f
#define SWIPE_LEFT_THRESHOLD 500.0f
@interface ViewController ()
{
    CGFloat screenWidth;
    CGFloat screenHeight;
    CGFloat revealWidth;
    UISwipeGestureRecognizer *swipeDirectionLeft,*swipeDirectionRight,*swipeDirectionUp,*swipeDirectionDown;
    UIPanGestureRecognizer *rightViewPan,*leftViewPan;
    
    UIPanGestureRecognizer *closeRightView;
    UIPanGestureRecognizer *closeLeftView;
    BOOL panGestureState;
    
}
@end

@implementation ViewController


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        [self updateConstraints];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait ||
             toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        [self updateConstraints];
    }
}


-(void)updateConstraints
{
    screenWidth=self.view.bounds.size.width;
    screenHeight=self.view.bounds.size.height;
    
    revealWidth=(screenWidth/10)*8;
    
    self.rightWidthConstraint.constant=revealWidth;
    self.rightViewOffsetConstraint.constant=-revealWidth;
    
    self.leftWidthConstraint.constant=revealWidth;
    self.leftViewOffsetConstraint.constant=-revealWidth;

   //reseting position of SwitchView
    self.switchViewVerticleConstraint.constant=(screenHeight-_switchView.frame.size.height)/2;
    self.switchViewHorizontalConstraint.constant=(screenWidth-_switchView.frame.size.width)/2;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.rightWidthConstraint.constant=0;
    self.leftWidthConstraint.constant=0;

    [self.view bringSubviewToFront:_rightSliderView];
    [self.view bringSubviewToFront:_leftSliderView];

    [self updateConstraints];
    [self initGestrues];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initGestrues
{
    swipeDirectionLeft=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToSwipeGesture:)];
    swipeDirectionRight=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToSwipeGesture:)];
    swipeDirectionUp=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToSwipeGesture:)];
    swipeDirectionDown=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(respondToSwipeGesture:)];
    
    rightViewPan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPanRightGesture:)];
    leftViewPan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondToPanLeftGesture:)];
    
    
    swipeDirectionLeft.direction=UISwipeGestureRecognizerDirectionLeft;
    swipeDirectionRight.direction=UISwipeGestureRecognizerDirectionRight;
    swipeDirectionUp.direction=UISwipeGestureRecognizerDirectionUp;
    swipeDirectionDown.direction=UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:swipeDirectionLeft];
    [self.view addGestureRecognizer:swipeDirectionRight];
    [self.view addGestureRecognizer:swipeDirectionUp];
    [self.view addGestureRecognizer:swipeDirectionDown];
    
    [_rightSliderView addGestureRecognizer:rightViewPan];
    [_leftSliderView addGestureRecognizer:leftViewPan];
}


-(void)respondToSwipeGesture:(UISwipeGestureRecognizer *)sender
{
    //Swipe from Left
    
    if (sender.direction==UISwipeGestureRecognizerDirectionLeft) {

        if((screenWidth-revealWidth)<_switchView.frame.size.width){
            [UIView animateWithDuration:.2 animations:^{
                self.switchViewHorizontalConstraint.constant=((screenWidth-revealWidth)-_switchView.frame.size.width)-10;
                [self.view layoutIfNeeded];
                self.leftViewOffsetConstraint.constant=1;
                [self.view layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                swipeDirectionRight.enabled=NO;
            }];
        }
    }
    
//    Swipe from Right
    else if(sender.direction==UISwipeGestureRecognizerDirectionRight){

        [UIView animateWithDuration:.2 animations:^{
            [self.view layoutIfNeeded];
            self.switchViewHorizontalConstraint.constant=10;
            self.rightViewOffsetConstraint.constant=0;
            [self.view layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            swipeDirectionLeft.enabled=NO;
            
        }];
    }
}

-(void)respondToPanLeftGesture:(UIPanGestureRecognizer *)sender
{
    
    if(leftViewPan.state == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [leftViewPan translationInView:self.view];
        if(translation.x>0){
            leftViewPan.view.center = CGPointMake(leftViewPan.view.center.x + translation.x, leftViewPan.view.center.y);
            [leftViewPan setTranslation:CGPointZero inView:self.view];
        }

    }
    else if(leftViewPan.state==UIGestureRecognizerStateEnded)
    {
        CGPoint velocity=[leftViewPan velocityInView:self.view];
        
        if ( velocity.x > SWIPE_LEFT_THRESHOLD ){
            [self updateConstraints];
            [UIView animateWithDuration:.2 animations:^{
                [self.view layoutIfNeeded];
                self.leftViewOffsetConstraint.constant=-revealWidth;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                swipeDirectionRight.enabled=YES;

            }];
        }
        else
            if(screenWidth<leftViewPan.view.center.x){
                [self updateConstraints];
                
            [UIView animateWithDuration:.2 animations:^{
                [self.view layoutIfNeeded];
                self.leftViewOffsetConstraint.constant=-revealWidth;
                [self.view layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                swipeDirectionRight.enabled=YES;

            }];
        }
        else
        {
            [UIView animateWithDuration:.2 animations:^{
            
                self.leftViewOffsetConstraint.constant=1;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.leftViewOffsetConstraint.constant=0;
                swipeDirectionRight.enabled=YES;

            }]; }
    }

}


-(void)respondToPanRightGesture:(UIPanGestureRecognizer *)sender
{
 
  if(rightViewPan.state == UIGestureRecognizerStateChanged)
   {
     CGPoint translation = [rightViewPan translationInView:self.view];
        if(translation.x<0){
           rightViewPan.view.center = CGPointMake(rightViewPan.view.center.x + translation.x, rightViewPan.view.center.y);
           [rightViewPan setTranslation:CGPointZero inView:self.view];
       }
   }
   else if(rightViewPan.state==UIGestureRecognizerStateEnded)
   {
       CGPoint velocity=[rightViewPan velocityInView:self.view];
       
       if ( velocity.x < SWIPE_RIGHT_THRESHOLD ){
           [self updateConstraints];
           
           [UIView animateWithDuration:.2 animations:^{
               [self.view layoutIfNeeded];
               self.rightViewOffsetConstraint.constant=-revealWidth;
               [self.view layoutIfNeeded];
           } completion:^(BOOL finished) {
               swipeDirectionLeft.enabled=YES;

           }];
       }
       else
           if(rightViewPan.view.center.x>0){
           [UIView animateWithDuration:.2 animations:^{
               [self.view layoutIfNeeded];
               self.rightViewOffsetConstraint.constant=-1;
               [self.view layoutIfNeeded];
               
           } completion:^(BOOL finished) {
               self.rightViewOffsetConstraint.constant=0;
               swipeDirectionLeft.enabled=YES;

           }];
       }
       else if(rightViewPan.view.center.x<0){
           NSLog(@"ended");
           [self updateConstraints];
            [UIView animateWithDuration:.2 animations:^{
                [self.view layoutIfNeeded];
                self.rightViewOffsetConstraint.constant=-revealWidth;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                swipeDirectionLeft.enabled=YES;

                
            }];
        }
   }
    
}


- (IBAction)rightViewBackButtonClicked:(id)sender {

    [UIView animateWithDuration:.2 animations:^{
        [self.view layoutIfNeeded];
        self.switchViewHorizontalConstraint.constant=(screenWidth-_switchView.frame.size.width)/2;
        self.rightViewOffsetConstraint.constant=-revealWidth;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
    }];
}

-(IBAction)leftViewBackButtonClicked:(id)sender{

    [UIView animateWithDuration:.2 animations:^{
        [self.view layoutIfNeeded];
        self.switchViewHorizontalConstraint.constant=(screenWidth-_switchView.frame.size.width)/2;
        self.leftViewOffsetConstraint.constant=-revealWidth;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
    }];
}
@end
