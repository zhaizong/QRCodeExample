//
//  QRScannerController.swift
//  QRCodeReader
//
//  Created by Crazy on 10/1/2017.
//  Copyright © 2017 Crazy. All rights reserved.
//

import UIKit
import AVFoundation // 1

class QRScannerController: UIViewController {

  // MARK: - IBOutlet
  
  @IBOutlet var messageLabel:UILabel! // 用于显示解码后的信息
  @IBOutlet var topbar: UIView!
  
  // MARK: - Property
  
  /* 3 */
  /*
   二维码识别完全是依赖视频捕捉的, 为了进行实时捕捉, 需要实例化一个AVCaptureSession对象来进行视频捕捉.
   */
  var captureSession: AVCaptureSession?
  var videoPreviewLayer: AVCaptureVideoPreviewLayer?
  var qrCodeFrameView: UIView?
    
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    
    /* 4 */
//    Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
    let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) // 一个AVCaptureDevice代表一个物理设备, 通过AVMediaTypeVideo来获得视频捕捉设备
    do {
//      Get an instance of the AVCaptureDeviceInput class using the previous device object.
      let input = try AVCaptureDeviceInput(device: captureDevice)
//      实例化一个AVCaptureSession对象，用来协调从视频输入设备到输出数据流。
      captureSession = AVCaptureSession()
//      添加视频捕捉设备的输入。
      captureSession?.addInput(input)
      
      /*
       AVCaptureMetaDataOutput类是二维码识别的核心部分。AVCaptureMetaDataOutput类与AVCaptureMetadataOutputObjectsDelegate协议相结合，用于截获输入设备中被发现的任何元数据（由设备的摄像头所捕获的二维码）并将其翻译成人类可读的形式。
       */
      let captureMetadataOutput = AVCaptureMetadataOutput()
      captureSession?.addOutput(captureMetadataOutput)
      
//      设置执行delegate的调度队列，DispatchQueue.main获取默认串行队列。
      captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
      captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode,
                                                   AVMetadataObjectTypeEAN8Code,
                                                   AVMetadataObjectTypeEAN13Code,
                                                   AVMetadataObjectTypeUPCECode,
                                                   AVMetadataObjectTypeAztecCode,
                                                   AVMetadataObjectTypeCode39Code,
                                                   AVMetadataObjectTypeCode39Mod43Code,
                                                   AVMetadataObjectTypeCode93Code,
                                                   AVMetadataObjectTypeCode128Code,
                                                   AVMetadataObjectTypePDF417Code]
      
      /* 5 */
//      需要在屏幕上显示通过设备摄像头捕捉的视频，通过AVCaptureVideoPreviewLayer实现。
      videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
      videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
      videoPreviewLayer?.frame = view.layer.frame
      view.layer.addSublayer(videoPreviewLayer!)
      
      /* 6 */
//      通过调用startRunning()方法启动视频捕获.
      captureSession?.startRunning()
      
      /* 7 */
      view.bringSubview(toFront: messageLabel)
      view.bringSubview(toFront: topbar)
      
      /* 8 */
      qrCodeFrameView = UIView(frame: .zero) // 初始化绿色边框，当检测二维码时再改变它的大小。
      if let qrCodeFrameView = qrCodeFrameView {
        qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
        qrCodeFrameView.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView)
        view.bringSubview(toFront: qrCodeFrameView)
      }
    } catch {
//      If any error occurs, simply print it out and don't continue any more
      debugPrint("Error: \(error)")
    }
    
  }

}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate /* 2 */ {
  
  /* 9 */
  func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
//    metadataObjects包含所有已读取的元数据对象
    if metadataObjects == nil || metadataObjects.count == 0 {
      qrCodeFrameView?.frame = .zero
      messageLabel.text = "No QR code is detected"
      return
    }
//    获取 metadata 对象。
    let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
//      如果发现元数据是二维码就 update the messageLabel.text 和设置 qrCodeFrameView?.frame.
    if metadataObject.type == AVMetadataObjectTypeQRCode {
//      transformedMetadataObject这个方法会将元数据对象的视觉特性转换为层坐标，以找到二维码的bounds。
      let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObject)
      qrCodeFrameView?.frame = barCodeObject!.bounds
//      通过stringValue属性访问被解码的信息。
      if metadataObject.stringValue != nil {
        messageLabel.text = metadataObject.stringValue
      }
    }
  }
  
}
