

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AertripToastViewDelegate <NSObject>
@optional
- (void)buttonTapped;
- (void)toastRemoved; // nitin change

@end

@interface AertripToastView : UIView {
@private
	UILabel *_textLabel;
    UIButton *_button;
}
@property (nonatomic, weak) id  <AertripToastViewDelegate> _Nullable delegate;
+ (void)toastInView:(nonnull UIView *)parentView withText:(nonnull NSString *)text;
+ (void)toastInView:(nonnull UIView *)parentView withText:(nonnull NSString *)text buttonTitle:(nullable NSString *)buttonTitle delegate:(nullable id <AertripToastViewDelegate>)aDelegate;
@end


