//
//  SCRatingView.h
//  SCRatingView
//
//  Created by Sujith Chandran on 14/05/16.
//  Copyright © 2016 Sujith. All rights reserved.
//

/**
 A simple rating view inspired by TPFloatRatingView  that can set whole, half or floating point ratings with multiple rating imgaes.
 
https://github.com/glenyi/TPFloatRatingView
 
*/

#import <UIKit/UIKit.h>

@protocol SCRatingViewDelegate;


@interface SCRatingView : UIView


@property (weak, nonatomic) id <SCRatingViewDelegate> delegate;

//Sets the images from array. Provide maxRating(else images will be re used) UIImage objects.
//Keep images of same size.

@property (strong,nonatomic) NSMutableArray *fullSelectedImages;

@property (strong,nonatomic) NSMutableArray *emptySelectedImages;


//Sets the empty and full image view content mode. Defaults to UIViewContentModeCenter.

@property (nonatomic) UIViewContentMode contentMode;


//Minimum rating. Default is 0.

@property (nonatomic) NSInteger minimumRating;

//Max rating value. Default is 5.

@property (nonatomic) NSInteger maximumRating;


//Minimum image size. Default is CGSize(5,5).

@property (nonatomic) CGSize minimumImageSize;


// Set the current rating. Default is 0.

@property (nonatomic) CGFloat rating;

//Sets whether or not the rating view is editable. Default is NO.

@property (nonatomic) BOOL isEditable;

// Ratings change by 0.5. Overrides floatRatings property. Default is NO.

@property (nonatomic) BOOL enableHalfRatings;

//Ratings change by floating point values. Default is NO.

@property (nonatomic) BOOL enableFlaotRatings;


@end


@protocol SCRatingViewDelegate <NSObject>
@optional

//Returns the rating value when touch events end.

- (void)floatRatingView:(SCRatingView *)ratingView ratingDidChange:(CGFloat)rating;

// Returns the current rating value as the user pans.

- (void)floatRatingView:(SCRatingView *)ratingView continuousRating:(CGFloat)rating;

@end
