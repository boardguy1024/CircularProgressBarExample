//
//  ViewController.swift
//  CircularProgressBarExample
//
//  Created by park kyung suk on 2018/04/25.
//  Copyright © 2018年 park kyung suk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // To testing Download dummy file
    let urlString = "https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4"
    
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 2, clockwise: true)
        
        // trackLayer
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.gray.cgColor
        trackLayer.lineWidth = 10
        trackLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackLayer)
        
        // line
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        //strokeEndのdefaultは1なのでstrokeが全部描画される
        //0は当然描画なし、0.5は半分描画される
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = kCALineCapRound
        
        view.layer.addSublayer(shapeLayer)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    
    private func beginDownlodingFile() {
        print("Attempting to downlonding file")
        
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: self.urlString) else { return }
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    fileprivate func animateCircle() {
        //shapeLayerでStartとEndを基準にインタバルを設定することでAnimationするためのクラス
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        
        //animation duration
        basicAnimation.duration = 2
        
        //animationが終わっても描いたstrokeを維持する
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "some")
    }
    
    @objc private func handleTap() {
        print("Circle tapped!!")
        
        beginDownlodingFile()
        //animateCircle()
    }

}

extension ViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        //print(totalBytesWritten, totalBytesExpectedToWrite)
        
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        print("isMainThread? : \(Thread.isMainThread)")
        
       // shapeLayer.strokeEnd = percentage
        DispatchQueue.main.async {
            self.shapeLayer.strokeEnd = percentage
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("downloding completed!")
    }
    
    
}

