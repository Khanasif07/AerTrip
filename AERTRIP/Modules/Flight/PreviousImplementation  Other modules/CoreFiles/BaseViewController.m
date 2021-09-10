//
//  BaseViewController.m
//
//  Created by Kakshil Shah on 03/09/14.
//  Copyright (c) 2014 BazingaLabs. All rights reserved.
//


#import "BaseViewController.h"
#import "LocationManagerInstance.h"
#import "Singleton.h"

@interface BaseViewController ()
@property (nonatomic) BOOL statusBarStatus;
@property (nonatomic) BOOL isLoadingLocation;
@property (strong, nonatomic) NSLayoutManager *layoutManager;
@property (strong, nonatomic) NSTextStorage *textStorage;

@end

@implementation BaseViewController

//Smart Processing Functions



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) setNavigationBarHiddenStatus:(BOOL) isHidden
{
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:isHidden];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.alpha = 1;
    [self customizeSystemBackButtonWithTitle:@""];
    [self registerForNotifications];
    [self openDeepLink:nil];

}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showNoInternetError)
                                                 name:NO_INTERNET_KEY
                                               object:nil];
    [self initiateNetworkingCheck];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(BOOL)exists:(NSString *)value
{
    if (value) {
        if (![value isEqual:[NSNull null]]) {
            
        if(![value isEqualToString:@""])
        {
            return true;
        }
        }
    }
    return false;
}

-(NSString *) getBadge
{
    int badge = 0;
    @try {
        badge = [[self getValueForKey:NOTIFICATION_BADGE] intValue];
        if (!badge) {
            badge = 0;
        }
        if (badge<0) {
            badge = 0;
        }
    } @catch (NSException *exception) {
        badge = 0;
        [self saveValue:@"0" forKey:NOTIFICATION_BADGE];
    } @finally {
        
    }
    if (badge == 0) {
        return Nil;
    }
    return [NSString stringWithFormat:@"%i",badge];
}

-(void) updateNavigationBar
{
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:self.showNavigationBar];
        
        
        
    }
}
- (void) customizeSystemBackButtonWithTitle: (NSString *)title {
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self unregisterForNotifications];
}

//MARK:- NSNotificationCenter Implementation
- (void) registerForNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(openDeepLink:)
                                                 name:OPEN_DEEPLINK
                                               object:nil];
    
   
}

-(NSString *) getURLForAirlineCode:(NSString *) code{
    return [NSString stringWithFormat:@"https://cdn.aertrip.com/resources/assets/scss/skin/img/airline-master/%@.png",code];
}

- (void)unregisterForNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:OPEN_DEEPLINK object:nil];


}

- (void)openDeepLink:(NSNotification *) notification {

    
}


//MARK:- Zone functions











- (NSArray *) getArrayForKey:(NSString *)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData *data =  [defaults objectForKey:key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}




-(float) getDistanceBetweenLatOne:(float) latOne LongOne:(float) longOne LatTwo:(float) latTwo LongTwo:(float) longTwo
{
    CLLocation *locA = [[CLLocation alloc] initWithLatitude:latOne longitude:longOne];
    
    CLLocation *locB = [[CLLocation alloc] initWithLatitude:latTwo longitude:longTwo];
    
    CLLocationDistance distance = [locA distanceFromLocation:locB];
    
    return distance;
}



- (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font andStyle:(NSMutableParagraphStyle *) style{
    CGSize size = CGSizeZero;
    if (text) {
        //iOS 7
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font , NSParagraphStyleAttributeName:style } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 1);
    }
    return size;
}


-(BOOL)isReachable
{
    return [self getBooleanForKey:REACHABLE_KEY];
}

-(void) initialSetup
{
    
}

-(void)changeFontOfView:(UIView *)aView
{
    for (UIView *vv in [aView subviews])
    {
        
        if ([vv isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)vv;
            CGFloat fontSize = btn.titleLabel.font.pointSize;
            btn.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:fontSize];
            
        }
        else if ([vv isKindOfClass:[UILabel class]])
        {
            UILabel *lbl = (UILabel *)vv;
            CGFloat fontSize = lbl.font.pointSize;
            [lbl setFont:[UIFont fontWithName:@"Lato-Regular" size:fontSize]];
        }
        else if ([vv isKindOfClass:[UITextView class]])
        {
            UITextView *txt = (UITextView *)vv;
            CGFloat fontSize = txt.font.pointSize;
            [txt setFont:[UIFont fontWithName:@"Lato-Regular" size:fontSize]];
        }
        else if ([vv isKindOfClass:[UITextField class]])
        {
            UITextField *txt = (UITextField *)vv;
            CGFloat fontSize = txt.font.pointSize;
            [txt setFont:[UIFont fontWithName:@"Lato-Regular" size:fontSize]];
        }
        else if ([vv isKindOfClass:[UIView class]]||[vv isKindOfClass:[UIScrollView class]])
        {
            if (aView.subviews.count == 0)return;
            [self changeFontOfView:vv];
        }
    }
    
}

- (void)saveContext {
    
    
    //  [[NSManagedObjectContext defaultContext] saveToPersistentStoreAndWait];
}

- (BOOL)connected {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}


- (BOOL)isLoggedIn
{
    NSLog(@"USERID = > %@",[self getValueForKey:USERID_KEY]);
    if ([self getValueForKey:USERID_KEY] && ![[self getValueForKey:USERID_KEY] isEqualToString:@""]) {
        return true;
    }
    return false;
}


-(void) showActivityIndicatorInView:(UIView *) view withTitle:(NSString *) title
{

    UIImage *statusImage = [UIImage imageNamed:@"Loader1"];
    UIImageView *activityImageView = [[UIImageView alloc]
                                      initWithImage:statusImage];
    NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
    for (int i = 1; i<=18; i++) {
        NSString *imageName = [NSString stringWithFormat:@"Loader%i",i];
        [imagesArray addObject:[UIImage imageNamed:imageName]];
    }
    activityImageView.animationImages = imagesArray;
    activityImageView.animationDuration = 0.8;
    activityImageView.frame = CGRectMake(
                                         self.view.frame.size.width/2
                                         -statusImage.size.width/2,
                                         self.view.frame.size.height/2
                                         -statusImage.size.height/2,
                                         statusImage.size.width,
                                         statusImage.size.height);
    [activityImageView startAnimating];

    
}

