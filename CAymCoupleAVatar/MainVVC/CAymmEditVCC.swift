//
//  CAymmEditVCC.swift
//  CAymCoupleAVatar
//
//  Created by JOJO on 2021/8/6.
//

import UIKit
import Photos
import YPImagePicker

 

class CAymmEditVCC: UIViewController {
    var editType: EditType
    var typeItem: OverlyerTypeItem
    var originalImg: UIImage
    let saveBtn = UIButton(type: .custom)
    let backBtn = UIButton(type: .custom)
    var bottomToolBgView = UIView()
    var bottomBtnBgView = UIView()
    var canvasBgView = UIView()
    var canvasView = UIView()
    var canvasBgImgView = UIImageView()
    var canvasOverlayerImgView = UIImageView()
    
    var filterToolBar: CAymFilterBar!
    var avatarBar: CAymAvatarPostsBar!
    var stickerBar: GCStickerView!
    var fontBar: SWTextToolView!

    var bottomToolViews: [UIView] = []
    
    var toolBtns: [CAymEditToolBtn] = []
    
    let filterBtn = CAymEditToolBtn(frame: .zero, titleName: "Filter")
    let avatarBtn = CAymEditToolBtn(frame: .zero, titleName: "Frame")
    let stickerBtn = CAymEditToolBtn(frame: .zero, titleName: "Sticker")
    
    let postsBtn = CAymEditToolBtn(frame: .zero, titleName: "Theme")
    let fontBtn = CAymEditToolBtn(frame: .zero, titleName: "Font")
    
    let coinAlertView = LMyCoinUnlockView()
    var currentUnlockItemStr: String?
    var isUnlockOverlayer: Bool = false
    var currentUnlockPostItem: OverlyerTypeItem?
    var currentUnlockStickerItem: GCStickerItem?
    
    
    
    
    init(editType: EditType, typeItem: OverlyerTypeItem, originalImg: UIImage) {
        self.editType = editType
        self.typeItem = typeItem
        self.originalImg = originalImg
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupView()
        setupToolBtns()
        setupBottomToolBgView()
        setupCanvasBgView()
        setupUnlockAlertView()
        setupActionBlock()
        selectToolBtn(btn: filterBtn)
        self.avatarBar.currentItem = typeItem
        
        HUD.hide()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateContentCanvasViewLayout()
        
    }
    
}

extension CAymmEditVCC {
    
    func setupActionBlock() {
         
        TMTouchAddonManager.default.doubleTapTextAddonActionBlock = { [weak self] contentString, font in
            guard let `self` = self else {return}
            self.showTextInputViewStatus(contentString: contentString, font: font)
            
        }
        
        TMTouchAddonManager.default.textAddonReplaceBarStatusBlock = { [weak self] textAddon in
            guard let `self` = self else {return}
            
            self.fontBar.replaceSetupBarStatusWith(colorHex: textAddon.textColorName, fontName: textAddon.contentLabel.font.fontName)
            
        }
        
        
        TMTouchAddonManager.default.removeStickerAddonActionBlock = { [weak self] in
            guard let `self` = self else {return}
//            self.checkTopProAlertStatus()
            
        }
        
    }
    
    func setupUnlockAlertView() {
        
        coinAlertView.alpha = 0
        view.addSubview(coinAlertView)
        coinAlertView.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        
    }
    
    func showUnlockCoinAlertView() {
        // show coin alert
        UIView.animate(withDuration: 0.35) {
            self.coinAlertView.alpha = 1
        }
        
        coinAlertView.okBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            
            if LMymBCartCoinManager.default.coinCount >= LMymBCartCoinManager.default.coinCostCount {
                DispatchQueue.main.async {
                    if let unlockStr = self.currentUnlockItemStr {
                        LMymBCartCoinManager.default.costCoin(coin: LMymBCartCoinManager.default.coinCostCount)
                        LMymContentUnlockManager.default.unlock(itemId: unlockStr) {
                            DispatchQueue.main.async {
                                [weak self] in
                                guard let `self` = self else {return}
                                
                                self.avatarBar.collection.reloadData()
                                if self.editType == .avatar {
                                    self.stickerBar.collection.reloadData()
                                }
                                
                                if self.isUnlockOverlayer == true {
                                    if let overlyerItem = self.currentUnlockPostItem {
                                        self.canvasOverlayerImgView
                                            .image(overlyerItem.bigImg)
                                    }
                                } else {
                                    if let item = self.currentUnlockStickerItem, let stickerImage = UIImage(named: item.contentImageName) {
                                        
                                        TMTouchAddonManager.default.addNewStickerAddonWithStickerImage(stickerImage: stickerImage, stickerItem: item, atView: self.canvasView)
                                    }
                                    
                                        
                                }
                                
                            }
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "", message: "Insufficient coins, please buy coins first.", buttonTitles: ["OK"], highlightedButtonIndex: 0) { i in
                        DispatchQueue.main.async {
                            [weak self] in
                            guard let `self` = self else {return}
                            let storeVC = SLymStorereVC()
                            self.presentFullScreen(storeVC)
                            storeVC.updateStoreStatus(isPush: true)
                            
                        }
                    }
                }
            }

            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            } completion: { finished in
                if finished {
                    self.currentUnlockItemStr = nil
                }
            }
        }
        
        
        coinAlertView.backBtnClickBlock = {
            [weak self] in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) {
                self.coinAlertView.alpha = 0
            } completion: { finished in
                if finished {
                    self.currentUnlockItemStr = nil
                }
            }
        }
        
    }
}

