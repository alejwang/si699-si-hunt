//
//  ImgContainer.swift
//  ARKitImageRecognition
//
//  Created by Yi-Chen Weng on 4/14/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ImgContainer: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
//    let containerView = UIView()
//    let cornerRadius: CGFloat = 6.0
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        layoutView()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func layoutView(){
//        layer.backgroundColor = UIColor.clear.cgColor
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOffset = CGSize(width: 0, height: 1.0)
//        layer.shadowOpacity = 0.2
//        layer.shadowRadius = 4.0
//        
//        containerView.layer.cornerRadius = cornerRadius
//        containerView.layer.masksToBounds = true
//        
//        addSubview(containerView)
//    }
    
//
//
//    private var shadowLayer: CAShapeLayer!
//    private var cornerRadius: CGFloat = 25.0
//    private var fillColor: UIColor = .blue
//
//
//    func layoutSubViews() {
//        super.layoutSubviews()
//
//        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
//        shadowLayer.fillColor = fillColor.cgColor
//
//        shadowLayer.shadowColor = UIColor.black.cgColor
//        shadowLayer.shadowPath = shadowLayer.path
//        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//        shadowLayer.shadowOpacity = 0.2
//        shadowLayer.shadowRadius = 20
//
//        layer.insertSublayer(shadowLayer, at: 0)
//
//    }
    
//    override func didMoveToWindow() {
//        self.layer.cornerRadius = 20
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 20).cgPath
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
//        self.layer.shadowOpacity = 1
//        self.layer.shadowRadius = 30
//    }
}
