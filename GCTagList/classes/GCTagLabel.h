//
//  GCTagLabel.h
//  GCTagList
//
//  Created by Chiou Green on 13/9/5.
//  Copyright (c) 2013年 greenchiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#ifndef GC_SUPPORT_ARC
#if __has_feature(objc_arc)
#define GC_SUPPORT_ARC 1
#else
#define GC_SUPPORT_ARC 0
#endif
#endif

#ifndef GC_STRONG
#if GC_SUPPORT_ARC
#define GC_STRONG strong
#else
#define GC_STRONG retain
#endif
#endif

#ifndef GC_WEAK
#if __has_feature(objc_arc_weak)
#define GC_WEAK weak
#elif __has_feature(objc_arc)
#define GC_WEAK unsafe_unretained
#else
#define GC_WEAK assign
#endif
#endif

#if GC_SUPPORT_ARC
#define GC_AUTORELEASE(exp) exp
#define GC_RELEASE(exp) exp
#define GC_RETAIN(exp) exp
#else
#define GC_AUTORELEASE(exp) [exp autorelease]
#define GC_RELEASE(exp) [exp release]
#define GC_RETAIN(exp) [exp retain]
#endif

#define DEFAULT_TAG_BACKGROUND_COLOR [UIColor colorWithString:@"#E0EAF4"]
#define DEFAULT_TAG_CORNER_RADIUS 10.0f;

#define DEFAULT_LABEL_BACKGROUND_COLOR [UIColor lightGrayColor]
#define DEFAULT_LABEL_TEXT_COLOR [UIColor blackColor]

#define DEFAULT_LABEL_FONT_SIZE 13.0f
#define DEFAULT_HORIZONTAL_PADDING 7.0f
#define DEFAULT_VERTICAL_PADDING 3.0f

#define DEFAULT_ACCESSORYVIEW_SIDE 25.0f
#define DEFAULT_ACCESSORYVIEW_RECT CGRectMake(0, 0, DEFAULT_ACCESSORYVIEW_SIDE, DEFAULT_ACCESSORYVIEW_SIDE)

@class GCTagList;

typedef NS_ENUM(NSInteger, GCTagLabelAccessoryType) {
    GCTagLabelAccessoryNone,
    GCTagLabelAccessoryCrossSign,
    GCTagLabelAccessoryArrowSign
};

@interface GCTagLabel : UIView
@property (nonatomic, readonly, copy) NSString* reuseIdentifier;

/* Label style managing */
@property (nonatomic, GC_STRONG) UIColor *labelTextColor;
@property (nonatomic, GC_STRONG) UIColor *labelBackgroundColor;
/* Tag style managing */
@property (nonatomic, GC_STRONG) UIColor *tagBackgroundColor;

@property (assign) GCTagLabelAccessoryType accessoryType;

/* if selectedEnabled = YES then taglabel could show
 * selected state. default is YES
 */
@property (assign) BOOL selectedEnabled;
@property (readonly) BOOL selected;

@property (assign) CGSize fitSize;

/**
 * let the maxWidth equal to the taglist's width,
 * default is YES.
 */
@property (assign) BOOL maxWidthFitToListWidth;

/**
 * Limit TagLabel's max width, default is CGRectGetWidth([UIScreen mainScreen].bounds)
 */
@property (assign) CGFloat maxWidth;
+ (CGRect)rectangleOfTagLabelWithText:(NSString *)textStr
                        labelMaxWidth:(CGFloat)maxWidth
                            labelFont:(UIFont *)font
                        accessoryType:(GCTagLabelAccessoryType)type;
+ (GCTagLabel *)tagLabelWithReuseIdentifier:(NSString *)identifier;
- (id)initReuseIdentifier:(NSString *)identifier;

/**
 * setLabelText, and the accessoryType is GCTagLabelAccessoryNone
 */
- (void)setLabelText:(NSString*)text;
- (void)setLabelText:(NSString*)text accessoryType:(GCTagLabelAccessoryType)type;
- (void)setSelected:(BOOL)selected animation:(BOOL)animated;
/* style managing */
- (void)setTagBackgroundColor:(UIColor *)tagBackgroundColor
      andLabelBackgroundColor:(UIColor *)labelBackgroundColor
           withLabelTextColor:(UIColor *)labelTextColor;
@end


