//
//  CodeCaptureSession.swift
//  CodeReader
//
//  Created by Александр Игнатьев on 14.02.15.
//  Copyright (c) 2015 Alexander Ignition. All rights reserved.
//

import Foundation
import AVFoundation

class CodeCaptureSession: AVCaptureSession, AVCaptureMetadataOutputObjectsDelegate {
    
    class func input(error outError: NSErrorPointer, mediaType type: String = AVMediaTypeVideo) -> AVCaptureInput? {
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(type)
        let input: AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: outError)
        return (input as? AVCaptureInput)
    }
    
    convenience init(input: AVCaptureInput) {
        self.init()
        self.addInput(input)
    }
    
    // MARK: - AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        // TODO
    }
    
    
}