extension CAymmEditVCC {
    func showTextInputViewStatus(contentString: String, font: UIFont) {
        let textinputVC = SBTextInputVC()
        self.addChild(textinputVC)
        view.addSubview(textinputVC.view)
        textinputVC.view.alpha = 0
        textinputVC.startEdit()
        UIView.animate(withDuration: 0.25) {
            [weak self] in
            guard let `self` = self else {return}
            textinputVC.view.alpha = 1
        }
        textinputVC.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        textinputVC.contentTextView.becomeFirstResponder()
        textinputVC.cancelClickActionBlock = {
            
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let `self` = self else {return}
                textinputVC.view.alpha = 0
            } completion: {[weak self] (finished) in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    textinputVC.removeViewAndControllerFromParentViewController()
                }
            }

            
            
            textinputVC.contentTextView.resignFirstResponder()
        }
        textinputVC.doneClickActionBlock = {
            [weak self] contentString, isAddNew in
            guard let `self` = self else {return}
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let `self` = self else {return}
                textinputVC.view.alpha = 0
            } completion: {[weak self] (finished) in
                guard let `self` = self else {return}
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    textinputVC.removeViewAndControllerFromParentViewController()
                }
            }
            textinputVC.contentTextView.resignFirstResponder()
            var cotnentStr = contentString
            
            if contentString == "" {
                cotnentStr = "Double tap to text"
            }
            
            TMTouchAddonManager.default.replaceSetupTextContentString(contentString: cotnentStr, canvasView: self.canvasView)
            
        }
    }
}

extension CAymmEditVCC {
    func setupView() {
        //
        
        
        saveBtn
            .image(UIImage(named: "edit_save"))
            .adhere(toSuperview: view)
        saveBtn.snp.makeConstraints {
            $0.width.height.equalTo(152/2)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-5)
        }
        saveBtn.addTarget(self, action: #selector(saveBtnClick(sender:)), for: .touchUpInside)

        //

        backBtn
            .image(UIImage(named: "edit_ic_back"))
            .adhere(toSuperview: view)
        backBtn.snp.makeConstraints {
            $0.width.height.equalTo(44)
            $0.left.equalTo(15)
            $0.centerY.equalTo(saveBtn)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)

    }
    
    @objc func backBtnClick(sender: UIButton) {
        TMTouchAddonManager.default.clearAddonManagerDefaultStatus()
        
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func saveBtnClick(sender: UIButton) {
        TMTouchAddonManager.default.cancelCurrentAddonHilightStatus()
        if let img = canvasView.screenshot {
            saveToAlbumPhotoAction(images: [img])
        }
    }
    
    @objc func filterBtnClick(sender: CAymEditToolBtn) {
        TMTouchAddonManager.default.cancelCurrentAddonHilightStatus()
        selectToolBtn(btn: sender)
        
    }
    @objc func avatarBtnClick(sender: CAymEditToolBtn) {
        TMTouchAddonManager.default.cancelCurrentAddonHilightStatus()
        selectToolBtn(btn: sender)
    }
    @objc func stickerBtnClick(sender: CAymEditToolBtn) {
        TMTouchAddonManager.default.cancelCurrentAddonHilightStatus()
        selectToolBtn(btn: sender)
    }
    @objc func postsBtnClick(sender: CAymEditToolBtn) {
        TMTouchAddonManager.default.cancelCurrentAddonHilightStatus()
        selectToolBtn(btn: sender)
    }
    @objc func fontBtnClick(sender: CAymEditToolBtn) {
        selectToolBtn(btn: sender)
    }
    
    func setupToolBtns() {
        bottomBtnBgView
            .backgroundColor(.white)
            .adhere(toSuperview: self.view)
        bottomBtnBgView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-230)
            $0.height.equalTo(44)
        }
        
