//
//  ZGExternalVideoFilterPublishViewController.m
//  LiveRoomPlayground-iOS
//
//  Created by Paaatrick on 2019/7/22.
//  Copyright © 2019 Zego. All rights reserved.
//

#ifdef _Module_ExternalVideoFilter

#import "ZGExternalVideoFilterPublishViewController.h"
#import "ZGExternalVideoFilterDemo.h"
#import "FUManager.h"
#import "FUAPIDemoBar.h"
#import "Masonry.h"

#import "FUTestRecorder.h"

@interface ZGExternalVideoFilterPublishViewController () <ZGExternalVideoFilterDemoProtocol, FUAPIDemoBarDelegate>

// 屏幕底部的 FaceUnity 美颜控制条
@property (nonatomic, strong) FUAPIDemoBar *demoBar;

@property (nonatomic, strong) ZGExternalVideoFilterDemo *demo;

@property (weak, nonatomic) IBOutlet UILabel *publishQualityLabel;
@property (weak, nonatomic) IBOutlet UISwitch *previewMirrorSwitch;

@property (nonatomic, assign) BOOL enablePreviewMirror;

@end

@implementation ZGExternalVideoFilterPublishViewController

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.demo = [[ZGExternalVideoFilterDemo alloc] init];
    self.demo.delegate = self;
    
    // 先加载外部滤镜工厂
    [self.demo initFilterFactoryType:self.selectedFilterBufferType];
    
    // 然后初始化 ZegoLiveRoom SDK
    [self.demo initSDKWithRoomID:self.roomID streamID:self.streamID isAnchor:YES];
    
    // 初始化美颜
    [self setupFaceUnity];
    
     //预览镜像
    self.enablePreviewMirror = YES;
    self.previewMirrorSwitch.on = self.enablePreviewMirror;
    
    [self.demo loginRoom];
    [self.demo startPreview];
    [self.demo enablePreviewMirror:self.enablePreviewMirror];
    [self.demo startPublish];
}

- (void)dealloc {
    [[FUManager shareManager] destoryItems];
    
    [self.demo stopPublish];
    [self.demo stopPreview];
    [self.demo logoutRoom];
    
    self.demo = nil;
    
}

#pragma mark - setupFaceUnity

/// 初始化美颜SDK
- (void)setupFaceUnity{

    [[FUTestRecorder shareRecorder] setupRecord];
    
    [[FUManager shareManager] loadFilter];
    [FUManager shareManager].isRender = YES;
    [FUManager shareManager].flipx = NO;
    [FUManager shareManager].trackFlipx = NO;
    
    // 设置屏幕底部的 FaceUnity 美颜控制条
    _demoBar = [[FUAPIDemoBar alloc] init];
    _demoBar.mDelegate = self;
    [self.view addSubview:_demoBar];
    [_demoBar mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(195);
    }];
    
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.demoBar hiddenTopViewWithAnimation:YES];
}

- (IBAction)onSwitchPreviewMirror:(UISwitch *)sender {
    self.enablePreviewMirror = sender.on;
    [self.demo enablePreviewMirror:self.enablePreviewMirror];
}


#pragma mark - FaceUnity method
// 以下方法都是 FaceUnity 相关的视图和业务逻辑

#pragma mark -  FUAPIDemoBarDelegate

#pragma -FUAPIDemoBarDelegate
-(void)filterValueChange:(FUBeautyParam *)param{
    [[FUManager shareManager] filterValueChange:param];
}

-(void)switchRenderState:(BOOL)state{
    [FUManager shareManager].isRender = state;
}

-(void)bottomDidChange:(int)index{
    if (index < 3) {
        [[FUManager shareManager] setRenderType:FUDataTypeBeautify];
    }
    if (index == 3) {
        [[FUManager shareManager] setRenderType:FUDataTypeStrick];
    }
    
    if (index == 4) {
        [[FUManager shareManager] setRenderType:FUDataTypeMakeup];
    }
    if (index == 5) {
        
        [[FUManager shareManager] setRenderType:FUDataTypebody];
    }
}

#pragma mark - ZGExternalVideoFilterDemoProtocol
- (nonnull UIView *)getPlaybackView {
    return self.view;
}

- (void)onExternalVideoFilterPublishStateUpdate:(NSString *)state {
    self.title = state;
}

- (void)onExternalVideoFilterPublishQualityUpdate:(NSString *)state {
    self.publishQualityLabel.text = state;
}

@end

#endif
