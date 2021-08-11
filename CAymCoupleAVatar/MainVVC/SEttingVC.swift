//
//  SEttingVC.swift
//  PGymPicGridIns
//
//  Created by JOJO on 2021/8/3.
//

import UIKit
import MessageUI
import StoreKit
import Defaults
import NoticeObserveKit





class PGISettingVC: UIViewController {

    let closeBtn = UIButton(type: .custom)
    let privacyBtn = UIButton(type: .custom)
    let termsBtn = UIButton(type: .custom)
    let feedbackBtn = UIButton(type: .custom)
    let loginBtn = UIButton(type: .custom)
    let loginBtnLine = UIView()
    let logoutBtn = UIButton(type: .custom)
    
    let userNameLabel = UILabel()
    
    private var pool = Notice.ObserverPool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
        updateUserAccountStatus()
        
        NotificationCenter.default.nok.observe(name: .pi_noti_loginVcClose) {[weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.updateUserAccountStatus()
            }
        }
        .invalidated(by: pool)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        updateUserAccountStatus()
    }
    
    func setupView() {
        
        //
        let bgImgV = UIImageView()
        bgImgV
            .image("setting_background")
            .contentMode(.scaleAspectFill)
            .adhere(toSuperview: self.view)
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        //
//        let backBtn = UIButton(type: .custom)
//        view.addSubview(backBtn)
//        backBtn.setImage(UIImage(named: "ic_back"), for: .normal)
//        backBtn.snp.makeConstraints {
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
//            $0.left.equalTo(10)
//            $0.width.height.equalTo(44)
//        }
//        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        
        let titleLabel = UILabel(text: "Setting")
        titleLabel
            .fontName(32, "Quicksand-SemiBold")
            .textAlignment(.center)
            .adhere(toSuperview: view)
            .color(UIColor.black)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(25)
            $0.left.equalTo(24)
            $0.height.greaterThanOrEqualTo(30)
            $0.width.lessThanOrEqualTo(110)
        }
        
        // login
        
        loginBtn
            .title("Login")
            .titleColor(.black)
            .font(20, "Quicksand-SemiBold")
            .backgroundColor(.white)
        loginBtn.layer.cornerRadius = 30
        loginBtn.layer.masksToBounds = true
        
        view.addSubview(loginBtn)
        
        loginBtn.addTarget(self, action: #selector(loginBtnClick(sender:)), for: .touchUpInside)
        //
        // user name label
        userNameLabel
            .fontName(20, "Quicksand-SemiBold")
            .text("Sign in with Apple succeeded")
            .textAlignment(.right)
            .numberOfLines(2)
            .adhere(toSuperview: view)
            .color(UIColor.black)
        userNameLabel.snp.makeConstraints {
            $0.right.equalTo(-22)
            $0.left.equalTo(titleLabel.snp.right).offset(10)
            $0.height.greaterThanOrEqualTo(1)
            $0.centerY.equalTo(titleLabel)
        }
        
        let contentToolBgView = UIView()
        contentToolBgView
            .backgroundColor(.white)
            .adhere(toSuperview: self.view)
        contentToolBgView.layer.cornerRadius = 16
        contentToolBgView.layer.masksToBounds = true
        contentToolBgView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.equalTo(24)
            $0.height.equalTo(325)
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
        }

        loginBtn.snp.makeConstraints {
            $0.width.equalTo(328)
            $0.height.equalTo(60)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(contentToolBgView.snp.bottom).offset(24)
        }
        //
        view.addSubview(privacyBtn)
        privacyBtn.snp.makeConstraints {
            $0.width.equalTo(220)
            $0.height.equalTo(80)
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(contentToolBgView)
        }
        privacyBtn.addTarget(self, action: #selector(privacyBtnClick(sender:)), for: .touchUpInside)
        //
        let privaLine1 = UIView()
        privaLine1
            .backgroundColor(UIColor(hexString: "#D8D8D8")!.withAlphaComponent(0.5))
            .adhere(toSuperview: view)
        privaLine1.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(privacyBtn.snp.top)
            $0.width.equalTo(247)
            $0.height.equalTo(1)
        }
        let privaLine2 = UIView()
        privaLine2
            .backgroundColor(UIColor(hexString: "#D8D8D8")!.withAlphaComponent(0.5))
            .adhere(toSuperview: view)
        privaLine2.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(privacyBtn.snp.bottom)
            $0.width.equalTo(247)
            $0.height.equalTo(1)
        }
        //
        let priIconImgV = UIImageView()
        priIconImgV
            .image("setting_ic_privacy")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: view)
        priIconImgV.snp.makeConstraints {
            $0.left.equalTo(privacyBtn).offset(20)
            $0.centerY.equalTo(privacyBtn)
            $0.width.height.equalTo(22)
        }
        let priLabel = UILabel()
            .color(UIColor(hexString: "#000000")!)
            .text("Privacy Policy")
            .fontName(20, "Quicksand-SemiBold")
            .adhere(toSuperview: view)
        priLabel.snp.makeConstraints {
            $0.left.equalTo(priIconImgV.snp.right).offset(12)
            $0.centerY.equalTo(privacyBtn)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        view.addSubview(feedbackBtn)
        feedbackBtn.snp.makeConstraints {
            $0.width.equalTo(220)
            $0.height.equalTo(80)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(privacyBtn.snp.top).offset(-1)
        }
        feedbackBtn.addTarget(self, action: #selector(feedbackBtnClick(sender:)), for: .touchUpInside)
        
        //
        let feedIconImgV = UIImageView()
        feedIconImgV
            .image("setting_ic_feedback")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: view)
        feedIconImgV.snp.makeConstraints {
            $0.left.equalTo(feedbackBtn).offset(20)
            $0.centerY.equalTo(feedbackBtn)
            $0.width.height.equalTo(22)
        }
        let feedLabel = UILabel()
            .color(UIColor(hexString: "#000000")!)
            .text("Feeback")
            .fontName(20, "Quicksand-SemiBold")
            .adhere(toSuperview: view)
        feedLabel.snp.makeConstraints {
            $0.left.equalTo(feedIconImgV.snp.right).offset(12)
            $0.centerY.equalTo(feedbackBtn)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
         
        
        view.addSubview(termsBtn)
        termsBtn.snp.makeConstraints {
            $0.width.equalTo(220)
            $0.height.equalTo(80)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(privacyBtn.snp.bottom).offset(1)
        }
        termsBtn.addTarget(self, action: #selector(termsBtnClick(sender:)), for: .touchUpInside)
        
        let termsIconImgV = UIImageView()
        termsIconImgV
            .image("setting_ic_use")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: view)
        termsIconImgV.snp.makeConstraints {
            $0.left.equalTo(termsBtn).offset(20)
            $0.centerY.equalTo(termsBtn)
            $0.width.height.equalTo(22)
        }
        let termsLabel = UILabel()
            .color(UIColor(hexString: "#000000")!)
            .text("Terms of use")
            .fontName(20, "Quicksand-SemiBold")
            .adhere(toSuperview: view)
        termsLabel.snp.makeConstraints {
            $0.left.equalTo(termsIconImgV.snp.right).offset(12)
            $0.centerY.equalTo(termsBtn)
            $0.width.height.greaterThanOrEqualTo(1)
        }
         
        
        
        //
        logoutBtn
            .title("Logout")
            .titleColor(.black)
            .font(20, "Quicksand-SemiBold")
            .backgroundColor(.white)
        logoutBtn.layer.cornerRadius = 30
        logoutBtn.layer.masksToBounds = true
        
        view.addSubview(logoutBtn)
        logoutBtn.snp.makeConstraints {
            $0.left.right.bottom.top.equalTo(loginBtn)
        }
        logoutBtn.addTarget(self, action: #selector(logoutBtnClick(sender:)), for: .touchUpInside)
        //
        
        
        
        
    }
     

}



extension PGISettingVC {
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController()
        }
    }
}

