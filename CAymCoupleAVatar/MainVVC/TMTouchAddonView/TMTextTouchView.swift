//
//  TMTextTouchView.swift
//  TMThumbnailMakerd
//
//  Created by JOJO on 2019/10/14.
//  Copyright © 2019 JOJO. All rights reserved.
//

import UIKit

class TMTextTouchView: TouchStuffView {
    
    var canvasContentView: UIView!
    
    
    var contentLabel: UILabel!
    var textBgView: UIView!
    
    
    var borderBgView: UIView!
    var deleteBtn: UIButton!
    var rotateBtn: UIImageView!
    
    var contentAttributeString: NSAttributedString!
    
    
    
    var textFont: UIFont = UIFont.systemFont(ofSize: 30)
    var textColorName: String = "000000"
    var contentString: String = "default"
    var fontIndexPath: IndexPath = IndexPath.init(item: 0, section: 0)
    var textColorIndexPath: IndexPath = IndexPath.init(item: 0, section: 0)
    var bgColorIndexPath: IndexPath = IndexPath.init(item: 0, section: 0)
    var textAlpha: Float = 1.0
    var textStrokeColorName = "00000000"
    var textBgColorName = "000000"
    var textBgBorderColorName = "00000000"
    var textBgCornerRadius: Float = 0
    
    
    var contentCanvasBounds: CGRect!
    
         
     init(withAttributeString attributeString: NSAttributedString, canvasBounds: CGRect) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: canvasBounds.width, height: canvasBounds.height))
        contentAttributeString = attributeString
        contentCanvasBounds = canvasBounds
        setupView()
        setupActionBtns()
        
        setupContentTextLabelWithAttributeString(contentString: attributeString)
        setupBorderViewWithSize(viewSize: canvasBounds.size, lineColor: UIColor.init(hex: "#000000"))
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width: CGFloat =  40
        deleteBtn.bounds = CGRect.init(x: 0, y: 0, width: width, height: width)
        deleteBtn.center = CGPoint.init(x: 0, y: 0)
        
        rotateBtn.bounds = CGRect.init(x: 0, y: 0, width: width, height: width)
        rotateBtn.center = CGPoint.init(x: bounds.width, y: bounds.height)
        
        borderBgView.frame = bounds
        
        guard let sublayers = borderBgView.layer.sublayers else { return }
        
        guard let shapeLayer: CAShapeLayer = sublayers.first as? CAShapeLayer else { return }
        
        shapeLayer.frame = CGRect.init(x: 0, y: 0, width: borderBgView.width(), height: borderBgView.height())
        shapeLayer.path = UIBezierPath.init(rect: CGRect.init(x: 0, y: 0, width: borderBgView.width(), height: borderBgView.height())).cgPath

        replaceSetupBgViewCornerRadius(cornerRadius: textBgCornerRadius)
        
    }
     
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        let pointDeleteBtn = deleteBtn.convert(point, from: self)
        let pointRotateBtn = rotateBtn.convert(point, from: self)
        
        if deleteBtn.bounds.contains(pointDeleteBtn) {
            return deleteBtn.hitTest(pointDeleteBtn, with: event)
        } else if rotateBtn.bounds.contains(pointRotateBtn) {
            return rotateBtn.hitTest(pointRotateBtn, with: event)
        }
        return super.hitTest(point, with: event)
        
    }
    
    func touchViewButtonOppositTransform(oppositView: UIView) {
        let touchTransform: CGAffineTransform = self.transform
        let rotation: CGFloat = atan2(touchTransform.b, touchTransform.a)
        let scaleX: CGFloat = CGFloat(sqrtf(Float(touchTransform.a * touchTransform.a + touchTransform.c * touchTransform.c)))
        let scaleY: CGFloat = CGFloat(sqrtf(Float(touchTransform.b * touchTransform.b + touchTransform.d * touchTransform.d)))
        
        oppositView.transform = CGAffineTransform.init(scaleX: 1/scaleX, y: 1/scaleY)
        oppositView.transform = oppositView.transform.rotated(by: -rotation)
        
    }
    
    func touchViewBorderOppositTransform(view: UIView) {
        let touchTransform: CGAffineTransform = self.transform
        let scaleX: CGFloat = CGFloat(sqrtf(Float(touchTransform.a * touchTransform.a + touchTransform.c * touchTransform.c)))
        let scaleY: CGFloat = CGFloat(sqrtf(Float(touchTransform.b * touchTransform.b + touchTransform.d * touchTransform.d)))
        let scale: CGFloat = max(scaleX, scaleY)
        view.layer.shadowRadius = 4 / scale
        
    }
    
    override func updateBtnOppositTransform() {
        touchViewButtonOppositTransform(oppositView: deleteBtn)
        touchViewButtonOppositTransform(oppositView: rotateBtn)
        touchViewBorderOppositTransform(view: borderBgView)
    }

    override func setHilight(_ flag: Bool) {
        super.setHilight(flag)
        
        deleteBtn.isHidden = !flag
        rotateBtn.isHidden = !flag
        borderBgView.isHidden = !flag
        
    }
    
    var deleteActionBlock: ((_ touchView: TouchStuffView)->Void)?
    var rotateActionBlock: ((_ touchView: TouchStuffView)->Void)?
        
        
}


