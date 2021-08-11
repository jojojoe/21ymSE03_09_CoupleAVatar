//
//  CAVymHomeVC.swift
//  CAymCoupleAVatar
//
//  Created by JOJO on 2021/8/6.
//

import UIKit
import DeviceKit

class CAVymHomeVC: UIViewController {

    var avatarBtnClickblock: (()->Void)?
    var postsBtnClickblock: (()->Void)?
    var isActioning = false
    let avtarBtn = CAVymHomeBtn(frame: .zero, iconName: "home_avatar", titleStr: "Avatar", infoStr: "Edit Love Avatar")
    let postsBtn = CAVymHomeBtn(frame: .zero, iconName: "home_posts", titleStr: "Love Theme", infoStr: "Make Photos")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    

     

}

extension CAVymHomeVC {
    func setupView() {
        //
        let topHeaderBgImgV = UIImageView()
        topHeaderBgImgV
            .image("home_head_background")
            .contentMode(.scaleAspectFill)
            .adhere(toSuperview: view)

        //
        let topBgIconImgV = UIImageView()
        topBgIconImgV
            .image("home_head_photo")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: view)
        
        
        //
        let bottomBgView = UIImageView()
        bottomBgView.isUserInteractionEnabled =   true
        bottomBgView
            .image("home_background")
            .contentMode(.scaleToFill)
            .adhere(toSuperview: view)
        
        
        if Device.current.diagonal == 4.7 || Device.current.diagonal == 5.5 || Device.current.diagonal >= 7.6 {
            bottomBgView
                .snp.makeConstraints {
                    $0.left.right.bottom.equalToSuperview()
                    $0.height.equalTo(UIScreen.width * (904/850))
                }
        } else {
            bottomBgView
                .snp.makeConstraints {
                    $0.left.right.bottom.equalToSuperview()
                    $0.height.equalTo(UIScreen.width * (904/750))
                }
        }
        
        //
        topHeaderBgImgV
            .snp.makeConstraints {
                $0.left.right.top.equalToSuperview()
                $0.bottom.equalTo(bottomBgView.snp.top).offset(40)
            }
        topBgIconImgV.snp.makeConstraints {
            $0.bottom.equalTo(topHeaderBgImgV.snp.bottom)
            $0.right.equalTo(-18)
            $0.height.width.equalTo(220)
        }
        //
        let toptitLabel = UILabel()
        toptitLabel
            .fontName(24, "Quicksand-SemiBold")
            .color(.white)
            .textAlignment(.center)
            .adjustsFontSizeToFitWidth()
            .numberOfLines(0)
            .text("Love Collage & Sticker & Frame")
            .adhere(toSuperview: view)
        toptitLabel
            .snp.makeConstraints {
                $0.left.equalTo(20)
                $0.width.equalTo(120)
                $0.height.greaterThanOrEqualTo(110)
                $0.centerY.equalTo(topHeaderBgImgV.snp.centerY).offset(0)
            }
        //
        
        avtarBtn
            .adhere(toSuperview: bottomBgView)
            .snp.makeConstraints {
                $0.width.equalTo(272)
                $0.height.equalTo(140)
                $0.bottom.equalTo(bottomBgView.snp.centerY).offset(-10)
                $0.centerX.equalToSuperview()
            }
        avtarBtn.addTarget(self, action: #selector(avatarBtnClick(sender:)), for: .touchUpInside)
        
        //
        postsBtn
            .adhere(toSuperview: bottomBgView)
            .snp.makeConstraints {
                $0.width.equalTo(272)
                $0.height.equalTo(140)
                $0.top.equalTo(bottomBgView.snp.centerY).offset(10)
                $0.centerX.equalToSuperview()
            }
        postsBtn.addTarget(self, action: #selector(postsBtnClick(sender:)), for: .touchUpInside)
        
    }
    
       
    @objc func avatarBtnClick(sender: UIButton) {
        
        if isActioning == false {
            isActioning = true
            avatarBtnClickblock?()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.isActioning = false
            }
        }
        
    }
    
    @objc func postsBtnClick(sender: UIButton) {
        
        if isActioning == false {
            isActioning = true
            postsBtnClickblock?()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.isActioning = false
            }
        }
    }
    
}







class CAVymHomeBtn: UIButton {
    var iconName: String
    var titleStr: String
    var infoStr: String
    
    init(frame: CGRect, iconName: String, titleStr: String, infoStr: String) {
        self.iconName = iconName
        self.titleStr = titleStr
        self.infoStr = infoStr
        
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//
//
    func setupView() {
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.masksToBounds = true
        //272 140
        //
        let iconImgV = UIImageView()
        iconImgV
            .image(iconName)
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: self)
        iconImgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.left.equalToSuperview()
            
        }
        //
        let titLabel = UILabel()
        titLabel
            .fontName(22, "Quicksand-SemiBold")
            .color(.black)
            .text(titleStr)
            .adhere(toSuperview: self)
        titLabel.snp.makeConstraints {
            $0.bottom.equalTo(snp.centerY)
            $0.left.equalTo(135)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        let infoLabel = UILabel()
        infoLabel
            .fontName(14, "Quicksand-SemiBold")
            .color(UIColor.black.withAlphaComponent(0.6))
            .text(infoStr)
            .adhere(toSuperview: self)
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(snp.centerY).offset(5)
            $0.left.equalTo(135)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        //
        
        
            
        
        
    }
    
}