extension PGISettingVC {
    @objc func privacyBtnClick(sender: UIButton) {
        UIApplication.shared.openURL(url: PrivacyPolicyURLStr)
    }
    
    @objc func termsBtnClick(sender: UIButton) {
        UIApplication.shared.openURL(url: TermsofuseURLStr)
    }
    
    @objc func feedbackBtnClick(sender: UIButton) {
        feedback()
    }
    
    @objc func loginBtnClick(sender: UIButton) {
        self.showLoginVC()
        
    }
    
    @objc func logoutBtnClick(sender: UIButton) {
        LoginMNG.shared.logout()
        updateUserAccountStatus()
    }
    
    func showLoginVC() {
        if LoginMNG.currentLoginUser() == nil {
            let loginVC = LoginMNG.shared.obtainVC()
            loginVC.modalTransitionStyle = .crossDissolve
            loginVC.modalPresentationStyle = .fullScreen
            
            self.present(loginVC, animated: true) {
            }
        }
    }
    func updateUserAccountStatus() {
        if let userModel = LoginMNG.currentLoginUser() {
            let userName  = userModel.userName
            userNameLabel.text = (userName?.count ?? 0) > 0 ? userName : "Sign in with Apple succeeded"
            userNameLabel.isHidden = false
            logoutBtn.isHidden = false

            loginBtn.isHidden = true
            loginBtnLine.isHidden = true
        } else {
            userNameLabel.text = ""
            userNameLabel.isHidden = true
            logoutBtn.isHidden = true

            loginBtn.isHidden = false
            loginBtnLine.isHidden = false
        }
    }
}



extension PGISettingVC: MFMailComposeViewControllerDelegate {
   func feedback() {
       //首先要判断设备具不具备发送邮件功能
       if MFMailComposeViewController.canSendMail(){
           //获取系统版本号
           let systemVersion = UIDevice.current.systemVersion
           let modelName = UIDevice.current.modelName
           
           let infoDic = Bundle.main.infoDictionary
           // 获取App的版本号
           let appVersion = infoDic?["CFBundleShortVersionString"] ?? "8.8.8"
           // 获取App的名称
           let appName = "\(AppName)"

           
           let controller = MFMailComposeViewController()
           //设置代理
           controller.mailComposeDelegate = self
           //设置主题
           controller.setSubject("\(appName) Feedback")
           //设置收件人
           // FIXME: feed back email
           controller.setToRecipients([feedbackEmail])
           //设置邮件正文内容（支持html）
        controller.setMessageBody("\n\n\nSystem Version：\(systemVersion)\n Device Name：\(modelName)\n App Name：\(appName)\n App Version：\(appVersion )", isHTML: false)
           
           //打开界面
        self.present(controller, animated: true, completion: nil)
       }else{
           HUD.error("The device doesn't support email")
       }
   }
   
   //发送邮件代理方法
   func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
       controller.dismiss(animated: true, completion: nil)
   }
}





