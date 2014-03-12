//
//  GCTagLabel.m
//  GCTagList
//
//  Created by Chiou Green on 13/9/5.
//  Copyright (c) 2013年 greenchiu. All rights reserved.
//

#import "GCTagLabel.h"
#import "GCTagList.h"
#import "UIColor+Uitilies.h"


#define COLOR_WATER_BLUE [UIColor colorWithString:@"#E0EAF4"]

#define DEFAULT_LABEL_BACKGROUND_COLOR [UIColor lightGrayColor]
#define DEFAULT_LABEL_TEXT_COLOR [UIColor blackColor]

#define LABEL_CORNER_RADIUS 15.f
#define LABEL_FONT_SIZE 13.f
#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING 3.0f
#define ACCESSORYVIEW_WIDTH 25.f
#define ACCESSORY_SIZE CGSizeMake(40, 40)

#pragma mark -
CGFloat const LabelDefaultFontSize = LABEL_FONT_SIZE;
CGFloat const LabelHorizontalPadding = HORIZONTAL_PADDING;
CGFloat const LabelVerticalPadding = VERTICAL_PADDING;

NSString * imageFontNameForType(GCTagLabelAccessoryType type) {
    NSString *imageFontName;
    
    switch (type) {
        case GCTagLabelAccessoryArrowSign:
            imageFontName = @"CGTagList.bundle/blue_arrow.png";
            break;
        case GCTagLabelAccessoryCrossSign:
            imageFontName = @"CGTagList.bundle/blue_close.png";
            break;
        default:
            imageFontName = nil;
            break;
    }
    
    return imageFontName;
}

CGFloat imageFontLeftInsetForType(GCTagLabelAccessoryType type) {
    CGFloat imageFontLeftInset = 0;
    
    switch (type) {
        case GCTagLabelAccessoryArrowSign:
            imageFontLeftInset = 10;
            break;
        case GCTagLabelAccessoryCrossSign:
            imageFontLeftInset = 9;
            break;
        default:
            imageFontLeftInset = 0;
            break;
    }
    
    return imageFontLeftInset;
}

@interface GCTagLabel () {
    BOOL _selected;
}
@property (nonatomic, GC_STRONG) UILabel *label;
@property (nonatomic, GC_STRONG) UIButton *accessoryButton;
@property (nonatomic, GC_STRONG) NSString *privateReuseIdentifier;
@property (assign) NSInteger index;

- (void)resizeLabel;

- (void)drawTagLabelUseLabelBackgroundColor:(UIColor *)color animated:(BOOL)animated;
- (void)drawTagLabelUseLabelBackgroundCGColor:(CGColorRef)color animated:(BOOL)animated;

@end

@implementation GCTagLabel

