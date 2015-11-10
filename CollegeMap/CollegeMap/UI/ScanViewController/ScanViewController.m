//
//  ScanViewController.m
//  CollegeMap
//
//  Created by Andrew on 15/11/3.
//  Copyright (c) 2015年 Tecomtech. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "QRCodeView.h"
#import "AZAlertView.h"
#import "NetWorkController.h"
#import "UIView+TYAlertView.h"
#import "TYAlertController+BlurEffects.h"

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>

{
    AVCaptureSession           * _session;
    AVCaptureVideoPreviewLayer * _videoLayer;
    QRCodeView                 * _codeView;
    NSString                   * _barcode;
}

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.navigationController.navigationBar setTintColor:TitleColor];
    
    [self setupBackButton];
    
//    [self startCodeReading];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self startCodeReading];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self stopReading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupBackButton
{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)cancel
{
    [self stopReading];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - CodeReading

- (void)startCodeReading
{
    [self setupSession];

    _videoLayer = [self setupPreviewLayer];
    
    _codeView = [[QRCodeView alloc] initWithFrame:_videoLayer.frame];
    [_codeView setTag:0];
    [self.view addSubview:_codeView];
    
    [_session startRunning];
}

- (void)stopReading{
    [_session stopRunning];
    _session = nil;
    [_videoLayer removeFromSuperlayer];
    _videoLayer = nil;
}

- (void)setupSession
{
    /**
     *  获取摄像设备
     */
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    //设置代理 在主线程刷新
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [output setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //初始化链接对象
    _session = [[AVCaptureSession alloc] init];
    //设置采集率为高质量
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [_session addInput:input];
    [_session addOutput:output];
    
    //设置扫码支持的编码格式
    output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    output.rectOfInterest = CGRectMake(0.125, 0.125, 0.75, 0.75);
}

- (AVCaptureVideoPreviewLayer *)setupPreviewLayer
{
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
    [self.view.layer addSublayer:layer];
    
    return layer;
}

#pragma mark - AVCaptureOutPut
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        
        NSLog(@"%@",metadataObject.stringValue);
        
        NSString *code = metadataObject.stringValue;
        _barcode = code;
        
        if (code.length != 13 && code.length != 8) {
            [_codeView showFailSoon];
        } else {
            [_session stopRunning];
            
            NSDictionary *barcodeResult = [self getBarcodeResult:code];
            
            [self performSelectorOnMainThread:@selector(showPopUpView:) withObject:barcodeResult waitUntilDone:YES];
        }
    }
}

- (void)showPopUpView: (NSDictionary *)barcodeResult
{
    AZAlertView *azView = [[AZAlertView alloc]initWithTY:self andFrame:CGRectMake(0, 0, 300, 300)];
    azView.ScanVC = self;
    [azView AZSetBarcodeResultWithDic:barcodeResult andBarcode:_barcode];
    
    TYAlertController *tyController = [TYAlertController alertControllerWithAlertView:azView preferredStyle:TYAlertControllerStyleAlert];

    [tyController setBlurEffectWithView:self.view];
    
    __weak id wself = self;
    
    [self presentViewController:tyController animated:YES completion:^{
        [wself stopReading];
    }];
}

- (NSDictionary *)getBarcodeResult:(NSString *)barcode
{
    NetWorkController *netCon = [[NetWorkController alloc] init];
    NSDictionary *result = [netCon searchBarcode:barcode];
    
    return result;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