-(void) showActivityIndicatorInView:(UIView *) view
{
    UIImage *statusImage = [UIImage imageNamed:@"Loader1"];
    UIImageView *activityImageView = [[UIImageView alloc]
                                      initWithImage:statusImage];
    NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
    for (int i = 1; i<=18; i++) {
        NSString *imageName = [NSString stringWithFormat:@"Loader%i",i];
        [imagesArray addObject:[UIImage imageNamed:imageName]];
    }
    activityImageView.animationImages = imagesArray;
    activityImageView.animationDuration = 0.8;
    activityImageView.frame = CGRectMake(
                                         self.view.frame.size.width/2
                                         -statusImage.size.width/2,
                                         self.view.frame.size.height/2
                                         -statusImage.size.height/2,
                                         statusImage.size.width,
                                         statusImage.size.height);
    [activityImageView startAnimating];

    
}


-(void) removeActivityIndicatorForView:(UIView *) view
{

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void) showMessageOfFeed
{
    if ([[self getValueForKey:@"showInFeed"] isEqualToString:@"yes"]) {
        [self saveValue:@"no" forKey:@"showInFeed"];
        [self showMessage:[self getValueForKey:@"feedMessage"] withTitle:@"Success!"];
    }
}

-(NSString *) ZeroNaConvert:(NSString* )value
{
    if ([value isEqualToString:@"0"]) {
        return @"NA";
    }
    return value;
}

-(NSString *) getValueForKey:(NSString *)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    
    if ([key isEqualToString:LAT_KEY] || [key isEqualToString:LONG_KEY]) {
        if ([self getBooleanForKey:MANUAL_ZONE_SELECTED]) {
            if ([key isEqualToString:LAT_KEY]) {
                return [defaults valueForKey:CUSTOM_LAT_KEY];
            }
            if ([key isEqualToString:LONG_KEY]) {
                return [defaults valueForKey:CUSTOM_LONG_KEY];
            }
        }
    }
    
    
    return [defaults valueForKey:key];
}

-(void) showMessageInFeed:(NSString *) message
{
    [self saveValue:@"yes" forKey:@"showInFeed"];
    [self saveValue:message forKey:@"feedMessage"];
}

-(void) saveValue:(NSString *)value forKey:(NSString *)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
    [defaults synchronize];
}

-(void) saveArray:(NSArray *)array forKey:(NSString *)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:array];
    [defaults setObject:dataSave forKey:key];
    [defaults synchronize];
}


-(BOOL) getBooleanForKey:(NSString *)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}



-(void) saveBoolean:(BOOL )boolValue forKey:(NSString *)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:boolValue forKey:key];
    [defaults synchronize];
}

- (NSInteger)appendIntAtStart:(NSInteger)input appendString:(NSString *)start{
    NSString *inputString = [NSString stringWithFormat:@"%ld",(long)input];
    inputString = [start stringByAppendingString:inputString];
    return [inputString integerValue];
    
}
- (NSInteger)removeIntAtStart:(NSInteger)input {
    NSString *inputString = [NSString stringWithFormat:@"%ld",(long)input];
    if (inputString.length > 1) {
        inputString = [inputString substringFromIndex:1];
    }
    return [inputString integerValue];
}

- (NSInteger)getStartInt:(NSInteger)input {
    NSString *inputString = [NSString stringWithFormat:@"%ld",(long)input];
    if (inputString.length > 1) {
        inputString = [inputString substringToIndex:1];
    }
    return [inputString integerValue];
}


//MARK:- Country

- (NSArray *)countryNames
{
    static NSArray *_countryNames = nil;
    if (!_countryNames)
    {
        _countryNames = [[[[self countryNamesByCode] allValues] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] copy];
    }
    return _countryNames;
}

- (NSArray *)countryCodes
{
    static NSArray *_countryCodes = nil;
    if (!_countryCodes)
    {
        _countryCodes = [[[self countryCodesByName] objectsForKeys:[self countryNames] notFoundMarker:@""] copy];
    }
    return _countryCodes;
}

- (NSDictionary *)countryNamesByCode
{
    static NSDictionary *_countryNamesByCode = nil;
    if (!_countryNamesByCode)
    {
        NSMutableDictionary *namesByCode = [NSMutableDictionary dictionary];
        for (NSString *code in [NSLocale ISOCountryCodes])
        {
            NSString *countryName = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:code];
            
            //workaround for simulator bug
            if (!countryName)
            {
                countryName = [[NSLocale localeWithLocaleIdentifier:@"en_US"] displayNameForKey:NSLocaleCountryCode value:code];
            }
            
            namesByCode[code] = countryName ?: code;
        }
        _countryNamesByCode = [namesByCode copy];
    }
    return _countryNamesByCode;
}

- (NSDictionary *)countryCodesByName
{
    static NSDictionary *_countryCodesByName = nil;
    if (!_countryCodesByName)
    {
        NSDictionary *countryNamesByCode = [self countryNamesByCode];
        NSMutableDictionary *codesByName = [NSMutableDictionary dictionary];
        for (NSString *code in countryNamesByCode)
        {
            codesByName[countryNamesByCode[code]] = code;
        }
        _countryCodesByName = [codesByName copy];
    }
    return _countryCodesByName;
}

