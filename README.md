# QRCodeExample
Barcode and QR code reader, written in pure Swift.

* 在iOS中任何的条形码扫描，包括二维码扫描，都是基于视频捕捉的。这也是为什么条形码扫描功能添加在AVFoundation框架之中。
* 这个例子相当于一个没有记录功能的视频捕捉应用。当app启动时，它利用iPhone的后置摄像头自动识别二维码。被解码的信息（例如一个网址）显示在屏幕底部的右方。

# The Steps

* 1.导入 AVFoundation 框架。
```swift
import AVFoundation
```
* 2.导入 AVCaptureMetadataOutputObjectsDelegate 协议，稍后会用到。
```swift
extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
}
```
* 3.在 QRScannerController 类中声明三个变量。
```swift
  var captureSession: AVCaptureSession?
  var videoPreviewLayer: AVCaptureVideoPreviewLayer?
  var qrCodeFrameView: UIView?
```
* 4.实例化一个 AVCaptureSession 对象来进行视频捕捉。在 viewDidLoad() 中插入下面代码。
```swift
let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
do {
  let input = try AVCaptureDeviceInput(device: captureDevice)
  captureSession = AVCaptureSession()
  captureSession?.addInput(input)

  let captureMetadataOutput = AVCaptureMetadataOutput()
  captureSession?.addOutput(captureMetadataOutput)

  captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
  captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
} catch {
  debugPrint("Error: \(error)")
}
```
* 5.需要在屏幕上显示通过设备摄像头捕捉的视频，通过AVCaptureVideoPreviewLayer实现。在do-catch block中插入代码
```swift
  videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
  videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
  videoPreviewLayer?.frame = view.layer.frame
  view.layer.addSublayer(videoPreviewLayer!)
```
* 6.通过调用startRunning()方法启动视频捕获.
```swift
  captureSession?.startRunning()
```
* 7.添加以下代码使messageLabel和topbar显示在视频层的最上边。
```swift
  view.bringSubview(toFront: messageLabel)
  view.bringSubview(toFront: topbar)
```
* 8.初始化绿色边框，以突出二维码。在do-catch block中插入代码
```swift
qrCodeFrameView = UIView(frame: .zero)
if let qrCodeFrameView = qrCodeFrameView {
  qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
  qrCodeFrameView.layer.borderWidth = 2
  view.addSubview(qrCodeFrameView)
  view.bringSubview(toFront: qrCodeFrameView)
}
```
* 9.当AVCaptureMetadataOutput对象识别二维码时，AVCaptureMetadataOutputObjectsDelegate代理方法会被调用。
```swift
实现代理方法
optional public func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!)
```
* 如果是真机测试，还需要在Info.plist加入以下字段。
```swift
Privacy - Camera Usage Description
```

# Requirements

* iOS 8.0+
