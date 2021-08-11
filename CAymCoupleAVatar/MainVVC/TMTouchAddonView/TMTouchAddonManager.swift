//
//  TMTouchAddonManager.swift
//  TMThumbnailMakerd
//
//  Created by JOJO on 2019/10/14.
//  Copyright © 2019 JOJO. All rights reserved.
//

import UIKit
import Alertift

class TMTouchAddonManager: NSObject {
    
    static var `default` = TMTouchAddonManager()
    
    // sticker
    var addonStickersList: [TMStickerTouchView] = []
    var currentStickerAddon: TMStickerTouchView? = nil
    let stickerWidth = 200
    
    // bg photo
    var currentBgImageView: TMBgImageTouchView? = nil
    
    // shape
    var addonShapesList: [TMStickerTouchView] = []
    var currentShapeAddon: TMStickerTouchView? = nil
    let shapeWidth =  200
    
    // text
    var addonTextsList: [TMTextTouchView] = []
    var currentTextAddon: TMTextTouchView? = nil
    let textFontSize =  30
    let textDefaultString: String = "DOUBLE TAP TO TEXT"
    
    var isAllwaysAddNewTextView: Bool = false
    
    
    var doubleTapTextAddonActionBlock:((_ contentString: String, _ textFont: UIFont)->Void)?
    var shapeAddonReplaceBarStatusBlock:((_ shapeAddon: TMStickerTouchView)->Void)?
    var textAddonReplaceBarStatusBlock:((_ textAddon: TMTextTouchView)->Void)?
    var removeStickerAddonActionBlock:(()->Void)?
    
    
    func clearAddonManagerDefaultStatus() {
        addonStickersList = []
        currentStickerAddon = nil
        
        addonShapesList = []
        currentShapeAddon = nil
        
        addonTextsList = []
        currentTextAddon = nil
        
    }
    
    func cancelCurrentAddonHilightStatus() {
        if let currentSticker = currentStickerAddon {
            currentSticker.setHilight(false)
        }
        
        if let curerntShape = currentShapeAddon {
            curerntShape.setHilight(false)
        }
        
        
        if let currentText = currentTextAddon {
            currentText.setHilight(false)
        }
        
    }
    
    func hasProStickerAddon() -> Bool {
        if addonStickersList.count == 0 {
            return false
        } else {
            for sticker: TMStickerTouchView in addonStickersList {
                if let hasPro = sticker.stikerItem?.isPro {
                    if hasPro {
                        return true
                    }
                }
            }
            return false
        }
    }
    
}

// sticker
extension TMTouchAddonManager {
    
    func addNewStickerAddonWithStickerImage(stickerImage: UIImage, stickerItem: GCStickerItem, atView stickerCanvasView:UIView) {
        
        cancelCurrentAddonHilightStatus()
        
        let stickerView: TMStickerTouchView = TMStickerTouchView.init(withImage:stickerImage , viewSize: CGSize.init(width: stickerWidth, height: stickerWidth))
        stickerView.center = CGPoint.init(x: stickerCanvasView.width() / 2, y: stickerCanvasView.height() / 2)
        addonStickersList.append(stickerView)
        currentStickerAddon = stickerView
        stickerCanvasView.addSubview(stickerView)
        stickerView.setHilight(true)
        stickerView.delegate = self
        stickerView.deleteActionBlock = { [weak self] contentTouchView in
            guard let `self` = self else { return }
            self.removeStickerTouchView(stickerTouchView: stickerView)
            
        }
        
        stickerView.stikerItem = stickerItem
        
    }
    
    
    func removeStickerTouchView(stickerTouchView: TMStickerTouchView) {
        stickerTouchView.removeFromSuperview()
        
        addonStickersList.removeAll(stickerTouchView)
        currentStickerAddon = nil
        
        removeStickerAddonActionBlock?()
    }
    
    
}

// bg photo
extension TMTouchAddonManager {
    func addBgPhotoAddonTouchImage(bgImage: UIImage, atView canvasView: UIView) {
        if let bgImageAddonView = currentBgImageView {
            // remove current bg photo addon
            
            removeBgPhotoTouchView(bgPhotoView: bgImageAddonView)
            
        }
        let whRatio: CGFloat = bgImage.size.width / bgImage.size.height
        var imageWidth: CGFloat = canvasView.width
        var imageHeight: CGFloat = canvasView.height
       
        let canvasWH = imageWidth / imageHeight
        
        
       if whRatio >= canvasWH {
        
           imageHeight = imageWidth / whRatio;
       } else {
            imageWidth = imageHeight * whRatio;
       }
       
       let contentImageViewSize: CGSize = CGSize.init(width: imageWidth, height: imageHeight)
        
        let bgPhotoView: TMBgImageTouchView = TMBgImageTouchView.init(withImage: bgImage, viewSize: contentImageViewSize)
        
        bgPhotoView.center = CGPoint.init(x: canvasView.width() / 2, y: canvasView.height() / 2)
        
        currentBgImageView = bgPhotoView
        
        canvasView.addSubview(bgPhotoView)
        canvasView.sendSubviewToBack(bgPhotoView)
        
    }
    