- (NSDictionary *)countryPhoneByCode
{
    static NSDictionary *_countryPhoneByCode = nil;
    if (!_countryPhoneByCode)
    {
        _countryPhoneByCode = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"93",@"AF",@"355",@"AL",@"213",@"DZ",@"1",@"AS",
                               @"376",@"AD",@"244",@"AO",@"1",@"AI",@"1",@"AG",
                               @"54",@"AR",@"374",@"AM",@"297",@"AW",@"61",@"AU",
                               @"43",@"AT",@"994",@"AZ",@"1",@"BS",@"973",@"BH",
                               @"880",@"BD",@"1",@"BB",@"375",@"BY",@"32",@"BE",
                               @"501",@"BZ",@"229",@"BJ",@"1",@"BM",@"975",@"BT",
                               @"387",@"BA",@"267",@"BW",@"55",@"BR",@"246",@"IO",
                               @"359",@"BG",@"226",@"BF",@"257",@"BI",@"855",@"KH",
                               @"237",@"CM",@"1",@"CA",@"238",@"CV",@"345",@"KY",
                               @"236",@"CF",@"235",@"TD",@"56",@"CL",@"86",@"CN",
                               @"61",@"CX",@"57",@"CO",@"269",@"KM",@"242",@"CG",
                               @"682",@"CK",@"506",@"CR",@"385",@"HR",@"53",@"CU",
                               @"537",@"CY",@"420",@"CZ",@"45",@"DK",@"253",@"DJ",
                               @"1",@"DM",@"1",@"DO",@"593",@"EC",@"20",@"EG",
                               @"503",@"SV",@"240",@"GQ",@"291",@"ER",@"372",@"EE",
                               @"251",@"ET",@"298",@"FO",@"679",@"FJ",@"358",@"FI",
                               @"33",@"FR",@"594",@"GF",@"689",@"PF",@"241",@"GA",
                               @"220",@"GM",@"995",@"GE",@"49",@"DE",@"233",@"GH",
                               @"350",@"GI",@"30",@"GR",@"299",@"GL",@"1",@"GD",
                               @"590",@"GP",@"1",@"GU",@"502",@"GT",@"224",@"GN",
                               @"245",@"GW",@"595",@"GY",@"509",@"HT",@"504",@"HN",
                               @"36",@"HU",@"354",@"IS",@"91",@"IN",@"62",@"ID",
                               @"964",@"IQ",@"353",@"IE",@"972",@"IL",@"39",@"IT",
                               @"1",@"JM",@"81",@"JP",@"962",@"JO",@"77",@"KZ",
                               @"254",@"KE",@"686",@"KI",@"965",@"KW",@"996",@"KG",
                               @"371",@"LV",@"961",@"LB",@"266",@"LS",@"231",@"LR",
                               @"423",@"LI",@"370",@"LT",@"352",@"LU",@"261",@"MG",
                               @"265",@"MW",@"60",@"MY",@"960",@"MV",@"223",@"ML",
                               @"356",@"MT",@"692",@"MH",@"596",@"MQ",@"222",@"MR",
                               @"230",@"MU",@"262",@"YT",@"52",@"MX",@"377",@"MC",
                               @"976",@"MN",@"382",@"ME",@"1",@"MS",@"212",@"MA",
                               @"95",@"MM",@"264",@"NA",@"674",@"NR",@"977",@"NP",
                               @"31",@"NL",@"599",@"AN",@"687",@"NC",@"64",@"NZ",
                               @"505",@"NI",@"227",@"NE",@"234",@"NG",@"683",@"NU",
                               @"672",@"NF",@"1",@"MP",@"47",@"NO",@"968",@"OM",
                               @"92",@"PK",@"680",@"PW",@"507",@"PA",@"675",@"PG",
                               @"595",@"PY",@"51",@"PE",@"63",@"PH",@"48",@"PL",
                               @"351",@"PT",@"1",@"PR",@"974",@"QA",@"40",@"RO",
                               @"250",@"RW",@"685",@"WS",@"378",@"SM",@"966",@"SA",
                               @"221",@"SN",@"381",@"RS",@"248",@"SC",@"232",@"SL",
                               @"65",@"SG",@"421",@"SK",@"386",@"SI",@"677",@"SB",
                               @"27",@"ZA",@"500",@"GS",@"34",@"ES",@"94",@"LK",
                               @"249",@"SD",@"597",@"SR",@"268",@"SZ",@"46",@"SE",
                               @"41",@"CH",@"992",@"TJ",@"66",@"TH",@"228",@"TG",
                               @"690",@"TK",@"676",@"TO",@"1",@"TT",@"216",@"TN",
                               @"90",@"TR",@"993",@"TM",@"1",@"TC",@"688",@"TV",
                               @"256",@"UG",@"380",@"UA",@"971",@"AE",@"44",@"GB",
                               @"1",@"US",@"598",@"UY",@"998",@"UZ",@"678",@"VU",
                               @"681",@"WF",@"967",@"YE",@"260",@"ZM",@"263",@"ZW",
                               @"591",@"BO",@"673",@"BN",@"61",@"CC",@"243",@"CD",
                               @"225",@"CI",@"500",@"FK",@"44",@"GG",@"379",@"VA",
                               @"852",@"HK",@"98",@"IR",@"44",@"IM",@"44",@"JE",
                               @"850",@"KP",@"82",@"KR",@"856",@"LA",@"218",@"LY",
                               @"853",@"MO",@"389",@"MK",@"691",@"FM",@"373",@"MD",
                               @"258",@"MZ",@"970",@"PS",@"872",@"PN",@"262",@"RE",
                               @"7",@"RU",@"590",@"BL",@"290",@"SH",@"1",@"KN",
                               @"1",@"LC",@"590",@"MF",@"508",@"PM",@"1",@"VC",
                               @"239",@"ST",@"252",@"SO",@"47",@"SJ",@"963",@"SY",
                               @"886",@"TW",@"255",@"TZ",@"670",@"TL",@"58",@"VE",
                               @"84",@"VN",@"1",@"VG",@"1",@"VI",@"672",@"AQ",
                               @"358",@"AX",@"47",@"BV",@"599",@"BQ",@"599",@"CW",
                               @"689",@"TF",@"1",@"SX",@"211",@"SS",@"212",@"EH",
                               @"972",@"IL", nil];
        
    }
    return _countryPhoneByCode;
}

-(BOOL)prefersStatusBarHidden{
    
    
    
    return self.statusBarStatus;
}

//MARK:- SMART FUNCTION

-(BOOL)shouldGoToLocation
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString * askLocation = [defaults valueForKey:@"showAskLocation"];
    if ([askLocation isEqualToString:@"no"]) {
        return NO;
    }
    return YES;
}




-(NSString *)getDomainNameFromURL:(NSString *) urlString
{
    NSURL* url = [NSURL URLWithString:urlString];
    return [url host];
}

-(BOOL) isOne:(NSString *) isOneString
{
    return [isOneString isEqualToString:@"1"];
}


