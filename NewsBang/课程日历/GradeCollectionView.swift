//
//  GradeCollectionView.swift
//  NewsBang
//
//  Created by 徐炜楠 on 2018/1/18.
//  Copyright © 2018年 徐炜楠. All rights reserved.
//

import UIKit

class GradeCollectionView: UICollectionViewLayout,UICollectionViewDelegate,UICollectionViewDataSource {
    var fourGrade = [Int]()
    override init() {
        super.init()
    }
    init(_ senior:Int) {
        super.init()
        fourGrade.append(senior)
        fourGrade.append(senior+1)
        fourGrade.append(senior+2)
        fourGrade.append(senior+3)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("运行到了这步吗")
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GradeCollectionCell
        cell.titleLb.text = "\(fourGrade[indexPath.row])"
        print("运行到了这步吗？\(indexPath.row)")
        return cell
    }
}
