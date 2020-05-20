

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AertripToastViewDelegate <NSObject>
@optional
- (void)buttonTapped;
// nitin change
// when toastView is removed from the superview
- (void)toastRemoved;

@end

@interface AertripToastView : UIView {
@private
	UILabel *_textLabel;
    UIButton *_button;
}
@property (nonatomic, weak) id  <AertripToastViewDelegate> _Nullable delegate;
+ (void)toastInView:(nonnull UIView *)parentView withText:(nonnull NSString *)text;
+ (void)toastInView:(nonnull UIView *)parentView withText:(nonnull NSString *)text parentRect:(CGRect)parentRect;
+ (void)toastInView:(nonnull UIView *)parentView withText:(nonnull NSString *)text buttonTitle:(nullable NSString *)buttonTitle delegate:(nullable id <AertripToastViewDelegate>)aDelegate;
// nitin
// to hide the toastView which is showing on paased view
+ (void)HideToastInView:(nonnull UIView *)parentView;
@end