-(NSString *)getNumberOfVotesText:(NSString *)numberOfVotes withRatingText:(NSString *)ratingText
{
    NSString *voteString = @"0";
    if (numberOfVotes && ![numberOfVotes isEqualToString:@""]) {
        voteString = numberOfVotes;
    }
    else
    {
        return @"";
    }
    
    if ([voteString isEqualToString:@"0"]) {
        return @"";
    }
    else
    {
        //      int voteCount = [voteString intValue];
        if ([ratingText isEqualToString:@"-"]) {
            return @"";
        }
        return [NSString stringWithFormat:@"%@ Votes",voteString];
    }
}



-(NSString *)smartTextForComments:(NSString *)comments withLikes:(NSString *)likes;
{
    
    NSString *likeCommentShareText = @"";
    
    if ([comments isEqualToString:@"1"]) {
        likeCommentShareText = [likeCommentShareText stringByAppendingString:@"  1 comment"];
    }
    else if([comments isEqualToString:@"0"])
    {
        
    }
    else
    {
        likeCommentShareText = [likeCommentShareText stringByAppendingString:[NSString stringWithFormat:@"  %@ comments",comments]];
    }
    
    return likeCommentShareText;
    
}


-(NSString *)smartTextForLikes:(NSString *)likes withComments:(NSString *)comments
{
    
    
    
    NSString *likeCommentShareText = @"";
    
    if ([likes isEqualToString:@"1"]) {
        likeCommentShareText = [likeCommentShareText stringByAppendingString:@"  1 like"];
    }
    else if ([likes isEqualToString:@"0"]) {
        
    }
    else
    {
        likeCommentShareText = [likeCommentShareText stringByAppendingString:[NSString stringWithFormat:@"  %@ likes",likes]];
    }
    return likeCommentShareText;
}

-(NSString *) getInitials:(NSString *) text
{
    if (text.length >= 1) {
        NSString *initials = [text substringToIndex:1];
        
        if ([text containsString:@" "]) {
            NSArray *names = [text componentsSeparatedByString:@" "];
            initials = @"";
            for (NSString *name in names) {
                if (name.length >= 1) {
                    initials = [NSString stringWithFormat:@"%@%@",initials, [name substringToIndex:1]];
                }
            }
        }
        if ([initials length] > 2) {
            initials = [initials substringToIndex:2];
        }
        return [initials capitalizedString];
    }
    return @"";
}
-(NSString *)smartTextForCommentsForReviews:(NSString *)comments withLikes:(NSString *)likes
{
    
    NSString *likeCommentShareText = @"";
    
    if ([comments isEqualToString:@"1"]) {
        likeCommentShareText = [likeCommentShareText stringByAppendingString:@"  1 comment"];
    }
    else if([comments isEqualToString:@"0"])
    {
        
    }
    else
    {
        likeCommentShareText = [likeCommentShareText stringByAppendingString:[NSString stringWithFormat:@"  %@ comments",comments]];
    }
    
    return likeCommentShareText;
    
}


-(NSString *)smartTextForLikesForReviews:(NSString *)likes withComments:(NSString *)comments
{
    
    
    if ([likes isEqualToString:@"0"] && [comments isEqualToString:@"0"]) {
        return @"Be the first one to like this";
    }
    
    
    
    NSString *likeCommentShareText = @"";
    
    if ([likes isEqualToString:@"1"]) {
        likeCommentShareText = [likeCommentShareText stringByAppendingString:@"  1 like"];
    }
    else
    {
        likeCommentShareText = [likeCommentShareText stringByAppendingString:[NSString stringWithFormat:@"  %@ likes",likes]];
    }
    
    
    return likeCommentShareText;
}





