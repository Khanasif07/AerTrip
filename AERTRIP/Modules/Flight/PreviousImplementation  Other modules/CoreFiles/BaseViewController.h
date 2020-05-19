//
//  BaseViewController.h
//  Created by Kakshil Shah on 03/09/14.
//  Copyright (c) 2014 BazingaLabs. All rights reserved.
//



#import "Constants.h"
#import "Parser.h"
#import <UIKit/UIKit.h>
#import "AFNetworking.h"


#import "Network.h"
#import "CCache.h"
#import "AertripToastView.h"
#import "SCRatingView.h"
#import "Aertrip-Swift.h"
@protocol handleActions
@optional
-(void) performAction:(NSString *) action forSection:(id) section;
-(void) performAction:(id)data;
-(void) selectedGender;
-(void) handleLogin;
@end


@interface BaseViewController : UIViewController<UIActionSheetDelegate>

@property (weak, nonatomic) id<handleActions> delegate;
@property (strong, nonatomic) NSTextContainer *textContainer;


//Variables
@property (nonatomic) BOOL showNavigationBar;



//Smart Processing Functions
-(BOOL) exists:(NSString *) value;
-(NSString *) getInitials:(NSString *) text;
- (NSInteger)appendIntAtStart:(NSInteger)input appendString:(NSString *)start;
- (NSInteger)getStartInt:(NSInteger)input;
- (NSInteger)removeIntAtStart:(NSInteger)input;
-(NSString *)getDomainNameFromURL:(NSString *) url;
-(BOOL) isOne:(NSString *) isOneString;
-(NSString *)formattedDateFromStr:(NSString *)timeString;
-(NSDictionary *) buildDictionaryWithObjects:(NSArray *) objects andKeys:(NSArray *)keys;
-(float) getDistanceBetweenLatOne:(float) latOne LongOne:(float) longOne LatTwo:(float) latTwo LongTwo:(float) longTwo;
-(CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font andStyle:(NSMutableParagraphStyle *) style;
-(NSString *) ZeroNaConvert:(NSString* )value;
-(NSString *) generateCSVFromArray:(NSArray *)array;
- (NSArray *)generateArrayFromCSV:(NSString *)CSVString;
-(NSString *) getTenDigitPhoneNumber:(NSString *) phoneNo;
-(NSString *) trimString:(NSString *) string;
- (void)makeLabelClickableBounds:(UILabel *)label range:(NSRange) range;
- (void) giveBorderToView:(UIView *)view withColor:(UIColor *) color withBorderWidth:(CGFloat )borderWidth withRadius:(CGFloat)radius;

//User Functions
- (BOOL)isLoggedIn;
-(NSString *) userID;
-(NSString *) getBadge;


//Navigation
-(void) showModule:(NSString *)module animated:(BOOL) animated;
-(void) pushModule:(NSString *)module animated:(BOOL) animated;
-(UIViewController *) getControllerForModule:(NSString *)module;

//UI Code
- (UIColor *) getAppColor;
-(void) removeActivityIndicator;
-(UIColor*)colorWithHexString:(NSString*)hex;
- (void) setTintColor:(UIColor *)color toImageView:(UIImageView *)imageView withImage:(UIImage *)image;
- (void) giveBorderToButton:(UIButton *) button withColor: (UIColor *) color;
- (void) customizeSystemBackButtonWithTitle: (NSString *)title;
-(void) setNavigationBarHiddenStatus:(BOOL) isHidden;
-(void) updateNavigationBar;


//Networking Code
+ (BOOL)isReachable;
+ (void) notifyNoInternetIssue;
-(void) showErrorFromDictionary:(NSDictionary *) dictionary;
-(NSDictionary *)getData:(NSDictionary *)dictionary;
-(void) handleError:(NSError *)error;


//Loader
-(void) showActivityIndicator;
-(void) showActivityIndicatorIfNeededFor:(NSString *) apiName parameters:(NSDictionary *)parameters;
-(void) showActivityIndicatorInView:(UIView *) view withTitle:(NSString *) title;
-(void) showActivityIndicatorInView:(UIView *) view;
-(void) showIndicatorClash;
-(void) showActivityIndicatorClashIfNeededFor:(NSString *) apiName parameters:(NSDictionary *)parameters;
-(void) showActivityIndicatorClash;
-(void) removeActivityIndicatorClash;
-(void) removeActivityIndicatorForView:(UIView *) view;


//Popup's
-(void) showError;
-(void) showNoInternetError;
- (void)showMessage:(NSString *)text withTitle:(NSString *)title;
-(void) shareWithText:(NSString *)shareText;
-(void)handleErrorWithMessage:(NSString *)error popup:(BOOL) doesPopup;



//Persistence Code
-(void)saveObjectToPreferences:(id)object forKey:(NSString *)key;
-(id )loadObjectFromPreferences:(NSString*)key;
-(NSString *) getValueForKey:(NSString *)key;
-(void) saveValue:(NSString *)value forKey:(NSString *)key;
-(BOOL) getBooleanForKey:(NSString *)key;
-(void) saveBoolean:(BOOL )boolValue forKey:(NSString *)key;
- (void)saveURLToPreferences:(NSURL *)url forKey:(NSString *)key;
- (NSURL *)getURLFromPreferences:(NSString*)key;
-(NSArray *) getArrayForKey:(NSString *)key;
-(void) saveArray:(NSArray *)array forKey:(NSString *)key;



//Country -->
- (NSArray *)countryNames;
- (NSArray *)countryCodes;
- (NSDictionary *)countryNamesByCode;
- (NSDictionary *)countryCodesByName;
- (NSDictionary *)countryPhoneByCode;


//Network
//For get requests
-(NSString *) formGetURLForURL:(NSString *) url andParameters:(NSDictionary *)parameters;
- (BOOL)connected;
- (BOOL) isReachable;
-(NSString *) convertToFrontEnd:(NSString *) inputString;
-(NSString *) convertToBackend:(NSString *) inputString;
- (BOOL)validateEmailWithString:(NSString*)email;

- (NSDate *)getDateFromAPIString:(NSString *)string;
- (NSString *)getStringFromNSDate:(NSDate *)date;
- (NSDate *)getNSDateFromDateString :(NSString *)dateString;
- (NSMutableAttributedString *)getStringWithSpacing:(NSString *)string spacing:(double)space;
- (NSString *)parseString:(NSString *)value;
- (void)setupStarRatingView: (SCRatingView *)ratingView isEditable:(BOOL)isEditable;
- (void)setupDotRatingView: (SCRatingView *)ratingView isEditable:(BOOL)isEditable;
- (CAGradientLayer *)getHorizontalGradientLayerOfBounds:(CGRect)bounds startColor:(UIColor *)startColor endColor:(UIColor *)endColor;
- (void)setRoundedCornerWithShadowToButton:(UIButton *)button outerView:(UIView *)outerView shadowColor:(UIColor *)shadowColor;
- (void)addCornerRadiusToButton:(UIButton *)button radius:(CGFloat)radius;
- (void)applyGradientLayerToButton:(UIButton *)button startColor:(UIColor *)startColor endColor:(UIColor *)endColor;
- (void)applyGradientLayerToView:(UIView *)view startColor:(UIColor *)startColor endColor:(UIColor *)endColor;
- (void)customButtonViewPressed:(UIView *)outerButtonView;
- (void)customButtonViewReleased:(UIView *)outerButtonView;
- (void)setCustomButtonViewDisabled:(UIButton *)button withOuterView:(UIView *)outerView;
- (void)setCustomButtonViewEnabled:(UIButton *)button withOuterView:(UIView *)outerView;
- (UIImage*)captureView:(UIView *)view;
- (void)makeTopCornersRounded:(UIView *)view withRadius:(double)radius;
- (NSString *)getFormatedDateFromAPIToDateString :(NSString *)dateString;
- (NSString *)dateFormatedFromDate:(NSDate *)date;
- (NSDate *)getNextDate:(NSDate *)date;
- (NSInteger)getNumberOfNightsInRange:(NSDate *)startDate endDate:(NSDate *)endDate;
- (NSString *)dayOfDate:(NSDate *)date ;
- (void)setShadowToView:(UIView *)outerView shadowColor:(UIColor *)shadowColor shadowRadius :(CGFloat)radius withRect:(CGRect) rect;
-(NSString *) getURLForAirlineCode:(NSString *) code;
@end