+ (CGRect)rectangleOfTagLabelWithText:(NSString *)textStr
                        labelMaxWidth:(CGFloat)maxWidth
                            labelFont:(UIFont *)font
                        accessoryType:(GCTagLabelAccessoryType)type {
    CGSize textSize = [textStr sizeWithFont:font
                          constrainedToSize:CGSizeMake(9999, 9999)
                              lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat deviationValue = type != GCTagLabelAccessoryNone ? ACCESSORYVIEW_WIDTH : 0;
    BOOL needCorrection =( (textSize.width + deviationValue + LabelHorizontalPadding * 2) > maxWidth );
    if(needCorrection) {
        textSize.width = maxWidth - LabelHorizontalPadding * 2 - deviationValue ;
    }
    
    
    CGRect labelFrame;
    labelFrame.origin = CGPointMake(LabelHorizontalPadding, 0);
    CGRect buttonFrame = CGRectZero;
    if (type != GCTagLabelAccessoryNone) {
        CGPoint buttonPoint = CGPointZero;
        
        buttonPoint.x = textSize.width + LabelHorizontalPadding;
        if (!needCorrection) {
            buttonPoint.x -= 9;
        }
        buttonPoint.y = (textSize.height - 24) / 2 ;
        
        buttonFrame = CGRectMake(0, 0, ACCESSORYVIEW_WIDTH, ACCESSORYVIEW_WIDTH);
        buttonFrame.origin = buttonPoint;
    }
    labelFrame.size = textSize;
    
    CGFloat viewWidth;
    if (!CGRectEqualToRect(buttonFrame, CGRectZero)) {
        viewWidth = buttonFrame.origin.x + CGRectGetWidth(buttonFrame);
    }
    else {
        viewWidth = labelFrame.origin.x + CGRectGetWidth(labelFrame);
    }
    
    viewWidth += LabelHorizontalPadding;
    //===========
    CGRect viewFrame = CGRectZero;
    viewFrame.size.width = viewWidth;
    viewFrame.size.height = textSize.height;
    return viewFrame;
}

+ (GCTagLabel *)tagLabelWithReuseIdentifier:(NSString *)identifier {
    GCTagLabel *tag = GC_AUTORELEASE([[GCTagLabel alloc] initReuseIdentifier:identifier]);
    return tag;
}

- (void)dealloc {
    // public property
    self.labelTextColor = nil;
    
    // private property
    self.label = nil;
    self.accessoryButton = nil;
    self.privateReuseIdentifier = nil;
#if !GC_SUPPORT_ARC
    [super dealloc];
#endif
}

- (void)setBackgroundColor:(UIColor *)backgroundColor withTextColor:(UIColor *)textColor
{
    self.labelTextColor = textColor;
    self.layer.backgroundColor =  backgroundColor.CGColor;
}

- (id)initReuseIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _selected = NO;
        self.maxWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        self.maxWidthFitToListWidth = YES;
        self.selectedEnabled = YES;
        self.privateReuseIdentifier = identifier;
        self.fitSize = CGSizeMake(self.maxWidth, 1500);
        self.labelTextColor = DEFAULT_LABEL_TEXT_COLOR;
        
        self.layer.cornerRadius = LABEL_CORNER_RADIUS;
    }
    return self;
}

- (void)setLabelText:(NSString *)text {
    [self setLabelText:text
         accessoryType:GCTagLabelAccessoryNone];
}

- (void)setLabelText:(NSString *)text accessoryType:(GCTagLabelAccessoryType)type {
    self.backgroundColor = [UIColor clearColor];
    self.accessoryType = type;
    
    if (!self.label) {
        self.label = GC_AUTORELEASE([[UILabel alloc] init]);
        /**
         * this set the label's textAlignment equals to 1 because the UITextAlignment is for iOS < 6.0
         * NSTextAlignment is for >= 6.0.
         * NSTextAlignmentCenter and UITextAlignmentCenter all equal to 1.
         */
        self.label.textAlignment = 1;
        self.label.backgroundColor = [UIColor clearColor];
        self.label.font = [UIFont systemFontOfSize:LabelDefaultFontSize];
        [self addSubview:self.label];
    }
    self.label.text = text;
    self.label.textColor = self.labelTextColor;
    
    if (type == GCTagLabelAccessoryNone) {
        [self.accessoryButton removeFromSuperview];
        self.accessoryButton = nil;
    }
    else if (type != GCTagLabelAccessoryNone && !self.accessoryButton) {
        self.accessoryButton = GC_AUTORELEASE([[UIButton alloc] initWithFrame:
                                               CGRectMake(0, 0,
                                                          ACCESSORYVIEW_WIDTH, ACCESSORYVIEW_WIDTH)]);
        [self addSubview:self.accessoryButton];
    }
    
    if (type!=GCTagLabelAccessoryNone) {
        [self.accessoryButton setImage:[UIImage imageNamed:imageFontNameForType(type)]
                              forState:UIControlStateNormal];
        self.accessoryButton.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                                imageFontLeftInsetForType(type),
                                                                0,
                                                                0);
        self.accessoryButton.imageView.contentMode = UIViewContentModeCenter;
        self.accessoryButton.highlighted = NO;
    }
    
}