-(NSString *) convertToBackend:(NSString *) inputString
{
    NSString *uniText = [NSString stringWithUTF8String:[inputString UTF8String]];
    NSData *msgData = [uniText dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    NSString *goodMsg = [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding] ;
    return goodMsg;
}

-(NSString *) convertToFrontEnd:(NSString *) inputString
{
    const char *jsonString = [inputString UTF8String];
    NSData *jsonData = [NSData dataWithBytes:jsonString length:strlen(jsonString)];
    NSString *goodMsg = [[NSString alloc] initWithData:jsonData encoding:NSNonLossyASCIIStringEncoding];
    return goodMsg;
}
- (NSDate *)getDateFromAPIString:(NSString *)string {
    if ([self exists:string]) {

        NSTimeZone *inputTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
        [inputDateFormatter setTimeZone:inputTimeZone];
        [inputDateFormatter setDateFormat:@"dd-MM-yyyy"];
        NSDate *date = [inputDateFormatter dateFromString:string];
        return date;
    }
    return [NSDate date];
}
- (NSString *)getStringFromNSDate:(NSDate *)date {
    NSString *string = @"";
    if (date != nil) {
        NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
        [inputDateFormatter setDateFormat:@"dd-MM-yyyy"];
        string = [inputDateFormatter stringFromDate:date];
    }
    return string;
}

- (NSString *)dateFormatedFromDate:(NSDate *)date
{
    if (date != nil) {
        NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
        [inputDateFormatter setDateFormat:@"dd MMM"];
        NSString *dateString = [inputDateFormatter stringFromDate:date];
        return dateString;
    }else {
        return @"";
    }
    
    
}
-(NSString *)formattedDateFromStr:(NSString *)timeString
{
    if (timeString.length >=10) {
        NSTimeZone *inputTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        NSString *createdAt = [timeString substringToIndex:10];
        NSDateFormatter *inputDateFormatter = [[NSDateFormatter alloc] init];
        [inputDateFormatter setTimeZone:inputTimeZone];
        [inputDateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [inputDateFormatter dateFromString:createdAt];
        
        
        NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
        [outputDateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [outputDateFormatter setDateFormat:@"dd MMM, yyyy"];
        return [outputDateFormatter stringFromDate:date];
    }
    return @"21 Sept, 2050";
}
- (NSString *)dayOfDate:(NSDate *)date {
    if (date != nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date];
        
        NSInteger weekday = [components weekday];
        NSString *weekdayName = [dateFormatter weekdaySymbols][weekday - 1];
        return weekdayName;
    }
    return @"";
    

}
- (NSDate *)getNextDate:(NSDate *)date {
    if (date != nil) {

        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [[NSDateComponents alloc] init] ;
        [components setDay:1];
        NSDate *newDateNext = [gregorian dateByAddingComponents:components toDate:date options:0];
        return newDateNext;
    }
    return nil;

}
- (NSInteger)getNumberOfNightsInRange:(NSDate *)startDate endDate:(NSDate *)endDate {
    if (startDate == nil || endDate == nil)
        return NSNotFound;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *startDateString = [dateFormatter stringFromDate:startDate];
    startDate = [dateFormatter dateFromString:startDateString];

    
    NSString *endDateString = [dateFormatter stringFromDate:endDate];
    endDate = [dateFormatter dateFromString:endDateString];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
//
//    NSDateComponents *component= [gregorian components:NSCalendarUnitDay
//                                                   fromDate:startDate
//                                                     toDate:endDate
//                                                    options:0];
//    return [component day];
    
    
    NSInteger startDay = [calendar ordinalityOfUnit:NSCalendarUnitDay
                                             inUnit:NSCalendarUnitEra
                                            forDate:startDate];
    
    NSInteger endDay = [calendar ordinalityOfUnit:NSCalendarUnitDay
                                           inUnit:NSCalendarUnitEra
                                          forDate:endDate];
    
    if (startDay == NSNotFound)
        return startDay;
    
    if (endDay == NSNotFound)
        return endDay;
    
    return endDay - startDay;
    
    
}
-(NSString *) generateCSVFromArray:(NSArray *)array
{
    if (!array) {
        return @"";
    }
    if (array.count == 0) {
        return @"";
    }
    
    NSString *outputString = @"";
    for (int i = 0; i<array.count; i++) {
        outputString = [outputString stringByAppendingString:array[i]];
        if (i != array.count - 1) {
            outputString = [outputString stringByAppendingString:@", "];
        }
    }
    
    return outputString;
}

- (NSArray *)generateArrayFromCSV:(NSString *)CSVString {
    NSArray *CSVArray = [[NSArray alloc] init];
    if ([self exists:CSVString]) {
        CSVArray = [CSVString componentsSeparatedByString:@", "];
    }
    return CSVArray;
}

//MARK:- MAKE LABEL STRING CLICABLE

- (NSAttributedString *)getAttributedOfString:(NSString *)string range:(NSRange) range {
    
    NSMutableAttributedString *attributedSrting =  [[NSMutableAttributedString alloc] initWithString:string];
    
    NSMutableDictionary *attributesDictionary = [NSMutableDictionary dictionary];
    [attributesDictionary setObject:[UIFont fontWithName:@"SourceSansPro-Semibold" size:16] forKey:NSFontAttributeName];
    [attributesDictionary setObject:[UIColor GREEN_BLUE_COLOR] forKey:NSForegroundColorAttributeName];
    
    [attributedSrting addAttributes:attributesDictionary range:range];
    return attributedSrting;
    
}

- (void)makeLabelClickableBounds:(UILabel *)label range:(NSRange) range {
    NSAttributedString *attributedSrting = [self getAttributedOfString:label.text range:range];
    label.attributedText = attributedSrting;
    self.layoutManager = [[NSLayoutManager alloc] init];
    self.textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
    self.textStorage = [[NSTextStorage alloc] initWithAttributedString:attributedSrting];
    
    // Configure layoutManager and textStorage
    [self.layoutManager addTextContainer:self.textContainer];
    [self.textStorage addLayoutManager:self.layoutManager];
    
    // Configure textContainer
    self.textContainer.lineFragmentPadding = 0.0;
    self.textContainer.lineBreakMode = label.lineBreakMode;
    self.textContainer.maximumNumberOfLines = label.numberOfLines;
    label.userInteractionEnabled = YES;
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnLabel:)]];
    
}
- (void)handleTapOnLabel:(UITapGestureRecognizer *)tapGesture
{
    
    NSInteger indexOfCharacter = [self getIndexOfCharacter:tapGesture];
    [self.delegate performAction:[NSNumber numberWithInteger:indexOfCharacter]];
    
}

- (NSInteger)getIndexOfCharacter:(UITapGestureRecognizer *)tapGesture {
    CGPoint locationOfTouchInLabel = [tapGesture locationInView:tapGesture.view];
    CGSize labelSize = tapGesture.view.bounds.size;
    CGRect textBoundingBox = [self.layoutManager usedRectForTextContainer:self.textContainer];
    CGPoint textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                              (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
    CGPoint locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                         locationOfTouchInLabel.y - textContainerOffset.y);
    NSInteger indexOfCharacter = [self.layoutManager characterIndexForPoint:locationOfTouchInTextContainer
                                                            inTextContainer:self.textContainer
                                   fractionOfDistanceBetweenInsertionPoints:nil];
    return indexOfCharacter;
}






//MARK:- LocationCode





-(NSDictionary *) buildDictionaryForLocation{
    NSArray *keys = [NSArray arrayWithObjects:@"latitude",@"longitude", nil];
    
    
    NSString *latitude = [self getValueForKey:LAT_KEY];
    NSString *longitude = [self getValueForKey:LONG_KEY];
    if (![self exists:latitude]) {
        latitude = @"";
    }
    if (![self exists:longitude]) {
        longitude = @"";
    }
    
    NSArray *objects = [NSArray arrayWithObjects:latitude, longitude, nil];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjects:objects
                                                           forKeys:keys];
    
    return parameters;
}

//Push
//MARK:-  Networking Code Update user




//MARK: App Specific Code
-(NSString *) userID{
    if([self exists:[self getValueForKey:USERID_KEY]])
        return [self getValueForKey:USERID_KEY];
    return @"";
}

- (NSString *) getRatingFormatted:(NSString *)ratingString{
    if ([self exists:ratingString]) {
        if ([ratingString isEqualToString:@"0"] || [ratingString isEqualToString:@"0.0"] ||  [ratingString isEqualToString:@"0."] ) {
            return @"-";
        }
        return ratingString;
    }
    return @"-";
}

- (NSString *) getComments:(NSString *)commentString{
    if ([self exists:commentString]) {
        if ([commentString isEqualToString:@"0"] || [commentString isEqualToString:@"0.0"] ||  [commentString isEqualToString:@"0."] ) {
            return @"   Be the first to comment!";
        }
        return [NSString stringWithFormat:@"   %@ comments",commentString];
    }
    return @"   Be the first to comment!";
    
}

