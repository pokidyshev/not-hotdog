//
//  ViewController.swift
//  NotHotDog
//
//  Created by Nikita Pokidyshev on 09/11/2017.
//  Copyright © 2017 Nikita Pokidyshev. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    let model = try! VNCoreMLModel(for: Resnet50().model)
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "❌ Not Hotdog ❌"
        label.font = label.font.withSize(30)
        return label
    }()
    
    
    func setupLabel() {
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
        
        view.addSubview(label)
        setupLabel()
    }

    func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices
        captureSession.addInput(try! AVCaptureDeviceInput(device: devices.first!))
        let output = AVCaptureVideoDataOutput()
        captureSession.addOutput(output)
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
        
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let request = VNCoreMLRequest(model: model) { (finishedRequest, error) in
            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
            guard let observation = results.first else { return }
            
            DispatchQueue.main.async {
                if observation.identifier.contains("hotdog") {
                    self.label.text = "🌭 Hotdog 🌭"
                } else {
                    self.label.text = "❌ Not Hotdog ❌"
                }
            }
        }
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}

