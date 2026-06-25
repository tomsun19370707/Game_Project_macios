// The MIT License (MIT)
//
// Copyright (c) 2014 Suyeol Jeon (http:xoul.kr)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import <objc/runtime.h>
#import "UITextView+Placeholder.h"

@implementation UITextView (PlaceholderExt)

#pragma mark - Swizzle Dealloc

+ (void)load {
    // is this the best solution?
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(swizzledDealloc)));
}

- (void)swizzledDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UITextView *textView = objc_getAssociatedObject(self, @selector(placeholderTextViewExt));
    if (textView) {
        for (NSString *key in self.class.observingKeys) {
            @try {
                [self removeObserver:self forKeyPath:key];
            }
            @catch (NSException *exception) {
                // Do nothing
            }
        }
    }
    [self swizzledDealloc];
}


#pragma mark - Class Methods
#pragma mark `defaultPlaceholderColorExt`

+ (UIColor *)defaultPlaceholderColorExt {
    if (@available(iOS 13, *)) {
      SEL selector = NSSelectorFromString(@"placeholderTextColor");
      if ([UIColor respondsToSelector:selector]) {
        return [UIColor performSelector:selector];
      }
    }
    static UIColor *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = @" ";
        NSDictionary *attributes = [textField.attributedPlaceholder attributesAtIndex:0 effectiveRange:nil];
        color = attributes[NSForegroundColorAttributeName];
        if (!color) {
          color = [UIColor colorWithRed:0 green:0 blue:0.0980392 alpha:0.22];
        }
    });
    return color;
}


#pragma mark - `observingKeys`

+ (NSArray *)observingKeys {
    return @[@"attributedText",
             @"bounds",
             @"font",
             @"frame",
             @"text",
             @"textAlignment",
             @"textContainerInset",
             @"textContainer.lineFragmentPadding",
             @"textContainer.exclusionPaths"];
}


#pragma mark - Properties
#pragma mark `placeholderTextViewExt`

- (UITextView *)placeholderTextViewExt {
    UITextView *textView = objc_getAssociatedObject(self, @selector(placeholderTextViewExt));
    if (!textView) {
        NSAttributedString *originalText = self.attributedText;
        self.text = @" "; // lazily set font of `UITextView`.
        self.attributedText = originalText;

        textView = [[UITextView alloc] init];
        textView.backgroundColor = [UIColor clearColor];
        textView.textColor = [self.class defaultPlaceholderColorExt];
        textView.userInteractionEnabled = NO;
        textView.isAccessibilityElement = NO;
        objc_setAssociatedObject(self, @selector(placeholderTextViewExt), textView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        self.needsUpdateFontExt = YES;
        [self updatePlaceholderTextViewExt];
        self.needsUpdateFontExt = NO;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updatePlaceholderTextViewExt)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];

        for (NSString *key in self.class.observingKeys) {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return textView;
}


#pragma mark `placeholderExt`

- (NSString *)placeholderExt {
    return self.placeholderTextViewExt.text;
}

- (void)setPlaceholderExt:(NSString *)placeholderExt {
    self.placeholderTextViewExt.text = placeholderExt;
    [self updatePlaceholderTextViewExt];
}

- (NSAttributedString *)attributedPlaceholderExt {
    return self.placeholderTextViewExt.attributedText;
}

- (void)setAttributedPlaceholderExt:(NSAttributedString *)attributedPlaceholderExt {
    self.placeholderTextViewExt.attributedText = attributedPlaceholderExt;
    [self updatePlaceholderTextViewExt];
}

#pragma mark `placeholderColorExt`

- (UIColor *)placeholderColorExt {
    return self.placeholderTextViewExt.textColor;
}

- (void)setPlaceholderColorExt:(UIColor *)placeholderColorExt {
    self.placeholderTextViewExt.textColor = placeholderColorExt;
}


#pragma mark `needsUpdateFontExt`

- (BOOL)needsUpdateFontExt {
    return [objc_getAssociatedObject(self, @selector(needsUpdateFontExt)) boolValue];
}

- (void)setNeedsUpdateFontExt:(BOOL)needsUpdate {
    objc_setAssociatedObject(self, @selector(needsUpdateFontExt), @(needsUpdate), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"font"]) {
        self.needsUpdateFontExt = (change[NSKeyValueChangeNewKey] != nil);
    }
    [self updatePlaceholderTextViewExt];
}


#pragma mark - Update

- (void)updatePlaceholderTextViewExt {
    if (self.text.length) {
        [self.placeholderTextViewExt removeFromSuperview];
        self.accessibilityValue = self.text;
    } else {
        [self insertSubview:self.placeholderTextViewExt atIndex:0];
        self.accessibilityValue = self.placeholderExt;
    }

    if (self.needsUpdateFontExt) {
        self.placeholderTextViewExt.font = self.font;
        self.needsUpdateFontExt = NO;
    }
    if (self.placeholderTextViewExt.attributedText.length == 0) {
      self.placeholderTextViewExt.textAlignment = self.textAlignment;
    }
    self.placeholderTextViewExt.textContainer.exclusionPaths = self.textContainer.exclusionPaths;
    self.placeholderTextViewExt.textContainerInset = self.textContainerInset;
    self.placeholderTextViewExt.textContainer.lineFragmentPadding = self.textContainer.lineFragmentPadding;
    self.placeholderTextViewExt.frame = self.bounds;
}

@end
