//
//  ViewController.swift
//  CircularProgressBarExample
//
//  Created by park kyung suk on 2018/04/25.
//  Copyright © 2018年 park kyung suk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    
    
    // To testing Download dummy file
    let urlString = "https://www.sample-videos.com/video/mp4/720/big_buck_bunny_720p_1mb.mp4"
    
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .black
        percentageLabel.textColor = .white
        completedLabel.textColor = .yellow
        completedLabel.isHidden = true
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        // trackLayer
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.darkGray.cgColor
        trackLayer.lineWidth = 20
        trackLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(trackLayer)
        trackLayer.position = view.center
        
        // line
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 20
        shapeLayer.fillColor = UIColor.clear.cgColor
        //strokeEndのdefaultは1なのでstrokeが全部描画される
        //0は当然描画なし、0.5は半分描画される
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.position = view.center
        
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        
        view.layer.addSublayer(shapeLayer)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    
    private func beginDownlodingFile() {
        print("Attempting to downlonding file")
        
        self.completedLabel.isHidden = true
        //downloding前のpositionに設定
        shapeLayer.strokeEnd = 0
        
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
            self.percentageLabel.text = "\(Int(percentage * 100))%"
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print("downloding completed!")
        DispatchQueue.main.async {
           self.completedLabel.isHidden = false
        }
        
    }
    
    
}

