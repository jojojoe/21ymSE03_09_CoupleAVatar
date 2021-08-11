//
//  SLymStorereVC.swift
//  PGIymPicGridIn
//
//  Created by JOJO on 2021/4/28.
//

import UIKit
import NoticeObserveKit
import StoreKit
import Adjust
import SwiftyStoreKit

class SLymStorereVC: UIViewController {
     
    private var pool = Notice.ObserverPool()
    let titleLabel = UILabel(text: "Store")
    let backBtn = UIButton(type: .custom)
    let topCoinLabel = UILabel()
    var collection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupView()
        setupCollection()
        addNotificationObserver()
        updateStoreStatus(isPush: false)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func addNotificationObserver() {
        
        NotificationCenter.default.nok.observe(name: .pi_noti_coinChange) {[weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.topCoinLabel.text = "\(LMymBCartCoinManager.default.coinCount)"
            }
        }
        .invalidated(by: pool)
        
        NotificationCenter.default.nok.observe(name: .pi_noti_priseFetch) { [weak self] _ in
            guard let `self` = self else {return}
            DispatchQueue.main.async {
                self.collection.reloadData()
            }
        }
        .invalidated(by: pool)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.topCoinLabel.text = "\(LMymBCartCoinManager.default.coinCount)"
    }
    
    func updateStoreStatus(isPush: Bool) {
        if isPush {
            backBtn.isHidden = false
            titleLabel.isHidden = true
        } else {
            backBtn.isHidden = true
            titleLabel.isHidden = false
        }
    }
    
}

extension SLymStorereVC {
    
    @objc func backBtnClick(sender: UIButton) {
        if self.navigationController != nil {
            self.navigationController?.popViewController()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setupView() {
        let bgImgV = UIImageView()
        bgImgV
            .image("setting_background")
            .contentMode(.scaleAspectFill)
            .adhere(toSuperview: view)
        bgImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        
        
        titleLabel
            .fontName(32, "Quicksand-SemiBold")
            .textAlignment(.center)
            .adhere(toSuperview: view)
            .color(UIColor.black)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12)
            $0.left.equalTo(24)
            $0.height.greaterThanOrEqualTo(30)
            $0.width.greaterThanOrEqualTo(1)
        }
        //
        
        view.addSubview(backBtn)
        backBtn.setImage(UIImage(named: "avatar_ic_back"), for: .normal)
        backBtn.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.left.equalTo(10)
            $0.width.height.equalTo(44)
        }
        backBtn.addTarget(self, action: #selector(backBtnClick(sender:)), for: .touchUpInside)
        
        
        //
        topCoinLabel.textAlignment = .right
        topCoinLabel.text = "\(LMymBCartCoinManager.default.coinCount)"
        topCoinLabel.textColor = UIColor.black
        topCoinLabel.font = UIFont(name: "Quicksand-SemiBold", size: 24)
        view.addSubview(topCoinLabel)
        topCoinLabel.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.right.equalTo(-24)
            $0.height.greaterThanOrEqualTo(35)
            $0.width.greaterThanOrEqualTo(25)
        }
        //
        let topCoinImgV = UIImageView(image: UIImage(named: "costcoin_coin"))
        view.addSubview(topCoinImgV)
        topCoinImgV.snp.makeConstraints {
            $0.centerY.equalTo(topCoinLabel)
            $0.right.equalTo(topCoinLabel.snp.left).offset(-5)
            $0.width.height.equalTo(20)
        }
        
        
    }
    
    func setupCollection() {
        
        // collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
//        collection.layer.cornerRadius = 35
        collection.layer.masksToBounds = true
        collection.delegate = self
        collection.dataSource = self
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.top.equalTo(topCoinLabel.snp.bottom).offset(5)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        collection.register(cellWithClass: LMymStoreCell.self)
        
    }
    
    func selectCoinItem(item: StoreItem) {
        LMymBCartCoinManager.default.purchaseIapId(item: item) { (success, errorString) in
            
            if success {
                self.showAlert(title: "Purchase successful.", message: "")
            } else {
                self.showAlert(title: "Purchase failed.", message: errorString)
            }
        }
    }
    
    
}

extension SLymStorereVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: LMymStoreCell.self, for: indexPath)
        let item = LMymBCartCoinManager.default.coinIpaItemList[indexPath.item]
        cell.coinCountLabel.text = "X\(item.coin)"
        cell.priceLabel.text = item.price