-(void) showModule:(NSString *)module animated:(BOOL) animated {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:module bundle: nil];
    NSString *controllerID = [NSString stringWithFormat:@"%@%@",module,CONTROLLER];
    UIViewController *controller  = [storyboard instantiateViewControllerWithIdentifier:controllerID];
    [self presentViewController:controller animated:animated completion:^(void){
    }];
}

-(UIViewController *) getControllerForModule:(NSString *)module {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:module bundle: nil];
    NSString *controllerID = [NSString stringWithFormat:@"%@%@",module,CONTROLLER];
    return  [storyboard instantiateViewControllerWithIdentifier:controllerID];
}

-(void) pushModule:(NSString *)module animated:(BOOL) animated {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:module bundle: nil];
    NSString *controllerID = [NSString stringWithFormat:@"%@%@",module,CONTROLLER];
    UIViewController *controller  = [storyboard instantiateViewControllerWithIdentifier:controllerID];
    
    if (self.navigationController)
        [self.navigationController pushViewController:controller animated:animated];
    else
    {
        UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:navigationController animated:NO completion:nil];
    }
}

//Popup's

- (void)showMessage:(NSString *)text withTitle:(NSString *)title{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    controller.view.tintColor = [UIColor appColor];
    UIAlertAction* dismissButton = [UIAlertAction
                                    actionWithTitle:DISMISS_TEXT
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        //Nothing to handle yet!
                                    }];
    [controller addAction:dismissButton];
    controller.view.tintColor = [self getAppColor];
    [self presentViewController:controller animated:YES completion:^(){
        controller.view.tintColor =  [UIColor appColor];
    }];
}

-(void) showNoInternetError {
    [self removeActivityIndicator];
    [self showMessage:NO_INTERNET_ERROR withTitle:OOPS_ERROR_TITLE];
}

-(void) showError{
    [self removeActivityIndicator];
    [AertripToastView toastInView:self.view withText:OOPS_ERROR_MESSAGE];
}

-(void)shareWithText:(NSString *)shareText {
    NSArray *activityItems = [NSArray arrayWithObjects:shareText, nil];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:activityViewController animated:YES completion:nil];
}



- (void) initiateNetworkingCheck{
    __weak typeof(self) weakSelf = self;

    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (!weakSelf) { return; }
        if (status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN) {
            [weakSelf saveBoolean:TRUE forKey:REACHABLE_KEY];
        }
        else if(status == AFNetworkReachabilityStatusNotReachable) {
            [weakSelf saveBoolean:FALSE forKey:REACHABLE_KEY];
        }
        else {
            [weakSelf saveBoolean:TRUE forKey:REACHABLE_KEY];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

//UI Code
-(UIColor *)getAppColor{
    return [UIColor appColor];
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}




//MARK:- Loader functions

-(void) removeActivityIndicator{
    
}

-(void) removeActivityIndicatorClash{
}

-(void) showActivityIndicator {
    [self performSelectorOnMainThread:@selector(showIndicator) withObject:nil waitUntilDone:YES];
}
-(void) showActivityIndicatorClash {
    [self performSelectorOnMainThread:@selector(showIndicatorClash) withObject:nil waitUntilDone:YES];
}
-(void) showIndicator{
    
    

    
}

-(void) showIndicatorClash{
    

    UIImage *statusImage = [UIImage imageNamed:@"Loader1"];
    UIImageView *activityImageView = [[UIImageView alloc]
                                      initWithImage:statusImage];
    NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
    for (int i = 1; i<=18; i++) {
        NSString *imageName = [NSString stringWithFormat:@"Loader%i",i];
        [imagesArray addObject:[UIImage imageNamed:imageName]];
    }
    activityImageView.animationImages = imagesArray;
    activityImageView.animationDuration = 0.8;
    activityImageView.frame = CGRectMake(
                                         self.view.frame.size.width/2
                                         -statusImage.size.width/2,
                                         self.view.frame.size.height/2
                                         -statusImage.size.height/2,
                                         statusImage.size.width,
                                         statusImage.size.height);
    [activityImageView startAnimating];

    
}


-(void) showActivityIndicatorIfNeededFor:(NSString *) apiName parameters:(NSDictionary *)parameters{
    parameters = [self addClientIDAndFormatToDictionary:parameters];
    NSString *key = [CCache getKeyForParameters:parameters andAPI:apiName];
    if (![CCache activelyExistsInCacheKey:key]) {
        [self showActivityIndicator];
    }
}


-(void) showActivityIndicatorClashIfNeededFor:(NSString *) apiName parameters:(NSDictionary *)parameters{
    parameters = [self addClientIDAndFormatToDictionary:parameters];
    NSString *key = [CCache getKeyForParameters:parameters andAPI:apiName];
    if (![CCache activelyExistsInCacheKey:key]) {
        [self showIndicatorClash];
    }
}



-(NSDictionary *) buildDictionaryWithObjects:(NSArray *) objects andKeys:(NSArray *)keys{
    if (objects.count == keys.count) {
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:objects
                                                               forKeys:keys];
        return dictionary;
    }else{
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        for (int i = 0; i< keys.count; i++) {
            NSString *key = [keys objectAtIndex:i];
            NSString *object = @"";
            if (objects.count > i) {
                object = [objects objectAtIndex:i];
            }
            dictionary[key] = object;
        }
        return dictionary;
    }
}

- (void) changeActivityIndicatorTitleTo: (NSString*) title {
}

-(void) showActivityIndicatorWithTitle:(NSString *) title{
    

    UIImage *statusImage = [UIImage imageNamed:@"Loader1"];
    UIImageView *activityImageView = [[UIImageView alloc]
                                      initWithImage:statusImage];
    NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
    for (int i = 1; i<=18; i++) {
        NSString *imageName = [NSString stringWithFormat:@"Loader%i",i];
        [imagesArray addObject:[UIImage imageNamed:imageName]];
    }
    activityImageView.animationImages = imagesArray;
    activityImageView.animationDuration = 0.8;
    activityImageView.frame = CGRectMake(
                                         self.view.frame.size.width/2
                                         -statusImage.size.width/2,
                                         self.view.frame.size.height/2
                                         -statusImage.size.height/2,
                                         statusImage.size.width,
                                         statusImage.size.height);
    [activityImageView startAnimating];

    
}

//MARK:- Persistence Code
- (void)saveURLToPreferences:(NSURL *)url forKey:(NSString *)key {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setURL:url forKey:key];
    [prefs synchronize];
}

