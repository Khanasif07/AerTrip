

#import <QuartzCore/QuartzCore.h>
#import "AertripToastView.h"


// Set visibility duration
static const CGFloat kDuration = 3;
static const CGFloat kButtonViewDuration = 5;


// Static toastview queue variable
static NSMutableArray *toasts;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@interface AertripToastView ()

@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, readonly) UIButton *button;
@property (nonatomic, readonly) UIVisualEffectView * backgroundBlurEffectView;

- (void)fadeToastOut;
+ (void)ShowToastInView:(UIView *)parentView withDuration:(CGFloat) duration;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@implementation AertripToastView

@synthesize textLabel = _textLabel;
@synthesize button = _button;
@synthesize backgroundBlurEffectView = _backgroundBlurEffectView;



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithText:(NSString *)text buttonTitle:(NSString*)buttonTitle{
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
        
        
        if (buttonTitle != nil) {
            
            _button = [UIButton buttonWithType:UIButtonTypeCustom];
            _button.backgroundColor = [UIColor clearColor];
            [_button setTitle:buttonTitle forState:UIControlStateNormal];
            [_button setTitle:buttonTitle forState:UIControlStateSelected];
            [_button setTitleColor:[UIColor colorWithRed:(248.0/255.0) green:(185.0/255.0) blue:(8.0/255.0) alpha:1.0] forState:UIControlStateNormal];
            [_button addTarget:self action:@selector(tappedOnButton:) forControlEvents:UIControlEventTouchUpInside];
            _button.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            _button.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18];
            CGFloat width =  [[UIScreen mainScreen] bounds].size.width ;
            CGFloat buttonTitleWidth = width - 64;
            UIFont * font2 =  [UIFont fontWithName:@"SourceSansPro-Semibold" size:18];
            CGRect rectForButton = [buttonTitle boundingRectWithSize:CGSizeMake(buttonTitleWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font2} context:nil];
            [_button setBackgroundColor: [UIColor redColor]];
            CGSize buttonSize = rectForButton.size;
            
            CGRect buttonFrame = CGRectMake(0, 0 ,buttonSize.width + 32 , buttonSize.height);
            _button.frame = buttonFrame;
            [self addSubview:_button];
        }
        
        // Init and add label
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = text;
        UIFont * font =  [UIFont fontWithName:@"SourceSansPro-Regular" size:16];
        _textLabel.font = font;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.adjustsFontSizeToFitWidth = NO;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.numberOfLines = 0;
        CGFloat width =  [[UIScreen mainScreen] bounds].size.width ;
        CGFloat textWidth = width - 64;
        
        if (_button != nil){
            textWidth = textWidth - _button.titleLabel.intrinsicContentSize.width - 16;
        }
        
        CGRect rect2 = [_textLabel.text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font} context:nil];
        CGRect labelFrame = _textLabel.frame;
        labelFrame.size.height = rect2.size.height;
        labelFrame.size.width = rect2.size.width;
        _textLabel.frame = labelFrame;
        
        
        [self addSubview:_textLabel];
        
    }
    
    self.userInteractionEnabled = true;
    UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:panGesture];
    
    return self;
}


-(IBAction)tappedOnButton:(id) sender {
    
    
    if([self.delegate respondsToSelector:@selector(buttonTapped)]) {
        [self.delegate buttonTapped];
    }
}


- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    if ( recognizer.state == 1 ) {
        [self fadeToastOut];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

+ (void)toastInView:(nonnull UIView *)parentView withText:(nonnull NSString *)text{
    [AertripToastView toastInView:parentView withText:text buttonTitle:nil delegate:nil];
}

+ (void)toastInView:(nonnull UIView *)parentView withText:(nonnull NSString *)text parentRect:(CGRect)parentRect
{
    [AertripToastView toastInView:parentView withText:text buttonTitle:nil delegate:nil parentRect:parentRect];
}

+ (void)toastInView:(nonnull UIView *)parentView withText:(nonnull NSString *)text buttonTitle:(nullable NSString *)buttonTitle delegate:(nullable id <AertripToastViewDelegate>)aDelegate parentRect:(CGRect)parentRect;
{

    // If toastView with same error message exists , instead of creating new message , increase time to dismiss for current message.
    for ( AertripToastView * toastview in toasts) {
        
        NSString * toastMessage = toastview.textLabel.text;
        
        if ([toastMessage compare:text] == NSOrderedSame) {
            [NSObject cancelPreviousPerformRequestsWithTarget:toastview selector:@selector(fadeToastOut) object:nil];
            [toastview performSelector:@selector(fadeToastOut) withObject:nil afterDelay:kDuration];
            return;
        }
    }
    
    
    // Add new instance to messages queue
    AertripToastView *view = [[AertripToastView alloc] initWithText:text buttonTitle:buttonTitle];

    CGRect parentViewRect = parentView.frame;
     
    if (CGRectIsEmpty(parentRect) == FALSE ) {
        parentViewRect = parentRect;
    }
    
    
    CGFloat lHeight = view.textLabel.frame.size.height;
    CGFloat pWidth = parentViewRect.size.width ;
     CGFloat pHeight = parentViewRect.size.height;
    
    // Change toastview frame
    float x = 16;
    float y = pHeight ;
    float height = lHeight + 32;

    view.frame = CGRectMake(x, y, pWidth - 32, height);
    view.alpha = 0.0f;
    view.backgroundBlurEffectView.frame = CGRectMake(0, 0, pWidth - 16, height);
    
    
    if (aDelegate != nil) {
        view.delegate = aDelegate;
    }
    
    
    if (view.button != nil){
        
        CGRect buttonFrame = view.button.frame;
        CGFloat buttonWidth = view.button.titleLabel.intrinsicContentSize.width;
        buttonFrame.origin.x = view.frame.size.width - buttonWidth - 16 ;
        buttonFrame.size.height = height;
        buttonFrame.size.width = buttonWidth + 16 ;
        view.button.frame = buttonFrame;
        
    }
    
    
       CGRect labelFrame = view.textLabel.frame;
       labelFrame.origin.x = 16;
       labelFrame.origin.y = 16;
       labelFrame.size.width = pWidth -  64 - (view.button.frame.size.width);
       view.textLabel.frame = labelFrame;

    if (toasts == nil) {
        toasts = [[NSMutableArray alloc] initWithCapacity:1];
        [toasts addObject:view];
        [AertripToastView ShowToastInView:parentView parentRect:parentViewRect];
    }
    else {
        [toasts addObject:view];
        [AertripToastView ShowToastInView:parentView parentRect:parentViewRect];
    }
    
    view.userInteractionEnabled = YES;
    
    
}

+ (void)ShowToastInView:(UIView *)parentView  parentRect:(CGRect)parentRect {
    if ([toasts count] > 0) {
    AertripToastView *view = [toasts objectAtIndex:0];
    
    [parentView addSubview:view];
    [UIView animateWithDuration:.5  delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{

    CGRect rect = view.frame;
    rect.origin.y = parentRect.size.height - rect.size.height - 16;
    if (parentView.safeAreaInsets.bottom > 0) {
        rect.origin.y =  rect.origin.y - 16;
    }
    view.frame = rect;
    view.alpha = 1.0;
                     } completion:^(BOOL finished){}];
    
    // Start timer for fade out
    [view performSelector:@selector(fadeToastOut) withObject:nil afterDelay:kDuration];
  }
}



+ (void)toastInView:(nonnull UIView *)parentView withText:(nonnull NSString *)text buttonTitle:(nullable NSString *)buttonTitle delegate:(nullable id <AertripToastViewDelegate>)aDelegate;
{
    
    // If toastView with same error message exists , instead of creating new message , increase time to dismiss for current message.
    for ( AertripToastView * toastview in toasts) {
        
        NSString * toastMessage = toastview.textLabel.text;
        
        if ([toastMessage compare:text] == NSOrderedSame) {
            [NSObject cancelPreviousPerformRequestsWithTarget:toastview selector:@selector(fadeToastOut) object:nil];
            [toastview performSelector:@selector(fadeToastOut) withObject:nil afterDelay:kDuration];
            return;
        }
    }
    
    
    // Add new instance to messages queue
    AertripToastView *view = [[AertripToastView alloc] initWithText:text buttonTitle:buttonTitle];
    
    
    CGFloat lHeight = view.textLabel.frame.size.height;
    CGFloat pWidth = parentView.frame.size.width ;
    CGFloat pHeight = parentView.frame.size.height;
    
    // Change toastview frame
    float x = 16;
    float y = pHeight ;
    float height = lHeight + 32;
    
    view.frame = CGRectMake(x, y, pWidth - 32, height);
    view.alpha = 0.0f;
    view.backgroundBlurEffectView.frame = CGRectMake(0, 0, pWidth - 16, height);
    
    
    if (aDelegate != nil) {
        view.delegate = aDelegate;
    }
    
    
    if (view.button != nil){
        
        CGRect buttonFrame = view.button.frame;
        CGFloat buttonWidth = view.button.titleLabel.intrinsicContentSize.width;
        buttonFrame.origin.x = view.frame.size.width - buttonWidth - 16 ;
        buttonFrame.size.height = height;
        buttonFrame.size.width = buttonWidth + 16 ;
        view.button.frame = buttonFrame;
        
    }
    
    
    CGRect labelFrame = view.textLabel.frame;
    labelFrame.origin.x = 16;
    labelFrame.origin.y = 16;
    labelFrame.size.width = pWidth -  64 - (view.button.frame.size.width);
    view.textLabel.frame = labelFrame;
    
    CGFloat duration = kDuration;
    if (buttonTitle != nil) {
        duration = kButtonViewDuration;
    }
    
    if (toasts == nil) {
        toasts = [[NSMutableArray alloc] initWithCapacity:1];
        [toasts addObject:view];
        [AertripToastView ShowToastInView:parentView withDuration:duration];
    }
    else {
        [toasts addObject:view];
        // nitin change
        [AertripToastView ShowToastInView:parentView withDuration:duration];
    }
    
    view.userInteractionEnabled = YES;
    
    
}




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)fadeToastOut {
    
    
    // Fade in parent view
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn
     
                     animations:^{
        self.alpha = 0.f;
        CGRect rect = self.frame;
        CGRect screenSize = [[UIScreen mainScreen] bounds];
        rect.origin.y = screenSize.size.height;
        self.frame = rect;
        
        
    }
                     completion:^(BOOL finished){
        [self removeFromSuperview];
        
        // Remove current view from array
        [toasts removeObject:self];
        if ([toasts count] == 0) {
            toasts = nil;
        }
        // nitin change
        if([self.delegate respondsToSelector:@selector(toastRemoved)]) {
            [self.delegate toastRemoved];
        }
        
    }];
}




+ (void)ShowToastInView:(UIView *)parentView withDuration:(CGFloat) duration {
    if ([toasts count] > 0) {
        AertripToastView *view = [toasts objectAtIndex:0];
        
        [parentView addSubview:view];
        [UIView animateWithDuration:.5  delay:0 options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
            
            CGRect rect = view.frame;
            rect.origin.y = parentView.frame.size.height - rect.size.height - 16;
            if (parentView.safeAreaInsets.bottom > 0) {
                rect.origin.y =  rect.origin.y - 16;
            }
            view.frame = rect;
            view.alpha = 1.0;
        } completion:^(BOOL finished){}];
        
        // Start timer for fade out
        [view performSelector:@selector(fadeToastOut) withObject:nil afterDelay:duration];
    }
}

// nitin change
+ (void)HideToastInView:(UIView *)parentView {
    // If toastView with same view exists , then dismiss the toastView.
    for ( AertripToastView * toastview in toasts) {
        
        UIView * toastParentView = toastview.superview;
        
        if (toastParentView == parentView) {
            [NSObject cancelPreviousPerformRequestsWithTarget:toastview selector:@selector(fadeToastOut) object:nil];
            [toastview fadeToastOut];
        }
    }
}
@end