- (NSString *)reuseIdentifier {
    return self.privateReuseIdentifier;
}

- (void)setSelected:(BOOL)selected animation:(BOOL)animated {
    _selected = selected;
    
    if (!self.selectedEnabled)
        return;
        
    [self drawTagLabelUseLabelBackgroundColor:[UIColor colorWithCGColor:self.layer.backgroundColor] animated:animated];
}

- (void)resizeLabel {
    CGSize textSize = [self.label.text sizeWithFont:self.label.font
                                  constrainedToSize:self.fitSize
                                      lineBreakMode:NSLineBreakByWordWrapping];
    
    
    //===========
    CGFloat deviationValue = self.accessoryType != GCTagLabelAccessoryNone ? ACCESSORYVIEW_WIDTH : 0;
    BOOL needCorrection =( (textSize.width + deviationValue + HORIZONTAL_PADDING * 2) > self.maxWidth );
    if(needCorrection) {
        textSize.width = self.maxWidth - HORIZONTAL_PADDING * 2 - deviationValue ;
        
        CGSize defaultSize = [@"DefaultSize" sizeWithFont:self.label.font
                                        constrainedToSize:self.fitSize
                                            lineBreakMode:NSLineBreakByWordWrapping];
        
        textSize.height = defaultSize.height;
    }
    
    textSize.height += VERTICAL_PADDING * 2;
    
    CGRect labelFrame;
    labelFrame.origin = CGPointMake(HORIZONTAL_PADDING, 0);
    
    if (self.accessoryType != GCTagLabelAccessoryNone) {
        CGPoint buttonPoint = CGPointZero;
        
        buttonPoint.x = textSize.width + HORIZONTAL_PADDING;
        if(!needCorrection)
            buttonPoint.x -= 9;
        buttonPoint.y = (textSize.height - 24) / 2 ;
        
        CGRect buttonFrame = self.accessoryButton.frame;
        buttonFrame.origin = buttonPoint;
        self.accessoryButton.frame = buttonFrame;
    }
    labelFrame.size = textSize;
    self.label.textAlignment = needCorrection ? 0 : 1;
    self.label.frame = labelFrame;
    
    CGFloat viewWidth;
    if (self.accessoryButton) {
        viewWidth = self.accessoryButton.frame.origin.x + CGRectGetWidth(self.accessoryButton.frame);
    }
    else {
        viewWidth = self.label.frame.origin.x + CGRectGetWidth(self.label.frame);
    }
    viewWidth += HORIZONTAL_PADDING;
    //===========
    CGRect viewFrame = CGRectZero;
    viewFrame.size.width = viewWidth;
    viewFrame.size.height = textSize.height;
    self.frame = viewFrame;
    
    [self drawTagLabelUseLabelBackgroundColor:
        self.layer.backgroundColor != nil ?
        [UIColor colorWithCGColor:self.layer.backgroundColor]
                                             : COLOR_WATER_BLUE
        animated:NO];
}

- (void)drawTagLabelUseLabelBackgroundColor:(UIColor *)color animated:(BOOL)animated {
    [self drawTagLabelUseLabelBackgroundCGColor:color.CGColor animated:animated];
}

- (void)drawTagLabelUseLabelBackgroundCGColor:(CGColorRef)color animated:(BOOL)animated {
    [CATransaction begin];
    if(!animated) {
        [CATransaction setValue:(id)kCFBooleanTrue
                         forKey:kCATransactionDisableActions];
    }
    else {
        [CATransaction setAnimationDuration: 0.3f];
    }
    self.layer.backgroundColor = color;
    [CATransaction commit];
}

- (void)didMoveToSuperview {
    if (![self.superview isKindOfClass:[GCTagList class]]) {
        CGRect rect = self.frame;
        [self resizeLabel];
        CGRect frame = self.frame;
        frame.origin = rect.origin;
        self.frame = frame;
    }
}

@end
