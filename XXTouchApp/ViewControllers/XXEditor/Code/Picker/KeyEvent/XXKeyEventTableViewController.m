//
//  XXKeyEventTableViewController.m
//  XXTouchApp
//
//  Created by Zheng on 9/29/16.
//  Copyright © 2016 Zheng. All rights reserved.
//

#import "XXKeyEventTableViewController.h"
#import "XXKeyEventModel.h"
#import "XXKeyEventTableViewCell.h"
#import "XXCodeMakerService.h"

static NSString * const kXXKeyEventTableViewCellReuseIdentifier = @"kXXKeyEventTableViewCellReuseIdentifier";

@interface XXKeyEventTableViewController ()
@property (nonatomic, strong) NSArray <XXKeyEventModel *> *keyEvents;
@property (nonatomic, strong) UIBarButtonItem *nextButton;

@end

@implementation XXKeyEventTableViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Key Event", nil);
    
    if (_codeBlock) {
        self.navigationItem.rightBarButtonItem = self.nextButton;
    }
}

#pragma mark - Getter

- (UIBarButtonItem *)nextButton {
    if (!_nextButton) {
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(next:)];
        nextButton.tintColor = [UIColor whiteColor];
        _nextButton = nextButton;
    }
    return _nextButton;
}

- (void)next:(UIBarButtonItem *)sender {
    [self pushToNextControllerWithKeyword:@"@key@" replacement:@""];
}

- (void)pushToNextControllerWithKeyword:(NSString *)keyword
                            replacement:(NSString *)replace {
    XXCodeBlockModel *newBlock = [_codeBlock mutableCopy];
    NSString *code = newBlock.code;
    NSRange range = [code rangeOfString:keyword];
    if (range.length == 0) return;
    newBlock.code = [code stringByReplacingCharactersInRange:range withString:replace];
    newBlock.offset = -1;
    [XXCodeMakerService pushToMakerWithCodeBlockModel:newBlock controller:self];
}

#pragma mark - Events

- (NSArray <XXKeyEventModel *> *)keyEvents {
    if (!_keyEvents) {
        _keyEvents = @[
                       [XXKeyEventModel modelWithTitle:NSLocalizedString(@"Home Button", nil) command:@"HOMEBUTTON"],
                       [XXKeyEventModel modelWithTitle:NSLocalizedString(@"Volume +", nil) command:@"VOLUMEUP"],
                       [XXKeyEventModel modelWithTitle:NSLocalizedString(@"Volume -", nil) command:@"VOLUMEDOWN"],
                       [XXKeyEventModel modelWithTitle:NSLocalizedString(@"Power Button", nil) command:@"LOCK"],
                       [XXKeyEventModel modelWithTitle:NSLocalizedString(@"Return Key", nil) command:@"RETURN"],
                       [XXKeyEventModel modelWithTitle:NSLocalizedString(@"Esc Key", nil) command:@"ESCAPE"],
                       [XXKeyEventModel modelWithTitle:NSLocalizedString(@"Backspace Key", nil) command:@"BACKSPACE"],
                       [XXKeyEventModel modelWithTitle:NSLocalizedString(@"Space Key", nil) command:@"SPACE"],
                       [XXKeyEventModel modelWithTitle:NSLocalizedString(@"Tab Key", nil) command:@"TAB"],
                       [XXKeyEventModel modelWithTitle:NSLocalizedString(@"Media Forward Key", nil) command:@"FORWARD"],
                       [XXKeyEventModel modelWithTitle:NSLocalizedString(@"Media Rewind Key", nil) command:@"REWIND"],
                       [XXKeyEventModel modelWithTitle:NSLocalizedString(@"Media Forward 2 Key", nil) command:@"FORWARD2"],
                       [XXKeyEventModel modelWithTitle:NSLocalizedString(@"Media Rewind 2 Key", nil) command:@"REWIND2"],
                       [XXKeyEventModel modelWithTitle:NSLocalizedString(@"Media Play/Pause Key", nil) command:@"PLAYPAUSE"],
                       [XXKeyEventModel modelWithTitle:NSLocalizedString(@"Mute Button", nil) command:@"MUTE"],
                       [XXKeyEventModel modelWithTitle:NSLocalizedString(@"Spotlight Key", nil) command:@"SPOTLIGHT"],
                       [XXKeyEventModel modelWithTitle:NSLocalizedString(@"Bright +", nil) command:@"BRIGHTUP"],
                       [XXKeyEventModel modelWithTitle:NSLocalizedString(@"Bright -", nil) command:@"BRIGHTDOWN"],
                       [XXKeyEventModel modelWithTitle:NSLocalizedString(@"Show/Hide Keyboard", nil) command:@"SHOW_HIDE_KEYBOARD"],
                       ];
    }
    return _keyEvents;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.keyEvents.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XXKeyEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kXXKeyEventTableViewCellReuseIdentifier forIndexPath:indexPath];
        cell.keyEvent = self.keyEvents[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", cell.keyEvent.title, cell.keyEvent.command];
        return cell;
    }
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        [self pushToNextControllerWithKeyword:@"@key@" replacement:self.keyEvents[indexPath.row].command];
    }
}

@end