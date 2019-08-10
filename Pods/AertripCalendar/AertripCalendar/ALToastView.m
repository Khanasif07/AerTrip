//
//  ALToastView.h
//
//  Created by Alex Leutgöb on 17.07.11.
//  Copyright 2011 alexleutgoeb.com. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>
#import "ALToastView.h"


// Set visibility duration
static const CGFloat kDuration = 3;


// Static toastview queue variable
static NSMutableArray *toasts;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@interface ALToastView ()

@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, readonly) UIVisualEffectView * backgroundBlurEffectView;

- (void)fadeToastOut;
+ (void)nextToastInView:(UIView *)parentView;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@implementation ALToastView

@synthesize textLabel = _textLabel;
@synthesize backgroundBlurEffectView = _backgroundBlurEffectView;



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithText:(NSString *)text {
	if ((self = [self initWithFrame:CGRectZero])) {
		// Add corner radius
		self.layer.cornerRadius = 10;
        self.clipsToBounds = true;
		self.autoresizingMask = UIViewAutoresizingNone;
		self.autoresizesSubviews = NO;
		
        // background views
        
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _backgroundBlurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _backgroundBlurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_backgroundBlurEffectView];

        
		// Init and add label
		_textLabel = [[UILabel alloc] init];
		_textLabel.text = text;
		_textLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16];
		_textLabel.textColor = [UIColor whiteColor];
		_textLabel.adjustsFontSizeToFitWidth = NO;
		_textLabel.backgroundColor = [UIColor clearColor];
		//[_textLabel sizeToFit];
		
        _textLabel.numberOfLines = 0;
        CGSize size = [_textLabel.text sizeWithFont:_textLabel.font
                             constrainedToSize:CGSizeMake(300, MAXFLOAT)
                                 lineBreakMode:NSLineBreakByWordWrapping];
        CGRect labelFrame = _textLabel.frame;
        labelFrame.size.height = size.height;
        labelFrame.size.width = size.width;
        _textLabel.frame = labelFrame;
        
		[self addSubview:_textLabel];
		_textLabel.frame = CGRectOffset(_textLabel.frame, 16, 5);
        
	}
	

    UIPanGestureRecognizer * swipeGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    [self addGestureRecognizer:swipeGesture];

    
	return self;
}


-(void)swipeAction:(UIPanGestureRecognizer *)recognizer
{
    
    if ((recognizer.state == UIGestureRecognizerStateEnded))
    {
        UIView * superview = recognizer.view.superview;
        CGPoint velocity = [recognizer velocityInView:superview];
        
        if (velocity.y > 100 )   // panning down
        {
                [self fadeToastOut];
        }
    }
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

+ (void)toastInView:(UIView *)parentView withText:(NSString *)text {
	// Add new instance to queue
	ALToastView *view = [[ALToastView alloc] initWithText:text];
  

	CGFloat lHeight = view.textLabel.frame.size.height;
	CGFloat pWidth = parentView.frame.size.width;
	CGFloat pHeight = parentView.frame.size.height;
	
    CGRect labelFrame = view.textLabel.frame;
    labelFrame.size.width = pWidth - 45;
    view.textLabel.frame = labelFrame;
    
	// Change toastview frame
    float x = 8;
    float y = pHeight ;
    float height = lHeight + 10;
    if (height < 50){
        height = 50;
    }
    view.frame = CGRectMake(x, y, pWidth - 16, height);
	view.alpha = 0.0f;
    view.backgroundBlurEffectView.frame = CGRectMake(0, 0, pWidth - 16, height);
    view.textLabel.center = CGPointMake(view.frame.size.width  / 2,
                                    view.frame.size.height / 2);
	if (toasts == nil) {
		toasts = [[NSMutableArray alloc] initWithCapacity:1];
		[toasts addObject:view];
		[ALToastView nextToastInView:parentView];
	}
	else {
		[toasts addObject:view];
	}
    
    view.userInteractionEnabled = YES;
    
	
}




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)fadeToastOut {
    
	// Fade in parent view
  [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
   
                   animations:^{
                     self.alpha = 0.f;
                       UIView *parentView = self.superview;
                       CGFloat pHeight = parentView.frame.size.height;
                       CGRect rect = self.frame;
                       rect.origin.y = pHeight;
                       self.frame = rect;
                       

                   } 
                   completion:^(BOOL finished){
                     UIView *parentView = self.superview;
                     [self removeFromSuperview];
                     
                     // Remove current view from array
                     [toasts removeObject:self];
                     if ([toasts count] == 0) {
                       toasts = nil;
                     }
                     else
                       [ALToastView nextToastInView:parentView];
                   }];
}




+ (void)nextToastInView:(UIView *)parentView {
	if ([toasts count] > 0) {
    ALToastView *view = [toasts objectAtIndex:0];
    
    [parentView addSubview:view];
    [UIView animateWithDuration:.5  delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{

    CGRect rect = view.frame;
    rect.origin.y = UIScreen.mainScreen.bounds.size.height - 60;
    view.frame = rect;
    view.alpha = 1.0;
                     } completion:^(BOOL finished){}];
    
    // Start timer for fade out
    [view performSelector:@selector(fadeToastOut) withObject:nil afterDelay:kDuration];
  }
}

@end
