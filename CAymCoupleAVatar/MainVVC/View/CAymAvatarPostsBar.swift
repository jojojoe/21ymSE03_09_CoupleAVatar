//
//  CAymAvatarPostsBar.swift
//  CAymCoupleAVatar
//
//  Created by JOJO on 2021/8/10.
//

import UIKit

class CAymAvatarPostsBar: UIView {

    var dataType: EditType
    var itemList: [OverlyerTypeItem] = []
    var collection: UICollectionView!
    var selecTAvatarPostItemBlock: ((OverlyerTypeItem)->Void)?
    var currentItem: OverlyerTypeItem?
    
    init(frame: CGRect, dataType: EditType) {
        self.dataType = dataType
        super.init(frame: frame)
        loadData()
        setupView()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadData() {
        if dataType == .avatar {
            itemList = DataManager.default.avatarOverlayerTypeList
        } else {
            itemList = DataManager.default.postsOverlayerTypeList
        }
    }
    
    func setupView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.bottom.right.left.equalToSuperview()
        }
        collection.register(cellWithClass: CAymAvatarPostsCell.self)
    }
    
    
     

}

extension CAymAvatarPostsBar: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = itemList[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(withClass: CAymAvatarPostsCell.self, for: indexPath)
        cell.contentImgV
            .image(item.thumb)
        if item.isPro == true && !LMymContentUnlockManager.default.hasUnlock(itemId: item.thumb ?? "") {
            cell.vipImgV.isHidden = false
        } else {
            cell.vipImgV.isHidden = true
        }
        if currentItem?.thumb == item.thumb {
            cell.selectView.isHidden = false
        } else {
            cell.selectView.isHidden = true
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension CAymAvatarPostsBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if dataType == .avatar {
            return CGSize(width: 80, height: 80)
        }
        return CGSize(width: 80, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
}

extension CAymAvatarPostsBar: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = itemList[indexPath.item]
        
        selecTAvatarPostItemBlock?(item)
        if item.isPro == false || LMymContentUnlockManager.default.hasUnlock(itemId: item.thumb ?? "") {
            currentItem = item
            collectionView.reloadData()
        } else {
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
}




class CAymAvatarPostsCell: UICollectionViewCell {
    let contentImgV = UIImageView()
    let selectView: UIView = UIView()
    let vipImgV = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        //
        contentImgV.contentMode = .scaleAspectFit
        contentImgV.layer.cornerRadius = 8
        contentImgV.layer.masksToBounds = true
        contentImgV.clipsToBounds = true
        contentView.addSubview(contentImgV)
        contentImgV.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.top.left.equalTo(5)
        }
        
        //
        selectView.isHidden = true
        contentView.addSubview(selectView)
        selectView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        //
        let selectImgV = UIImageView()
        selectImgV
            .image("edit_choose")
            .adhere(toSuperview: selectView)
        selectImgV.snp.makeConstraints {
            $0.left.right.top.bottom.equalToSuperview()
        }
        
        
        //
        vipImgV
            .image("avatar_ic_lock")
            .adhere(toSuperview: contentView)
        vipImgV.snp.makeConstraints {
            $0.top.right.equalToSuperview()
            $0.width.equalTo(25)
            $0.height.equalTo(23)
        }
        //
        
    }
}