//
//
//        cell.bgImageV.image = UIImage(named: topImgName)
//        cell.priceBgImgV.image = UIImage(named: priceImgName)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return LMymBCartCoinManager.default.coinIpaItemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension SLymStorereVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellwidth: CGFloat = 328
        let cellHeight: CGFloat = 98
        
        
        return CGSize(width: cellwidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left: CGFloat = ((UIScreen.main.bounds.width - 328) / 2)
        return UIEdgeInsets(top: 20, left: left, bottom: 20, right: left)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let left: CGFloat = 16
            //((UIScreen.main.bounds.width - 150 * 2 - 1) / 3)
        return left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let left: CGFloat = 16
//        let left: CGFloat = ((UIScreen.main.bounds.width - 150 * 2 - 1) / 3)
        return left
    }
    
}

extension SLymStorereVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = LMymBCartCoinManager.default.coinIpaItemList[safe: indexPath.item] {
            selectCoinItem(item: item)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}





class LMymStoreCell: UICollectionViewCell {
    
    var bgView: UIView = UIView()
    
    var bgImageV: UIImageView = UIImageView()
    var coverImageV: UIImageView = UIImageView()
    var coinCountLabel: UILabel = UILabel()
    var priceLabel: UILabel = UILabel()
    var priceBgImgV: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        backgroundColor = UIColor.clear
        bgView.backgroundColor = .clear
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
        // 654 196
        bgImageV
            .backgroundColor(.clear)
            .contentMode(.scaleAspectFit)
            .image("store_background")
            .adhere(toSuperview: bgView)
//        bgImageV.layer.masksToBounds = true
//        bgImageV.layer.cornerRadius = 27
//        bgImageV.layer.borderColor = UIColor.black.cgColor
//        bgImageV.layer.borderWidth = 4
        
        bgImageV.snp.makeConstraints {
            $0.top.left.right.bottom.equalToSuperview()
        }
        
        //
        let iconImgV = UIImageView(image: UIImage(named: "costcoin_coin"))
        iconImgV.contentMode = .scaleAspectFit
        bgView.addSubview(iconImgV)
        iconImgV.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(27)
            $0.width.height.equalTo(45)
        }
        
        //
        coinCountLabel.adjustsFontSizeToFitWidth = true
        coinCountLabel
            .color(UIColor(hexString: "#000000")!)
            .numberOfLines(1)
            .fontName(20, "PingFangSC-Semibold")
            .textAlignment(.center)
            .adhere(toSuperview: bgView)
//        coinCountLabel.layer.shadowColor = UIColor(hexString: "#FFE7A8")?.cgColor
//        coinCountLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
//        coinCountLabel.layer.shadowRadius = 3
//        coinCountLabel.layer.shadowOpacity = 0.8
        
        coinCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.greaterThanOrEqualTo(1)
            $0.left.equalTo(110)
            $0.height.greaterThanOrEqualTo(1)
        }
        
        //
//        coverImageV.image = UIImage(named: "home_button")
//        coverImageV.contentMode = .center
//        bgView.addSubview(coverImageV)
//
        
        //
//        bgView.addSubview(priceBgImgV)
//        priceBgImgV
//            .image("store_button")
//        priceBgImgV.snp.makeConstraints {
//            $0.left.right.equalToSuperview()
//            $0.bottom.equalToSuperview()
//            $0.height.equalTo(44)
//        }
//        priceBgImgV.contentMode = .scaleAspectFill
        //
        priceLabel
            .color(UIColor.white)
            .fontName(22, "Quicksand-SemiBold")
            .textAlignment(.center)
            .adhere(toSuperview: bgView)
            .adjustsFontSizeToFitWidth()
//        priceLabel.layer.shadowColor = UIColor(hexString: "#FF12D2")?.cgColor
//        priceLabel.layer.shadowOffset = CGSize(width: 0, height: 0)
//        priceLabel.layer.shadowRadius = 3
//        priceLabel.layer.shadowOpacity = 0.8
        
        
//        priceLabel.backgroundColor = UIColor(hexString: "#4AD0EF")
//        priceLabel.cornerRadius = 30
        
//        priceLabel.layer.borderWidth = 2
//        priceLabel.layer.borderColor = UIColor.white.cgColor
        priceLabel.snp.makeConstraints {
            $0.width.equalTo(94)
            $0.right.equalTo(4)
            $0.height.greaterThanOrEqualTo(44)
            $0.bottom.equalToSuperview()
        }
        
        
        
//        coverImageV.snp.makeConstraints {
//            $0.center.equalTo(priceLabel.snp.center)
//            $0.width.equalTo(135)
//            $0.height.equalTo(54)
//        }
    }
     
}




