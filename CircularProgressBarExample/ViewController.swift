//
//  ViewController.swift
//  CircularProgressBarExample
//
//  Created by park kyung suk on 2018/04/25.
//  Copyright © 2018年 park kyung suk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = view.center
        let circularPath = UIBezierPath(arcCenter: center, radius: 100, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        
        // line
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 10
        
        //0にすることでendに到達した時点でstrokeは0になる
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    @objc private func handleTap() {
        print("Circle tapped!!")
        
        //shapeLayerでStartとEndを基準にインタバルを設定することでAnimationするためのクラス
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        shapeLayer.add(basicAnimation, forKey: "some")
    }

}