        if editType == .avatar {
            avatarBtn
                .adhere(toSuperview: bottomBtnBgView)
            avatarBtn.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.equalTo(75)
                $0.height.equalTo(44)
            }
            avatarBtn.addTarget(self, action: #selector(avatarBtnClick(sender:)), for: .touchUpInside)
            //
            filterBtn
                .adhere(toSuperview: bottomBtnBgView)
            filterBtn.snp.makeConstraints {
                $0.right.equalTo(avatarBtn.snp.left).offset(-20)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(75)
                $0.height.equalTo(44)
            }
            filterBtn.addTarget(self, action: #selector(filterBtnClick(sender:)), for: .touchUpInside)
            
            //
            stickerBtn
                .adhere(toSuperview: bottomBtnBgView)
            stickerBtn.snp.makeConstraints {
                $0.left.equalTo(avatarBtn.snp.right).offset(20)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(75)
                $0.height.equalTo(44)
            }
            stickerBtn.addTarget(self, action: #selector(stickerBtnClick(sender:)), for: .touchUpInside)
            toolBtns = [filterBtn, avatarBtn, stickerBtn]
            selectToolBtn(btn: avatarBtn)
        } else {
            
            postsBtn
                .adhere(toSuperview: bottomBtnBgView)
            postsBtn.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.equalTo(75)
                $0.height.equalTo(44)
            }
            //
            filterBtn
                .adhere(toSuperview: bottomBtnBgView)
            filterBtn.snp.makeConstraints {
                $0.right.equalTo(postsBtn.snp.left).offset(-20)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(75)
                $0.height.equalTo(44)
            }
            //
            fontBtn
                .adhere(toSuperview: bottomBtnBgView)
            fontBtn.snp.makeConstraints {
                $0.left.equalTo(postsBtn.snp.right).offset(20)
                $0.centerY.equalToSuperview()
                $0.width.equalTo(75)
                $0.height.equalTo(44)
            }
            
            filterBtn.addTarget(self, action: #selector(filterBtnClick(sender:)), for: .touchUpInside)

            postsBtn.addTarget(self, action: #selector(postsBtnClick(sender:)), for: .touchUpInside)
            
            fontBtn.addTarget(self, action: #selector(fontBtnClick(sender:)), for: .touchUpInside)
            
            
            toolBtns = [filterBtn, postsBtn, fontBtn]
            selectToolBtn(btn: postsBtn)
        }
    }
    
    func selectToolBtn(btn: CAymEditToolBtn) {
        for theBtn in toolBtns {
            if theBtn == btn {
                theBtn.updateSelectStatus(isSelectStatus: true)
            } else {
                theBtn.updateSelectStatus(isSelectStatus: false)
            }
        }
        for toolView in bottomToolViews {
            toolView.isHidden = true
            if btn == filterBtn {
                filterToolBar.isHidden = false
            } else if btn == avatarBtn {
                avatarBar.isHidden = false
            } else if btn == stickerBtn {
                stickerBar.isHidden = false
            } else if btn == fontBtn {
                fontBar.isHidden = false
            } else if btn == postsBtn {
                avatarBar.isHidden = false
            }
            
        }
         
    }
 
    func setupBottomToolBgView() {
        bottomToolBgView
            .backgroundColor(.white)
            .adhere(toSuperview: self.view)
        bottomToolBgView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(saveBtn.snp.top).offset(-5)
            $0.top.equalTo(bottomBtnBgView.snp.bottom).offset(5)
        }
        if editType == .avatar {
            filterToolBar = CAymFilterBar(frame: .zero, filteredImg: self.originalImg.scaled(toWidth: 250)!, cellSize: CGSize(width: 80, height: 80))
            
            avatarBar = CAymAvatarPostsBar(frame: .zero, dataType: .avatar)
            //
            stickerBar = GCStickerView()
            stickerBar
                .adhere(toSuperview: bottomToolBgView)
            stickerBar.snp.makeConstraints {
                $0.left.right.top.bottom.equalToSuperview()
            }
            stickerBar.didSelectStickerItemBlock = {
                [weak self] item in
                guard let `self` = self else {return}
                guard let stickerImage = UIImage(named: item.contentImageName) else {return}
                
                if item.isPro == false || LMymContentUnlockManager.default.hasUnlock(itemId: item.thumbnail) {
                    TMTouchAddonManager.default.addNewStickerAddonWithStickerImage(stickerImage: stickerImage, stickerItem: item, atView: self.canvasView)
                } else {
                    self.isUnlockOverlayer = false
                    self.currentUnlockStickerItem = item
                    self.currentUnlockItemStr = item.thumbnail
                    self.showUnlockCoinAlertView()
                }
                
                
            }
            bottomToolViews = [filterToolBar, avatarBar, stickerBar]
        } else {
            filterToolBar = CAymFilterBar(frame: .zero, filteredImg: self.originalImg.scaled(toWidth: 250)!, cellSize: CGSize(width: 80, height: 120))
            avatarBar = CAymAvatarPostsBar(frame: .zero, dataType: .posts)
            //
            fontBar = SWTextToolView()
            fontBar
                .adhere(toSuperview: bottomToolBgView)
            fontBar.snp.makeConstraints {
                $0.left.right.top.bottom.equalToSuperview()
            }
            
            TMTouchAddonManager.default.isAllwaysAddNewTextView = true
            fontBar.didSelectFontBlock = {
                [weak self] fontName in
                guard let `self` = self else {return}
                TMTouchAddonManager.default.replaceSetupTextAddonFontItem(fontItem: fontName, fontIndexPath: IndexPath(item: 0, section: 0), canvasView: self.canvasView)
            }
            fontBar.didSelectColorBlock = {
                [weak self] colorHex in
                guard let `self` = self else {return}
                TMTouchAddonManager.default.replaceSetupTextAddonTextColorName(colorName: colorHex, colorIndexPath: IndexPath(item: 0, section: 0), canvasView: self.canvasView)
            }
            bottomToolViews = [filterToolBar, avatarBar, fontBar]
        }
        bottomToolBgView.addSubview(filterToolBar)
        filterToolBar.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        filterToolBar.didSelectFilterItemBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                if let filteredImg = DataManager.default.filterOriginalImage(image: self.originalImg, lookupImgNameStr: item.imageName) {
                    self.canvasBgImgView.image = filteredImg
                } else {
                    self.canvasBgImgView.image = self.originalImg
                }

            }
        }
        //
        bottomToolBgView.addSubview(avatarBar)
        avatarBar.snp.makeConstraints {
            $0.left.right.bottom.top.equalToSuperview()
        }
        avatarBar.selecTAvatarPostItemBlock = {
            [weak self] item in
            guard let `self` = self else {return}
            
            if item.isPro == false || LMymContentUnlockManager.default.hasUnlock(itemId: item.thumb ?? "") {
                self.canvasOverlayerImgView
                    .image(item.bigImg)
            } else {
                self.isUnlockOverlayer = true
                self.currentUnlockPostItem = item
                self.currentUnlockItemStr = item.thumb
                self.showUnlockCoinAlertView()
            }
        }
        //
        
    }
    func updateContentCanvasViewLayout() {
        if editType == .avatar {
            if canvasBgView.bounds.width > canvasBgView.bounds.height {
                canvasView.snp.remakeConstraints {
                    $0.center.equalToSuperview()
                    $0.width.height.equalTo(canvasBgView.bounds.height)
                }
            } else {
                canvasView.snp.remakeConstraints {
                    $0.center.equalToSuperview()
                    $0.width.height.equalTo(canvasBgView.bounds.width)
                }
            }
        } else {
            if canvasBgView.bounds.width > (canvasBgView.bounds.height * 6/9) {
                canvasView.snp.remakeConstraints {
                    $0.center.equalToSuperview()
                    $0.height.equalTo(canvasBgView.bounds.height)
                    $0.width.equalTo(canvasBgView.bounds.height * 6/9)
                }
            } else {
                canvasView.snp.remakeConstraints {
                    $0.center.equalToSuperview()
                    $0.width.equalTo(canvasBgView.bounds.width)
                    $0.height.equalTo(canvasBgView.bounds.width * 9/6)
                }
            }
        }
        canvasBgImgView.snp.remakeConstraints {
            $0.left.right.bottom.top.equalTo(canvasView)
        }
        canvasOverlayerImgView.snp.remakeConstraints {
            $0.left.right.bottom.top.equalTo(canvasView)
        }
        
    }
    
