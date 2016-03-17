//
//  ViewController.m
//  GBNumSecureKeyboard
//
//  Created by xuguibin on 16-2-19.
//  Copyright (c) 2016年 LKGame. All rights reserved.
//

#import "ViewController.h"
#import "GBNumSecureKeyboard.h"

@interface ViewController ()<NumSecureKeyboardDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    _textField.numSecureDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"text : %@", _textField.text);
}

@end