- (NSURL *)getURLFromPreferences:(NSString*)key {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults URLForKey:key];
    
}
-(void)saveObjectToPreferences:(id)object forKey:(NSString *)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    [prefs setObject:myEncodedObject forKey:key];
    [prefs synchronize];
}
-(id )loadObjectFromPreferences:(NSString*)key
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [prefs objectForKey:key ];
    id obj = [NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return obj;
}


//MARK:- Networking Code

+(BOOL) getBooleanForKey:(NSString *)key{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}

+ (BOOL)isReachable {
    AFNetworkReachabilityStatus status = [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus];
    if (status == AFNetworkReachabilityStatusNotReachable) {
        return false;
    }
    return true; //[self getBooleanForKey:REACHABLE_KEY];
}

-(NSDictionary *)getData:(NSDictionary *)dictionary{
    return [dictionary objectForKey:@"data"];
}

+ (void) notifyNoInternetIssue {
    [[NSNotificationCenter defaultCenter] postNotificationName:NO_INTERNET_KEY object:nil userInfo:nil];
}

-(void)showErrorFromDictionary:(NSDictionary *)dictionary{
    [self removeActivityIndicator];
    NSString *message = [Parser getValueForKey:@"message" inDictionary:dictionary withDefault:OOPS_ERROR_MESSAGE];
    [self showMessage:message withTitle:OOPS_ERROR_TITLE];
}

-(void)handleError:(NSError *)error {
    NSString* ErrorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
    NSLog(@"Error : %@", ErrorResponse);
    [self removeActivityIndicator];
    [self showError];
    
}


-(void)handleErrorWithMessage:(NSString *)error popup:(BOOL) doesPopup{
    [self removeActivityIndicator];
    if (doesPopup) {
        [self showMessage:error withTitle:OOPS_ERROR_TITLE];
    }
    
}



-(NSString *) getTenDigitPhoneNumber:(NSString *) phoneNo {
    NSString *paresedPhoneNo = phoneNo;
    if (phoneNo.length >10) {
        paresedPhoneNo = [phoneNo substringFromIndex:phoneNo.length - 10];
    }
    return paresedPhoneNo;
}

- (void) setTintColor:(UIColor *)color toImageView:(UIImageView *)imageView withImage:(UIImage *)image {
    imageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [imageView setTintColor:color];
    
}

- (void) giveBorderToButton:(UIButton *) button withColor: (UIColor *) color {
    
    [[button layer] setBorderWidth:1.0f];
    [[button layer] setBorderColor:color.CGColor];

}
- (void) giveBorderToView:(UIView *)view withColor:(UIColor *) color withBorderWidth:(CGFloat )borderWidth withRadius:(CGFloat)radius {
    CALayer * externalBorder = [CALayer layer];
    externalBorder.frame = CGRectMake(-borderWidth, -borderWidth, view.frame.size.width + 2, view.frame.size.height + 2 * borderWidth);
    externalBorder.borderColor = color.CGColor;
    externalBorder.borderWidth = borderWidth;
    externalBorder.cornerRadius = radius;
    [view.layer addSublayer:externalBorder];
    view.layer.masksToBounds = NO;

    
}

-(NSString *) formGetURLForURL:(NSString *) url andParameters:(NSDictionary *)parameters{
    url = [NSString stringWithFormat:@"%@?",url];
    for(NSString * key in parameters) {
        NSString * value = [parameters objectForKey:key];
        url = [NSString stringWithFormat:@"%@%@=%@&",url,key,value];
        // do something with key and obj
    }
    NSLog(@"URL: %@",url);
    return url;
}


//MARK:- NEW ADD

- (NSDictionary *)addClientIDAndFormatToDictionary:(NSDictionary *)parameter {
    
    NSMutableDictionary *paramMutableDictionary = [parameter mutableCopy];
    
    
    [paramMutableDictionary setValue:@"app" forKey:@"client"];
    [paramMutableDictionary setValue:@"json" forKey:@"format"];
    
    return  paramMutableDictionary;
    
}



//new aerTrip

- (NSMutableAttributedString *)getStringWithSpacing:(NSString *)string spacing:(double)space
{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString  alloc] initWithString:string];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:space];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, attrString.length)];
    return attrString;
}