    func setupCanvasBgView() {
        //
        let topmaskView = UIView()
        topmaskView
            .backgroundColor(UIColor(hexString: "#FFEFF4")!)
            .adhere(toSuperview: view)
        topmaskView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        //
        canvasBgView
            .backgroundColor(UIColor(hexString: "#FFEFF4")!)
            .adhere(toSuperview: self.view)
        canvasBgView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(bottomBtnBgView.snp.top)
        }
        
        canvasView
            .backgroundColor(.white)
            .adhere(toSuperview: canvasBgView)
        canvasView.layer.masksToBounds = true
        canvasBgImgView
            .adhere(toSuperview: canvasView)
            .image(originalImg)
            .contentMode(.scaleAspectFill)
        canvasBgImgView.layer.masksToBounds = true
        canvasOverlayerImgView
            .adhere(toSuperview: canvasView)
            .contentMode(.scaleAspectFill)
        canvasOverlayerImgView.layer.masksToBounds = true
        canvasOverlayerImgView
            .image(typeItem.bigImg)

        
        
        
    }
    
}



class CAymEditToolBtn: UIButton {
    var titName: String
    
    var titleNameLabel = UILabel()
    var lineV = UIView()
    
    
    init(frame: CGRect, titleName: String) {
        titName = titleName
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSelectStatus(isSelectStatus: Bool) {
        if isSelectStatus {
            titleNameLabel
                .color(UIColor(hexString: "#FF3287")!)
            lineV.isHidden = false
        } else {
            titleNameLabel
                .color(UIColor.black.withAlphaComponent(0.23))
            lineV.isHidden = true
        }
    }
    
    func setupView() {
        titleNameLabel
            .color(UIColor(hexString: "#FF3287")!)
            .color(UIColor.black.withAlphaComponent(0.23))
            .text(titName)
            .fontName(18, "Quicksand-SemiBold")
            .textAlignment(.center)
            .adhere(toSuperview: self)
        titleNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.greaterThanOrEqualTo(1)
            $0.left.equalToSuperview()
        }
        //
        lineV
            .backgroundColor(UIColor(hexString: "#FF3287")!)
            .adhere(toSuperview: self)
        lineV.layer.cornerRadius = 1.5
        lineV.snp.makeConstraints {
            $0.top.equalTo(titleNameLabel.snp.bottom).offset(2)
            $0.centerX.equalToSuperview()
            $0.left.equalTo(titleNameLabel)
            $0.height.equalTo(3)
        }
        
        
    }
    
}