    func removeBgPhotoTouchView(bgPhotoView: TMBgImageTouchView) {
        bgPhotoView.removeFromSuperview()
        currentBgImageView = nil
    }
    
    
    
}

/*
// shape
extension TMTouchAddonManager {
    
    func selectedOrAddNewCurrentShapeAddon(canvasView: UIView) -> Bool {
        guard let shapeAddon = currentShapeAddon else {
            
            if let lastShapeAddon = addonShapesList.last {
                currentShapeAddon = lastShapeAddon
                lastShapeAddon.setHilight(true)
                return true
            }
            
            guard let shapeItem = HookMacaqueToolManager.shapeItemsList.first else { return false }
            guard let shapeImage = UIImage.init(named: shapeItem.bigImageName()) else { return false }
            
            addNewShapeAddonWithShapeImage(shapeImage: shapeImage, itemIndexPath: IndexPath.init(item: 0, section: 0) , atView: canvasView)
            return true
        }
        
        shapeAddon.setHilight(true)
        return false
    }
    
    func addNewShapeAddonWithShapeImage(shapeImage: UIImage, itemIndexPath: IndexPath, atView stickerCanvasView:UIView) {
        
        
        cancelCurrentAddonHilightStatus()
        
        let stickerView: TMStickerTouchView = TMStickerTouchView.init(withImage:shapeImage , viewSize: CGSize.init(width: stickerWidth, height: stickerWidth) , isTemplete: true)
        stickerView.center = CGPoint.init(x: stickerCanvasView.width() / 2, y: stickerCanvasView.height() / 2)
        addonShapesList.append(stickerView)
        currentShapeAddon = stickerView
        stickerCanvasView.addSubview(stickerView)
        
        stickerView.setHilight(true)
        stickerView.delegate = self
        
        stickerView.itemIndexPath = itemIndexPath
        stickerView.colorIndexPath = IndexPath.init(item: 0, section: 0)
        stickerView.shapeAlpha = 1
        
        stickerView.deleteActionBlock = { [weak self] contentTouchView in
            guard let `self` = self else { return }
            self.removeShapeTouchView(stickerTouchView: stickerView)
            
        }
        
        shapeAddonReplaceBarStatusBlock?(stickerView)
        
    }
    
    func replaceSetupCurrentShapeAlpha(alpha: Float, canvasView: UIView) {
        cancelCurrentAddonHilightStatus()
        let isAddonNew = selectedOrAddNewCurrentShapeAddon(canvasView: canvasView)
        guard let shapeAddon = currentShapeAddon else { return }
        
        shapeAddon.setHilight(true)
        shapeAddon.contentImageview.alpha = CGFloat(alpha)
        shapeAddon.shapeAlpha = alpha
        if isAddonNew {
            shapeAddonReplaceBarStatusBlock?(shapeAddon)
        }
         
    }
    
    
    func replaceSetupCurrentShapeColor(shapeColorName: String, colorIndexPath:IndexPath , canvasView: UIView) {
        cancelCurrentAddonHilightStatus()
        let isAddonNew = selectedOrAddNewCurrentShapeAddon(canvasView: canvasView)
        guard let shapeAddon = currentShapeAddon else { return }
        shapeAddon.setHilight(true)
        shapeAddon.templeteColorString = shapeColorName
        shapeAddon.colorIndexPath = colorIndexPath
        if isAddonNew {
            shapeAddonReplaceBarStatusBlock?(shapeAddon)
        }
         
    }
    
    func removeShapeTouchView(stickerTouchView: TMStickerTouchView) {
        stickerTouchView.removeFromSuperview()
        addonShapesList.removeAll(stickerTouchView)
        currentShapeAddon = nil
    }
    
    
}
*/

// text
extension TMTouchAddonManager {
    
    func selectedOrAddNewCurrentTextAddon(canvasView: UIView) -> Bool {
        guard let textAddon = currentTextAddon else {
            
            if let lastTextAddon = addonTextsList.last, isAllwaysAddNewTextView == false {
                currentTextAddon = lastTextAddon
                lastTextAddon.setHilight(true)
                return true
            }
            
            addNewTextAddonWithContentString(contentString: textDefaultString, atView: canvasView)
            
            
            return true
        }
        
        textAddon.setHilight(true)
            return false
    }
    
