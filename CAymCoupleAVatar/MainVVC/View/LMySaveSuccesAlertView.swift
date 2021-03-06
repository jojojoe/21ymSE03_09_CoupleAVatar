//
//  LMySaveSuccesAlertView.swift
//  CAymCoupleAVatar
//
//  Created by JOJO on 2021/8/10.
//

import UIKit
import RxSwift

class LMySaveSuccesAlertView: UIView {

    let disposeBag = DisposeBag()
    var backBtnClickBlock: (()->Void)?
    var okBtnClickBlock: (()->Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        backgroundColor = UIColor.black.withAlphaComponent(0.8)
        //
        let bgBtn = UIButton(type: .custom)
        bgBtn
            .image(UIImage(named: ""))
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                self.backBtnClickBlock?()
            })
            .disposed(by: disposeBag)
        
        addSubview(bgBtn)
        bgBtn.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        //
        let contentV = UIView()
            .backgroundColor(UIColor.clear)
        addSubview(contentV)
        contentV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-10)
            $0.height.equalTo(380)
            $0.width.equalTo(330)
        }
        //
        let bgImgV = UIImageView()
            .image("costcoin_background")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: contentV)
        bgImgV.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
        
        //
        let backBtn = UIButton(type: .custom)
        backBtn
            .image(UIImage(named: "ic_close"))
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                self.backBtnClickBlock?()
            })
            .disposed(by: disposeBag)
        
        addSubview(backBtn)
        backBtn.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        
        //
        let okBtn = UIButton(type: .custom)
        okBtn.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 22)
        okBtn.setTitleColor(UIColor.black, for: .normal)
        okBtn
            .backgroundImage(UIImage(named: "button"))
//            .title("Continue")
            .rx.tap
            .subscribe(onNext:  {
                [weak self] in
                guard let `self` = self else {return}
                self.okBtnClickBlock?()
            })
            .disposed(by: disposeBag)
        
        addSubview(okBtn)
        okBtn.snp.makeConstraints {
            $0.bottom.equalTo(contentV.snp.bottom).offset(-18)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(276)
            $0.height.equalTo(72)
        }
        //
        let okBtnLabel = UILabel()
        okBtnLabel
            .fontName(22, "Quicksand-SemiBold")
            .color(.white)
            .text("OK")
            .adhere(toSuperview: self)
        okBtnLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(okBtn.snp.top).offset(18)
            $0.width.height.greaterThanOrEqualTo(1)
        }
        
//
        //
        
        let titLab = UILabel()
            .text("Photo save successful.")
            .textAlignment(.center)
            .numberOfLines(0)
            .fontName(20, "Quicksand-SemiBold")
            .color(.black)
            .contentMode(.center)
        
        contentV.addSubview(titLab)
        titLab.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(okBtn.snp.top).offset(-40)
            $0.left.equalTo(20)
            $0.height.greaterThanOrEqualTo(1)
        }
        //
        let iconImgV = UIImageView()
        iconImgV
            .image("ic_save")
            .contentMode(.scaleAspectFit)
            .adhere(toSuperview: contentV)
        iconImgV.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(titLab.snp.top).offset(-18)
            $0.width.height.equalTo(55)
        }
        
    }
    
}