- (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (NSString *)parseString:(NSString *)value
{
    if (value) {
        if(![value isEqualToString:@""])
        {
            NSString *trimmedString = [value stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            return trimmedString;
        }
    }
    return @"";
}

-(NSString *) trimString:(NSString *) string{

        if (string) {
                NSString *trimmedString = [string stringByTrimmingCharactersInSet:
                                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
                return trimmedString;
        }
    return @"";
}
- (void)setupStarRatingView: (SCRatingView *)ratingView isEditable:(BOOL)isEditable{
    
    
    UIImage *emptyImage = [UIImage imageNamed:@"starRatingUnfill"];
    UIImage *filledImage = [UIImage imageNamed:@"starRatingFilled"];
    
    NSMutableArray *emptyArray = [[NSMutableArray alloc] init];
    NSMutableArray *filledArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i< 5; i++) {
        [emptyArray addObject:emptyImage];
        [filledArray addObject:filledImage];
    }
    
    // Venue Rating
    ratingView.emptySelectedImages = emptyArray;
    ratingView.fullSelectedImages = filledArray;
    
    ratingView.maximumRating = 5;
    ratingView.minimumRating = 0;
    ratingView.rating = 0;
    ratingView.isEditable = isEditable;
    ratingView.enableHalfRatings = YES;
    
}
- (void)setupDotRatingView: (SCRatingView *)ratingView isEditable:(BOOL)isEditable{
    
    
    UIImage *emptyImage = [UIImage imageNamed:@"deselectedAdvisorRating"];
    UIImage *filledImage = [UIImage imageNamed:@"selectedAdvisorRating"];
    
    NSMutableArray *emptyArray = [[NSMutableArray alloc] init];
    NSMutableArray *filledArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i< 5; i++) {
        [emptyArray addObject:emptyImage];
        [filledArray addObject:filledImage];
    }
    
    // Venue Rating
    ratingView.emptySelectedImages = emptyArray;
    ratingView.fullSelectedImages = filledArray;
    
    ratingView.maximumRating = 5;
    ratingView.minimumRating = 0;
    ratingView.rating = 0;
    ratingView.isEditable = isEditable;
    ratingView.enableHalfRatings = YES;
    
}

- (void)setRoundedCornerWithShadowToButton:(UIButton *)button outerView:(UIView *)outerView shadowColor:(UIColor *)shadowColor {
    float X = 6.0;
    float Y = 10.0;
    float heightOffset = 16.0;

    CGFloat radius = outerView.frame.size.height / 2.0;
    outerView.clipsToBounds = NO;
    outerView.layer.shadowColor = shadowColor.CGColor;
    outerView.layer.shadowOpacity = BUTTON_RELEASED_SHADOW_OPACITY;
    outerView.layer.shadowOffset = CGSizeMake(0.0, Y);
    outerView.layer.shadowRadius = radius - 10;
    outerView.layer.shadowPath =  [[UIBezierPath bezierPathWithRoundedRect:CGRectMake(X, Y, outerView.bounds.size.width - (X * 2), outerView.frame.size.height - heightOffset) cornerRadius:radius - (heightOffset / 2)] CGPath];
    outerView.backgroundColor = [UIColor clearColor];
    [self addCornerRadiusToButton:button radius:radius];
}

- (void)addCornerRadiusToButton:(UIButton *)button radius:(CGFloat)radius {
    button.clipsToBounds = YES;
    button.layer.cornerRadius = radius;
}

- (void)setShadowToView:(UIView *)outerView shadowColor:(UIColor *)shadowColor shadowRadius :(CGFloat)radius withRect:(CGRect) rect {
    
    outerView.clipsToBounds = NO;
    outerView.layer.shadowColor = shadowColor.CGColor;
    outerView.layer.shadowOpacity = 0.4;
    outerView.layer.shadowOffset = CGSizeMake(0.0,  0.0);
    outerView.layer.shadowRadius = radius;
    outerView.layer.shadowPath =  [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] CGPath];
    outerView.backgroundColor = [UIColor clearColor];
}
- (CAGradientLayer *)getHorizontalGradientLayerOfBounds:(CGRect)bounds startColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = bounds;
    //make horizontal gradient
    gradientLayer.name = @"gradient";
    gradientLayer.startPoint = CGPointMake(0.0, 1);
    gradientLayer.endPoint = CGPointMake(1.0, 1);
    gradientLayer.locations = @[@0.0, @1.0];
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[startColor CGColor], (id)[endColor CGColor], nil];
   return gradientLayer;
    
}
- (void)applyGradientLayerToButton:(UIButton *)button startColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    NSArray* layesArray = button.layer.sublayers;
    if (layesArray.count > 0) {
        if ([[[layesArray objectAtIndex:0] name] isEqualToString:@"gradient"]) {
            [button.layer replaceSublayer:layesArray[0] with:[self getHorizontalGradientLayerOfBounds:button.bounds startColor:startColor endColor:endColor]];
        }else {
            [button.layer insertSublayer:[self getHorizontalGradientLayerOfBounds:button.bounds startColor:startColor endColor:endColor] atIndex:0] ;
        }
        
    }else {
        [button.layer insertSublayer:[self getHorizontalGradientLayerOfBounds:button.bounds startColor:startColor endColor:endColor] atIndex:0] ;
    }

}
- (void)applyGradientLayerToView:(UIView *)view startColor:(UIColor *)startColor endColor:(UIColor *)endColor {
    NSArray* layesArray = view.layer.sublayers;
    if (layesArray.count > 0) {
        [view.layer replaceSublayer:layesArray[0] with:[self getHorizontalGradientLayerOfBounds:view.bounds startColor:startColor endColor:endColor]];
    }else {
        [view.layer insertSublayer:[self getHorizontalGradientLayerOfBounds:view.bounds startColor:startColor endColor:endColor] atIndex:0] ;
    }
    
}
- (void)customButtonViewPressed:(UIView *)outerButtonView {
    outerButtonView.layer.shadowOpacity = BUTTON_PRESSED_SHADOW_OPACITY;
}
- (void)customButtonViewReleased:(UIView *)outerButtonView {
    outerButtonView.layer.shadowOpacity = BUTTON_RELEASED_SHADOW_OPACITY;
}

- (void)setCustomButtonViewDisabled:(UIButton *)button withOuterView:(UIView *)outerView {
    [button setEnabled:NO];
    outerView.layer.shadowOpacity = 0.0;
    [self applyGradientLayerToButton:button startColor:[UIColor TWO_ZERO_FOUR_COLOR] endColor:[UIColor TWO_ZERO_FOUR_COLOR]];
    [self addCornerRadiusToButton:button radius:button.bounds.size.height/2];
}
- (void)setCustomButtonViewEnabled:(UIButton *)button withOuterView:(UIView *)outerView {
    [button setEnabled:YES];
    
//    outerView.layer.shadowOpacity = BUTTON_RELEASED_SHADOW_OPACITY;
//    [self setRoundedCornerWithShadowToButton:button outerView:outerView shadowColor:[UIColor GREEN_BLUE_COLOR]];
//    [self applyGradientLayerToButton:button startColor:[UIColor BLUE_GREEN_COLOR] endColor:[UIColor GREEN_BLUE_COLOR]];
}

- (UIImage*)captureView:(UIView *)view
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)makeTopCornersRounded:(UIView *)view withRadius:(double)radius{
    if (@available(iOS 11.0, *)) {
        view.layer.cornerRadius = radius;
        [view.layer setMaskedCorners:kCALayerMaxXMinYCorner | kCALayerMinXMinYCorner];
    } else {
        // Fallback on earlier versions
    }
}




- (NSDate *)getNSDateFromDateString :(NSString *)dateString {
    if ([self exists:dateString]) {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
        return [dateFormatter dateFromString:dateString];

    }
    return [NSDate date];
}

- (NSString *)getFormatedDateFromAPIToDateString :(NSString *)dateString {
    if ([self exists:dateString]) {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:dateString];
        NSDateFormatter *outputDateFormatter = [[NSDateFormatter alloc] init];
        [outputDateFormatter setDateFormat:@"dd MMMM yyyy"];
        return [outputDateFormatter stringFromDate:date];
    }
    return @"";
}

@end