    func addNewTextAddonWithContentString(contentString: String, atView canvasView:UIView) {
        
        cancelCurrentAddonHilightStatus()
        
        var defaultFont = UIFont.systemFont(ofSize: CGFloat(textFontSize))
        let defaultColor: UIColor = UIColor.black
        
        if let fontItem = DataManager.default.textFontNames.first {
            defaultFont = UIFont(name: fontItem, size: CGFloat(textFontSize)) ?? UIFont.systemFont(ofSize: CGFloat(textFontSize)) //fontItem.thinMetadataUniqueFx(fontSize: CGFloat(textFontSize))
        }
        
        let style = NSMutableParagraphStyle.init()
        style.alignment = .center
        let attri = NSAttributedString.init(string: contentString, attributes: [NSAttributedString.Key.font : defaultFont, NSAttributedString.Key.foregroundColor : defaultColor, NSAttributedString.Key.paragraphStyle : style])
        
        let textView: TMTextTouchView = TMTextTouchView.init(withAttributeString: attri, canvasBounds: canvasView.bounds)
        textView.textFont = defaultFont
        textView.textAlpha = 1
        textView.textBgCornerRadius = 0
        textView.center = CGPoint.init(x: canvasView.width() / 2, y: canvasView.height() / 2)
        addonTextsList.append(textView)
        currentTextAddon = textView
        canvasView.addSubview(textView)
        
        textView.setHilight(true)
        textView.delegate = self
        textView.deleteActionBlock = { [weak self] contentTouchView in
            guard let `self` = self else { return }
            self.removeTextTouchView(textTouchView: contentTouchView as! TMTextTouchView)
            
        }
        
        textView.contentString = contentString
        
        textAddonReplaceBarStatusBlock?(textView)
        
    }
    
    func removeTextTouchView(textTouchView: TMTextTouchView) {
        textTouchView.removeFromSuperview()
        addonTextsList.removeAll(textTouchView)
        currentTextAddon = nil
    }
    
    func replaceSetupTextAddonFontItem(fontItem: String, fontIndexPath: IndexPath, canvasView: UIView) {
        
        let isAddonNew = selectedOrAddNewCurrentTextAddon(canvasView: canvasView)
        
        guard let textAddon = currentTextAddon else { return }
        
        let attri_M = NSMutableAttributedString.init(attributedString: textAddon.contentAttributeString)
        
        let textFont: UIFont = UIFont(name: fontItem, size: CGFloat(textFontSize)) ?? UIFont.systemFont(ofSize: CGFloat(textFontSize)) //fontItem.thinMetadataUniqueFx(fontSize: CGFloat(textFontSize))
            
        attri_M.addAttributes([NSAttributedString.Key.font : textFont], range: NSRange.init(location: 0, length: attri_M.length))
        
        textAddon.updateContentLabelWithAttributeString(attributeString: attri_M)
        textAddon.fontIndexPath = fontIndexPath
        textAddon.textFont = textFont
        
        
        if isAddonNew {
            textAddonReplaceBarStatusBlock?(textAddon)
        }
        
    }
    