extension TMTextTouchView {
    func setupView() {
        backgroundColor = UIColor.clear
        
    }
    
    
    func setupContentTextLabelWithAttributeString(contentString: NSAttributedString) {
        
        canvasContentView = UIView.init()
        canvasContentView.backgroundColor = UIColor.clear
        addSubview(canvasContentView)
        insertSubview(canvasContentView, at: 0)
        canvasContentView.isUserInteractionEnabled = false
        
        contentLabel = UILabel.init()
        contentLabel.numberOfLines = 0
        canvasContentView.addSubview(contentLabel)
        
        textBgView = UIView.init()
        textBgView.isUserInteractionEnabled = false
        textBgView.backgroundColor = UIColor.clear
        canvasContentView.addSubview(textBgView)
        canvasContentView.insertSubview(textBgView, belowSubview: contentLabel)
        
        updateContentLabelWithAttributeString(attributeString: contentString)
    }
    
    func updateContentLabelWithAttributeString(attributeString: NSAttributedString) {
        contentAttributeString = attributeString
        let size = contentAttributeString.boundingRect(with: CGSize.init(width: contentCanvasBounds.size.width*5/6, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
        contentLabel.bounds = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        contentLabel.attributedText = contentAttributeString
        
        let viewBounds = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        
        self.bounds = viewBounds.applying(CGAffineTransform.init(scaleX: 1.2, y: 1.3))
        
        canvasContentView.bounds = viewBounds.applying(CGAffineTransform.init(scaleX: 1.2, y: 1.3))
        canvasContentView.center = CGPoint.init(x: bounds.width / 2, y: bounds.height / 2)
        
        contentLabel.center = CGPoint.init(x: canvasContentView.bounds.width / 2, y: canvasContentView.bounds.height / 2)
        
        //bg view
        textBgView.bounds = contentLabel.bounds.applying(CGAffineTransform.init(scaleX: 1.1, y: 1.1))
        textBgView.center = CGPoint.init(x: canvasContentView.bounds.width / 2, y: canvasContentView.bounds.height / 2)
        
        
    }
    
    func replaceSetupBgViewColor(bgColorName: String) {
        textBgView.backgroundColor = UIColor.init(hex: bgColorName)
    }
    
    func replaceSetupBgViewBorderColor(bgBorderColorName: String) {

        textBgView.layer.borderColor = UIColor.init(hex: bgBorderColorName)?.cgColor
        textBgView.layer.borderWidth = 2
    }
    
    func replaceSetupBgViewCornerRadius(cornerRadius: Float) {
        textBgCornerRadius = cornerRadius
        let redius: CGFloat = CGFloat(cornerRadius) * (textBgView.height() / 2.0)
        textBgView.layer.cornerRadius = redius
    }
    
    func replaceCanvasContentAlpha(alpha: Float) {
        canvasContentView.alpha = CGFloat(alpha)
    }
    
}

extension TMTextTouchView {
    func setupActionBtns() {
        deleteBtn = UIButton.init(type: UIButton.ButtonType.custom)
        deleteBtn.setImage(UIImage(named: "edit_ic_delete"), for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteBtnClick(_:)) , for: UIControl.Event.touchUpInside)
        addSubview(deleteBtn)
        
        rotateBtn = UIImageView.init(image: UIImage.init(named: "edit_ic_rotate"))
        rotateBtn.contentMode = .center
        rotateBtn.isUserInteractionEnabled = true
        addSubview(rotateBtn)
        let panRotateGesture: UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(rotateButtonPanGestureDetected(_:)))
        rotateBtn.addGestureRecognizer(panRotateGesture)
    }

    @objc
    func deleteBtnClick(_ btn: UIButton) {
        deleteActionBlock?(self)
    }

    func setupBorderViewWithSize(viewSize: CGSize, lineColor:UIColor) {
        
        borderBgView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: viewSize.width, height: viewSize.width))
        borderBgView.layer.allowsEdgeAntialiasing = true
        borderBgView.isUserInteractionEnabled = false
        
        
        let dottedLineBorder: CAShapeLayer = CAShapeLayer.init()
        dottedLineBorder.frame = CGRect.init(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        dottedLineBorder.allowsEdgeAntialiasing = true
        borderBgView.layer.addSublayer(dottedLineBorder)
        dottedLineBorder.lineCap = .square
        dottedLineBorder.strokeColor = lineColor.cgColor
        dottedLineBorder.fillColor = UIColor.clear.cgColor
        dottedLineBorder.path = UIBezierPath.init(rect: CGRect.init(x: 0, y: 0, width: viewSize.width, height: viewSize.height)).cgPath
        dottedLineBorder.lineDashPattern = [5,5]
        borderBgView.layer.addSublayer(dottedLineBorder)
        
        insertSubview(borderBgView, at: 0)
        
    }


}
