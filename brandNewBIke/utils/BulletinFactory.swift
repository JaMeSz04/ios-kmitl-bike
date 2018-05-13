//
//  BulletinFactory.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 4/21/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import BulletinBoard
import RxSwift

public class BulletinFactory {
    private var pageItemList: [PageBulletinItem] = [PageBulletinItem]()
    private var currentIndex: Int = 0
    
    public func addPage(title: String, subtitle: String, image: UIImage, buttonText: String, action: PublishSubject<PageBulletinItem>){
        let page = PageBulletinItem(title: title)
        page.image = image
        page.descriptionText = subtitle
        page.actionButtonTitle = buttonText
        page.actionHandler = { (item: PageBulletinItem) in
            action.onNext(item)
        }
        page.interfaceFactory.tintColor = .black
        page.isDismissable = true
        self.pageItemList.append(page)
    }
    
    public func getPageItem() -> PageBulletinItem {
        do {
            let item = try self.pageItemList[currentIndex]
            return item
        } catch {
            return self.getRoot()
        }
        
    }
    
    public func increment(){
        self.currentIndex += 1
    }
    
    public func getRoot() -> PageBulletinItem {
        return self.pageItemList[0]
    }
    
    
 
}
