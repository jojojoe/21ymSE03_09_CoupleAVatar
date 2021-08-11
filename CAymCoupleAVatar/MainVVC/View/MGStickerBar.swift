//
//  MGStickerBar.swift
//  MGymMakeGrid
//
//  Created by JOJO on 2021/2/8.
//

import UIKit

class GCStickerView: UIView {
    
    var collection: UICollectionView!
    var didSelectStickerItemBlock: ((_ stickerItem: GCStickerItem) -> Void)?
    var currentSelectIndexPath : IndexPath?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        loadData()
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        
    }

}

extension GCStickerView {
    func refreshContentCollection() {
        collection.reloadData()
    }
}


extension GCStickerView {
    func loadData() {
        
    }
    
    func setupView() {
        // collection
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(90)
        }
        collection.register(cellWithClass: GCStickerCell.self)
    }
    
}

extension GCStickerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = DataManager.default.stickerList[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withClass: GCStickerCell.self, for: indexPath)
        
        cell.contentImageV.image = UIImage(named: item.thumbnail)
        
//        if currentSelectIndexPath?.item == indexPath.item {
//            cell.selectView.isHidden = false
//        } else {
//            cell.selectView.isHidden = true
//        }
        
        if item.isPro == false || LMymContentUnlockManager.default.hasUnlock(itemId: item.thumbnail ?? "") {
            cell.proImageV.isHidden = true
        } else {
            cell.proImageV.isHidden = false
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.default.stickerList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension GCStickerView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}

extension GCStickerView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = DataManager.default.stickerList[indexPath.item]
//        currentSelectIndexPath = indexPath
        didSelectStickerItemBlock?(item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}




class GCStickerCell: UICollectionViewCell {
    
    let contentImageV: UIImageView = UIImageView()
    let selectView: UIImageView = UIImageView()
    let proImageV: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupView() {
        
        
        let cotnentBgview = UIView()
        cotnentBgview
            .backgroundColor(UIColor(hexString: "#FFEFF4")!)
            .adhere(toSuperview: contentView)
        cotnentBgview.layer.cornerRadius = 8
        cotnentBgview.layer.masksToBounds = true
        cotnentBgview.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.top.equalTo(5)
        }
        //
        contentView.addSubview(contentImageV)
        contentImageV.contentMode = .scaleAspectFit
        contentImageV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.left.top.equalTo(5)
            
        }
        
        selectView.image = UIImage(named: "edit_choose")
        selectView.isHidden = true
        addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(22)
        }
        
        proImageV.image = UIImage(named: "avatar_ic_lock")
        proImageV.isHidden = true
        addSubview(proImageV)
        proImageV.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.width.equalTo(25)
            $0.height.equalTo(23)
        }
        
    }
    
//    override var isSelected: Bool {
//        didSet {
//            selectView.isHidden = !isSelected
//            if isSelected {
//                
//            } else {
//                
//            }
//        }
//    }
    
}