extension CAymmEditVCC {
    func saveToAlbumPhotoAction(images: [UIImage]) {
        DispatchQueue.main.async(execute: {
            PHPhotoLibrary.shared().performChanges({
                [weak self] in
                guard let `self` = self else {return}
                for img in images {
                    PHAssetChangeRequest.creationRequestForAsset(from: img)
                }
            }) { (finish, error) in
                if finish {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        self.showSaveSuccessAlert()
//                        if self.shouldCostCoin {
//                            LMymBCartCoinManager.default.costCoin(coin: LMymBCartCoinManager.default.coinCostCount)
//                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let `self` = self else {return}
                        if error != nil {
                            let auth = PHPhotoLibrary.authorizationStatus()
                            if auth != .authorized {
                                self.showDenideAlert()
                            }
                        }
                    }
                }
            }
        })
    }
    
    func showSaveSuccessAlert() {
//        HUD.success("Photo save successful.")
        //
        let saveSuccessView = LMySaveSuccesAlertView()
        saveSuccessView
            .adhere(toSuperview: self.view)
        saveSuccessView
            .snp.makeConstraints {
                $0.left.right.top.bottom.equalToSuperview()
            }
        saveSuccessView.backBtnClickBlock = {
            saveSuccessView.removeFromSuperview()
        }
        
        saveSuccessView.okBtnClickBlock = {
            saveSuccessView.removeFromSuperview()
        }
    }
    
    func showDenideAlert() {
        DispatchQueue.main.async {
            [weak self] in
            guard let `self` = self else {return}
            let alert = UIAlertController(title: "Oops", message: "You have declined access to photos, please active it in Settings>Privacy>Photos.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Ok", style: .default, handler: { (goSettingAction) in
                DispatchQueue.main.async {
                    let url = URL(string: UIApplication.openSettingsURLString)!
                    UIApplication.shared.open(url, options: [:])
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
        }
    }
    
}
