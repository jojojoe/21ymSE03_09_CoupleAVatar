//
//  CAVymMainC.swift
//  CAymCoupleAVatar
//
//  Created by JOJO on 2021/8/6.
//

import UIKit
import SwifterSwift
import SnapKit
import Photos
import DeviceKit
import RxSwift
import Photos
import YPImagePicker


class CAVymMainC: UIViewController {
    let homeBtn = UIButton(type: .custom)
    let settingBtn = UIButton(type: .custom)
    let storeBtn = UIButton(type: .custom)
    
    let topContentView = UIView()
    let homeVC = CAVymHomeVC()
    let setingVC = PGISettingVC()
    let storeVC = SLymStorereVC()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupView()
        setupContentView()
        
        homeBtnClick(sender: homeBtn)
        
        showLoginVC()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            AFlyerLibManage.event_LaunchApp()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSettingAccountStatus()
    }
    
    func updateSettingAccountStatus() {
        self.setingVC.updateUserAccountStatus()
    }
     
    func setupContentView() {
        
        self.addChild(homeVC)
        topContentView.addSubview(homeVC.view)
        homeVC.view.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        homeVC.avatarBtnClickblock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(CayTypePreviewVC(editType: .avatar))
            }
        }
        homeVC.postsBtnClickblock = {
            [weak self] in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(CayTypePreviewVC(editType: .posts))
            }
        }
        //
        
        self.addChild(setingVC)
        topContentView.addSubview(setingVC.view)
        setingVC.view.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        //
        self.addChild(storeVC)
        topContentView.addSubview(storeVC.view)
        storeVC.view.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        
    }

}

extension CAVymMainC {
    
    
   func showLoginVC() {
       if LoginMNG.currentLoginUser() == nil {
           let loginVC = LoginMNG.shared.obtainVC()
           loginVC.modalTransitionStyle = .crossDissolve
           loginVC.modalPresentationStyle = .fullScreen
           
           self.present(loginVC, animated: true) {
           }
       }
   }
    
    func setupView() {
        
        topContentView
            .backgroundColor(.white)
            .adhere(toSuperview: view)
        topContentView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-100)
            $0.top.left.right.equalToSuperview()
        }
        //
        let bottomToolBgView = UIView()
        bottomToolBgView
            .backgroundColor(.white)
            .adhere(toSuperview: view)
        bottomToolBgView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(topContentView.snp.bottom)
        }
        //
        
        homeBtn
            .image(UIImage(named: "home_unselect"), .normal)
            .image(UIImage(named: "home_select"), .selected)
            .adhere(toSuperview: bottomToolBgView)
        homeBtn.snp.makeConstraints {
            $0.top.equalTo(17)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(76)
        }
        homeBtn.addTarget(self, action: #selector(homeBtnClick(sender:)), for: .touchUpInside)
        
        //

        settingBtn
            .image(UIImage(named: "setting_unselect"), .normal)
            .image(UIImage(named: "setting_select"), .selected)
            .adhere(toSuperview: bottomToolBgView)
        settingBtn.snp.makeConstraints {
            $0.top.equalTo(17)
            $0.right.equalTo(homeBtn.snp.left).offset(-25)
            $0.width.height.equalTo(76)
        }
        settingBtn.addTarget(self, action: #selector(settingBtnClick(sender:)), for: .touchUpInside)
        //
        
        storeBtn
            .image(UIImage(named: "store_unselect"), .normal)
            .image(UIImage(named: "store_select"), .selected)
            .adhere(toSuperview: bottomToolBgView)
        storeBtn.snp.makeConstraints {
            $0.top.equalTo(17)
            $0.left.equalTo(homeBtn.snp.right).offset(25)
            $0.width.height.equalTo(76)
        }
        storeBtn.addTarget(self, action: #selector(storeBtnClick(sender:)), for: .touchUpInside)
        //
        
    }
    
    
}

extension CAVymMainC {
    @objc func settingBtnClick(sender: UIButton) {
        setingVC.view.isHidden = false
        homeVC.view.isHidden = true
        storeVC.view.isHidden = true
        
        settingBtn.isSelected = true
        homeBtn.isSelected = false
        storeBtn.isSelected = false
    }
    
    @objc func storeBtnClick(sender: UIButton) {
        storeVC.view.isHidden = false
        setingVC.view.isHidden = true
        homeVC.view.isHidden = true
        
        storeBtn.isSelected = true
        homeBtn.isSelected = false
        settingBtn.isSelected = false

    }
    
    @objc func homeBtnClick(sender: UIButton) {
        homeVC.view.isHidden = false
        setingVC.view.isHidden = true
        storeVC.view.isHidden = true
        
        homeBtn.isSelected = true
        storeBtn.isSelected = false
        settingBtn.isSelected = false
    }
    
    
}
