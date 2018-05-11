//
//  ViewController.swift
//  AppStoreCollectionView
//
//  Created by marosdee on 5/10/18.
//  Copyright © 2018 excelbangkok. All rights reserved.
//

import UIKit

class AppStoreItem: NSObject {
    var imageName = ""
}

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    fileprivate let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var itemSize = CGSize(width: 0, height: 0)
    var appStoreItems = [AppStoreItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        for index in 1..<10 {
            let appStoreItem = AppStoreItem()
            appStoreItem.imageName = "example-\(index).jpg"
            appStoreItems.append(appStoreItem)
        }
       
        collectionView.dataSource = self
        collectionView.delegate = self
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = sectionInsets
            layout.scrollDirection = .horizontal
        }
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.isPagingEnabled = false
        view.layoutIfNeeded()
        
        let width = collectionView.bounds.size.width-32
        let height = collectionView.bounds.size.height // width * (9/16)
        itemSize = CGSize(width: width, height: height)
        print("itemSize: \(itemSize)")
        collectionViewHeight.constant = height
        view.layoutIfNeeded()
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("appStoreItems.count: \(appStoreItems.count)")
        return appStoreItems.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppStoreCell", for: indexPath) as! AppStoreCell
        cell.setUp(appStoreItems[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
    }
    
    //MARK: flowlayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = itemSize.width
        targetContentOffset.pointee = scrollView.contentOffset
        var factor: CGFloat = 0.5
        if velocity.x < 0 {
            factor = -factor
            print("swipe right")
        } else {
            print("swipe left")
        }
        
        var index = Int( round((scrollView.contentOffset.x/pageWidth)+factor) )
        if index < 0 {
            index = 0
        }
        if index > appStoreItems.count-1 {
            index = appStoreItems.count-1
        }
        let indexPath = IndexPath(row: index, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}

class AppStoreCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp(_ appStoreItem: AppStoreItem) {
        print("image: \(appStoreItem.imageName)")
        imageView.image = UIImage(named: appStoreItem.imageName)
    }
}

