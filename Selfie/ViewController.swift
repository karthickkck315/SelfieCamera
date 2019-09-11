//
//  ViewController.swift
//  Selfie
//
//  Created by karthick kck on 09/04/2019.
//  Copyright © 2019 karthick kck. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var overlayImage: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
var img = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        if let devices = AVCaptureDevice.devices() as? [AVCaptureDevice]
        {
            for device in devices
            {
                if (device.hasMediaType(AVMediaType.video))
                {
                    if(device.position == AVCaptureDevice.Position.front)
                    {
                        captureDevice = device
                        if captureDevice != nil
                        {
                            print("Capture device found")
                            beginSession()
                        }
                    }
                }
            }
        }
    }
    func beginSession()
    {
    do
    {
        try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice!))
        stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecType.jpeg]
    if captureSession.canAddOutput(stillImageOutput)
    {
    captureSession.addOutput(stillImageOutput)
    }
    }
    catch
    {
    print("error: \(error.localizedDescription)")
    }
     let previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    self.view.layer.addSublayer(previewLayer)
    previewLayer.frame = self.view.layer.frame
    captureSession.startRunning()
    //self.view.addSubview(imageView)
        
        
        img.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        img.image = #imageLiteral(resourceName: "image")
        self.view.addSubview(img)
        
        imageView.isUserInteractionEnabled = true
        img.isUserInteractionEnabled = true
        
        let save = UIButton()
        save.frame = CGRect(x: 30, y: 50, width: 50, height: 50)
        save.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        save.backgroundColor = .red
        save.isUserInteractionEnabled = true
        self.view.addSubview(save)
    }
    @objc func saveImage() {
        let newSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)   // set this to what you need
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        //stillImageOutput.draw(CGRect(origin: CGPoint.zero, size: newSize))
        let immag = stillImageOutput as? UIImageView
        immag.draw(<#T##rect: CGRect##CGRect#>)
        img.draw(CGRect(origin: CGPoint.zero, size: newSize))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIImageWriteToSavedPhotosAlbum(newImage!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        
        // guard let image = imageView.image else { return }
        
        //let overlayImage = composite(image: imageView.image!, overlay: img.image!)
     //   let overlayImage = composite(image: imageView.image!, overlay: img.image!, scaleOverlay: true)
        
//            guard let image = imageView.image else { return }
//        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func composite(image:UIImage, overlay:(UIImage), scaleOverlay: Bool = false)->UIImage? {
        UIGraphicsBeginImageContext(image.size)
        var rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: rect)
        if scaleOverlay == false {
            rect = CGRect(x: 0, y: 0, width: overlay.size.width, height: overlay.size.height)
        }
        overlay.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    

}