    func replaceSetupTextAddonTextColorName(colorName: String, colorIndexPath: IndexPath, canvasView: UIView) {
//        guard let textAddon = currentTextAddon else {
//            guard let rootNav = UIApplication.shared.keyWindow?.rootViewController else { return }
//            Alertift
//                .alert(title: "", message: "Please add Text Addon first!")
//                .action(.cancel("Ok"))
//                .show(on: rootNav, completion: nil)
//            return
//        }
//
        let isAddonNew = selectedOrAddNewCurrentTextAddon(canvasView: canvasView)
        guard let textAddon = currentTextAddon else { return }
        
        let attri_M = NSMutableAttributedString.init(attributedString: textAddon.contentAttributeString)
        attri_M.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.init(hex: colorName) ?? UIColor.black], range: NSRange.init(location: 0, length: attri_M.length))
        textAddon.textColorName = colorName
        textAddon.updateContentLabelWithAttributeString(attributeString: attri_M)
        textAddon.textColorIndexPath = colorIndexPath
        
        if isAddonNew {
            textAddonReplaceBarStatusBlock?(textAddon)
        }
        
    }
    
    func replaceSetupTextAddonTextStrokeColorName(strokeColorName: String, canvasView: UIView) {
        
        let isAddonNew = selectedOrAddNewCurrentTextAddon(canvasView: canvasView)
        guard let textAddon = currentTextAddon else { return }
        
        let attri_M = NSMutableAttributedString.init(attributedString: textAddon.contentAttributeString)
        attri_M.addAttributes([NSAttributedString.Key.strokeWidth : -3 , NSAttributedString.Key.strokeColor : UIColor.init(hex: strokeColorName) ?? UIColor.clear], range: NSRange.init(location: 0, length: attri_M.length))
        textAddon.updateContentLabelWithAttributeString(attributeString: attri_M)
        textAddon.textStrokeColorName = strokeColorName
        
        if isAddonNew {
            textAddonReplaceBarStatusBlock?(textAddon)
        }
        
    }
    
    func replaceSEtupTextAddonTextAlpha(alpha: Float, canvasView: UIView) {
        let isAddonNew = selectedOrAddNewCurrentTextAddon(canvasView: canvasView)
        guard let textAddon = currentTextAddon else { return }
        textAddon.replaceCanvasContentAlpha(alpha: alpha)
        textAddon.textAlpha = alpha
        
        if isAddonNew {
            textAddonReplaceBarStatusBlock?(textAddon)
        }
    }
    
    func replaceSetupTextBgColor(bgColorName: String, indexPath: IndexPath, canvasView: UIView) {
        let isAddonNew = selectedOrAddNewCurrentTextAddon(canvasView: canvasView)
        guard let textAddon = currentTextAddon else { return }
        
        textAddon.replaceSetupBgViewColor(bgColorName: bgColorName)
        textAddon.textBgColorName = bgColorName
        textAddon.bgColorIndexPath = indexPath
        if isAddonNew {
            textAddonReplaceBarStatusBlock?(textAddon)
        }
    }
    
    func replaceSetupTextBgBorderColor(bgBorderColorName: String, canvasView: UIView) {
        let isAddonNew = selectedOrAddNewCurrentTextAddon(canvasView: canvasView)
        guard let textAddon = currentTextAddon else { return }
        
        textAddon.replaceSetupBgViewBorderColor(bgBorderColorName: bgBorderColorName)
        textAddon.textBgBorderColorName = bgBorderColorName
        if isAddonNew {
            textAddonReplaceBarStatusBlock?(textAddon)
        }
        
    }
    
    func replaceSetupTextBgCornerRadius(cornerRadius: Float, canvasView: UIView) {
        let isAddonNew = selectedOrAddNewCurrentTextAddon(canvasView: canvasView)
        guard let textAddon = currentTextAddon else { return }
        
        textAddon.replaceSetupBgViewCornerRadius(cornerRadius: cornerRadius)
        textAddon.textBgCornerRadius = cornerRadius
        
        if isAddonNew {
            textAddonReplaceBarStatusBlock?(textAddon)
        }
    }
    
    func replaceSetupTextContentString(contentString: String, canvasView: UIView) {
        let isAddonNew = selectedOrAddNewCurrentTextAddon(canvasView: canvasView)
        guard let textAddon = currentTextAddon else { return }
        
        textAddon.contentString = contentString
        
        let attri_M = NSMutableAttributedString.init(attributedString: textAddon.contentAttributeString)
        attri_M.replaceCharacters(in: NSRange.init(location: 0, length: attri_M.length), with: contentString)
        
        textAddon.updateContentLabelWithAttributeString(attributeString: attri_M)
        
        if isAddonNew {
            textAddonReplaceBarStatusBlock?(textAddon)
        }
    }
}




extension TMTouchAddonManager: TouchStuffViewDelegate {
    
    func viewDoubleClick(_ sender: TouchStuffView!) {
        cancelCurrentAddonHilightStatus()
        sender.setHilight(true)
        
        let className = type(of: sender).description()
        if className.contains("TMTextTouchView") {
            let textAddon: TMTextTouchView = sender as! TMTextTouchView
            currentTextAddon = textAddon
               
            doubleTapTextAddonActionBlock?(textAddon.contentString, textAddon.textFont)
        }
        
    }
    
    func viewSingleClick(_ sender: TouchStuffView!) {
        cancelCurrentAddonHilightStatus()
        sender.setHilight(true)
        let className = type(of: sender).description()
        
        if className.contains("TMStickerTouchView") {
            let stickerAddon: TMStickerTouchView = sender as! TMStickerTouchView
            if addonStickersList.contains(stickerAddon) {
                currentStickerAddon = stickerAddon
            } else if addonShapesList.contains(stickerAddon) {
                currentShapeAddon = stickerAddon
                shapeAddonReplaceBarStatusBlock?(stickerAddon)
            }
            stickerAddon.superview?.bringSubviewToFront(stickerAddon)
        } else if className.contains("TMTextTouchView") {
            let textAddon: TMTextTouchView = sender as! TMTextTouchView
            currentTextAddon = textAddon
            textAddonReplaceBarStatusBlock?(textAddon)
            textAddon.superview?.bringSubviewToFront(textAddon)
        } else if className.contains("TMBgImageTouchView") {
            cancelCurrentAddonHilightStatus()
        }
        
    }
    
    func viewTouchUp(_ sender: TouchStuffView!) {
        
    }
    
}

