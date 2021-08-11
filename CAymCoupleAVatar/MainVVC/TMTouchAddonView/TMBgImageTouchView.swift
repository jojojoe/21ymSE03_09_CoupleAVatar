//
//  TMBImageTouchView.swift
//  TMThumbnailMakerd
//
//  Created by JOJO on 2019/10/14.
//  Copyright © 2019 JOJO. All rights reserved.
//

import UIKit

class TMBgImageTouchView: TouchStuffView {
    
    var contentImageview: UIImageView!
    
    
    
    init(withImage bgImage:UIImage, viewSize:CGSize) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: viewSize.width, height: viewSize.height))
        setupView()
        setupContentImageView(contentImage: bgImage, viewSize: viewSize)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        backgroundColor = UIColor.clear
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
//        borderBgView.frame = bounds
        
    }
    
    func setupContentImageView(contentImage:UIImage, viewSize: CGSize) {
        
//        let whRatio: CGFloat = contentImage.size.width / contentImage.size.height
//        var imageWidth: CGFloat = viewSize.width
//        var imageHeight: CGFloat = viewSize.height
//        let canvasWH = imageWidth / imageHeight
//        if whRatio >= canvasWH {
//            imageHeight = imageWidth / whRatio;
//        } else {
//            imageWidth = imageHeight * whRatio;
//        }
//
//        let contentImageViewSize: CGSize = CGSize.init(width: imageWidth, height: imageHeight)
        
//        contentImageview = UIImageView.init(frame: CGRect.init(x: (viewSize.width - contentImageViewSize.width) / 2, y: (viewSize.height - contentImageViewSize.height) / 2, width: contentImageViewSize.width, height: contentImageViewSize.height))
        
        contentImageview = UIImageView.init()
        
        contentImageview.image = contentImage
        contentImageview.contentMode = .scaleAspectFit
        addSubview(contentImageview)
        sendSubviewToBack(contentImageview)
        
        contentImageview.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.top.right.left.bottom.equalToSuperview()
        }
    }
    

}
