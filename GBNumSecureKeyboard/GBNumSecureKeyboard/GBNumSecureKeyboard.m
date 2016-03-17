//
//  GBNumSecureKeyboard.m
//  GBNumSecureKeyboard
//
//  Created by xuguibin on 16-2-19.
//  Copyright (c) 2016年 LKGame. All rights reserved.
//

#import "GBNumSecureKeyboard.h"
#import <objc/runtime.h>

#define KeyboardKey       @"GBKeyboard"

@interface GBNumSecureKeyboard ()

@property (strong, nonatomic) NSMutableString *inputStr;

@property (weak, nonatomic) id<NumSecureKeyboardDelegate> delegate;
@property (weak, nonatomic) UITextField *textField;

@end

@implementation UITextField (NumSecureKeyboard)

- (void)setNumSecureDelegate:(id<NumSecureKeyboardDelegate>)numSecureDelegate {
    GBNumSecureKeyboard *numSecureKeyboard = [[GBNumSecureKeyboard alloc] init];
    self.inputView = numSecureKeyboard;
    numSecureKeyboard.delegate = numSecureDelegate;
    numSecureKeyboard.textField = self;
    objc_setAssociatedObject(self, KeyboardKey, numSecureKeyboard, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)text {
    GBNumSecureKeyboard *numSecureKeyboard = objc_getAssociatedObject(self, KeyboardKey);
    return numSecureKeyboard.inputStr;
}

@end

@implementation GBNumSecureKeyboard

- (instancetype)init {
    self = [super init];
    if (self) {
        _inputStr = [NSMutableString string];
        self.backgroundColor = [UIColor blackColor];
        CGRect frame = [UIApplication sharedApplication].keyWindow.bounds;
        self.frame = CGRectMake(0, frame.size.height - 300, frame.size.width, 300);
        NSArray *btnTitles = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"确定", @"0", @"X"];
        for (int i = 0; i < 12; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            CGFloat width = self.frame.size.width / 3;
            CGFloat height = self.frame.size.height / 4;
            btn.frame = CGRectMake(width * (i % 3), height * (i / 3), width, height);
            [btn addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)btnTap:(UIButton *)sender {
    UITextPosition *textBeginningPosition = _textField.beginningOfDocument;
    UITextRange *selectedTextRange = _textField.selectedTextRange;
    UITextPosition *selectedStartPosition = selectedTextRange.start;
    UITextPosition *selectedEndPosition = selectedTextRange.end;
    
    NSInteger location = [_textField offsetFromPosition:textBeginningPosition toPosition:selectedStartPosition];
    NSInteger length = [_textField offsetFromPosition:selectedStartPosition toPosition:selectedEndPosition];
    NSRange selectedRange = NSMakeRange(location, length);
    
    NSInteger offset = 0;
    
    if ([sender.titleLabel.text isEqualToString:@"X"]) {
        if (selectedRange.length == 0) {
            if (selectedRange.location == 0) {
                return;
            }
            selectedRange.location--;
            selectedRange.length = 1;
        }
        [_inputStr deleteCharactersInRange:selectedRange];
        offset = -1;
    } else if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        [_textField resignFirstResponder];
        if ([_delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
            [_delegate textFieldDidEndEditing:_textField];
        }
    } else {
        [_inputStr replaceCharactersInRange:selectedRange withString:sender.currentTitle];
        offset = 1;
    }
    
    NSMutableString *textStr = [NSMutableString stringWithString:@""];
    for (int i = 0; i < _inputStr.length; i++) {
        [textStr appendString:@"*"];
    }
    _textField.text = textStr;
    selectedStartPosition = [_textField positionFromPosition:selectedStartPosition offset:offset];
    
    UITextRange *endEditRange = [_textField textRangeFromPosition:selectedStartPosition toPosition:selectedStartPosition];
    [_textField setSelectedTextRange:endEditRange];
}

@end
