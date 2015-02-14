//
//  ViewController.swift
//  CodeReader
//
//  Created by Александр Игнатьев on 14.02.15.
//  Copyright (c) 2015 Alexander Ignition. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    var codeCuptureSession: CodeCaptureSession?
    let supportedBarCodes = [
        AVMetadataObjectTypeQRCode,
        AVMetadataObjectTypeCode128Code,
        AVMetadataObjectTypeCode39Code,
        AVMetadataObjectTypeCode93Code,
        AVMetadataObjectTypeUPCECode,
        AVMetadataObjectTypePDF417Code,
        AVMetadataObjectTypeEAN13Code,
        AVMetadataObjectTypeAztecCode
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var error:NSError?
        let input = CodeCaptureSession.input(error: &error)
        if error != nil {
            // TODO
        }
        codeCuptureSession = CodeCaptureSession(input: input!)
        outputForSession(codeCuptureSession!)
        addPreviewLayerFromSession(codeCuptureSession!)
        codeCuptureSession?.startRunning()
        view.bringSubviewToFront(messageLabel)
        addQRFrameView()
    }
    
    func outputForSession(session: AVCaptureSession) {
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        output.metadataObjectTypes = supportedBarCodes
    }
    
    func addPreviewLayerFromSession(session: AVCaptureSession) {
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
    }
    
    func addQRFrameView() {
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
    }

    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        if isOutputMetadataObjects(metadataObjects) == true {
//            println("metadataObjects \(metadataObjects.count)")
            let metadataObject = metadataObjects[0] as AVMetadataMachineReadableCodeObject
            outputMetadataObject(metadataObject)
        }
    }
    
    func isOutputMetadataObjects(metadataObjects: [AnyObject]!) -> Bool {
        if metadataObjects != nil && metadataObjects.count > 0 {
            println("true")
            return true
        }
        qrCodeFrameView?.frame = CGRectZero
        messageLabel.text = "No QR code is detected"
        messageLabel.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.9)
        println("false")
        return false
    }
    
    func outputMetadataObject(metadataObject: AVMetadataMachineReadableCodeObject) {
        
        if supportedBarCodes.filter({ $0 == metadataObject.type }).count > 0 {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObject)
            qrCodeFrameView?.frame = (barCodeObject as AVMetadataMachineReadableCodeObject).bounds;
            
            messageLabel.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.9)
            if metadataObject.stringValue != nil {
                messageLabel.text = metadataObject.stringValue
            }
        }
    }
    

}












