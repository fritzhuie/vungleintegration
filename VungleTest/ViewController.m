//
//  ViewController.m
//  VungleTest
//
//  Created by Fritz Huie on 4/14/22.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

UIButton* loadButton;
UIButton* showButton;

UIColor* greenColor;

UILabel* coinCountLabel;

int coinCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.blackColor;
    CGFloat frameWidth = self.view.frame.size.width;
    CGFloat frameHeight = self.view.frame.size.height;
    
    CGRect coinCountLabelFrame = CGRectMake(frameWidth*0.25,
                                  frameHeight*0.2,
                                  frameWidth*0.5,
                                  frameHeight*0.2);
    coinCountLabel = [[UILabel alloc] initWithFrame:coinCountLabelFrame];
    coinCountLabel.text = @"Coins: 0";
    coinCountLabel.textAlignment = UITextAlignmentCenter;
    [self.view addSubview: coinCountLabel];
    
    CGRect InstructionLabelFrame = CGRectMake(0,
                                  frameHeight*0.3,
                                  frameWidth,
                                  frameHeight*0.2);
    UILabel* instructions = [[UILabel alloc] initWithFrame:InstructionLabelFrame];
    instructions.text = @"Watch an ad to earn 10 coins";
    instructions.textAlignment = UITextAlignmentCenter;
    [self.view addSubview: instructions];
    
    greenColor = [UIColor colorWithRed:0.0 green:0.4 blue:0.0 alpha:1.0];
    

    CGRect vungleLoadButtonFrame = CGRectMake(frameWidth*0.25,
                                              frameHeight*0.5,
                                              frameWidth*0.5,
                                              frameHeight*0.1);
    CGRect vungleShowButtonFrame = CGRectMake(frameWidth*0.25,
                                              frameHeight*0.7,
                                              frameWidth*0.5,
                                              frameHeight*0.1);
    loadButton = [[UIButton alloc] initWithFrame:vungleLoadButtonFrame];
    showButton = [[UIButton alloc] initWithFrame:vungleShowButtonFrame];
    
    loadButton.backgroundColor = UIColor.darkGrayColor;
    showButton.backgroundColor = UIColor.darkGrayColor;
    
    [loadButton setTitle:@"Load Rewarded Ad" forState:normal];
    [showButton setTitle:@"Show Rewarded Ad" forState:normal];
    
    [loadButton addTarget:self action:@selector(loadRewardedAdButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [showButton addTarget:self action:@selector(showRewardedAdButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    loadButton.enabled = false;
    showButton.enabled = false;
    
    [self.view addSubview:loadButton];
    [self.view addSubview:showButton];
    
    [[VungleSDK sharedSDK] setDelegate:self];
    
    NSError* error;
    NSString* appID = @"6258be4d6d48934c88c6da31";
    
    if (![[VungleSDK sharedSDK] startWithAppId:appID error:&error]) {
        if (error) {
            NSLog(@"Error encountered starting the VungleSDK: %@", error);
        }
    }
    
}

- (void)vungleSDKDidInitialize {
    NSLog(@"vungleSDKDidInitialize - SDK INITIALIZED SUCCESSFULLY");
    loadButton.enabled = true;
    loadButton.backgroundColor = greenColor;
}

- (void)loadRewardedAdButtonPressed {
    NSLog(@"load rewarded ad button pressed");
    NSString* rewardedPlacement = @"DEFAULT-8305611";
    NSError *error = nil;
    if ([[VungleSDK sharedSDK] loadPlacementWithID:rewardedPlacement error:&error]) {
        NSLog(@"rewareded placement loaded successfully");
        showButton.enabled = true;
        showButton.backgroundColor = greenColor;
            } else {
                if (error) {
                    NSLog(@"Unable to load placement with reference ID :%@, Error %@", rewardedPlacement, error);
                }
            }
}

- (void)showRewardedAdButtonPressed {
    NSLog(@"Showing ad for placement DEFAULT-8305611");
    NSString* rewardedPlacement = @"DEFAULT-8305611";
    NSDictionary *options = @{VunglePlayAdOptionKeyOrientations: @(UIInterfaceOrientationMaskPortrait),
                              VunglePlayAdOptionKeyUser: @"123456",
                              VunglePlayAdOptionKeyIncentivizedAlertBodyText : @"If the video isn't completed you won't get your reward! Are you sure you want to close early?",
                              VunglePlayAdOptionKeyIncentivizedAlertCloseButtonText : @"Close",
                              VunglePlayAdOptionKeyIncentivizedAlertContinueButtonText : @"Keep Watching",
                              VunglePlayAdOptionKeyIncentivizedAlertTitleText : @"Careful!"};
    NSError *error;
    [[VungleSDK sharedSDK] playAd:self options:options placementID:rewardedPlacement error:&error];
    if (error) {
        NSLog(@"Error encountered playing ad: %@", error);
    }
    
    // Player would recieve server-side reward if the ad completes, approximating that behavior by giving the player coins now
    coinCount += 10;
    coinCountLabel.text = [NSString stringWithFormat: @"Coins: %i", coinCount];
}

@end
