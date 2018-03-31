//
//  DetailVenueController.swift
//  NTA_Demo_Foursquare
//
//  Created by AnhNguyen on 3/29/18.
//  Copyright © 2018 ATA_Studio. All rights reserved.
//

import Foundation
import UIKit
import DTPhotoViewerController

class DetailVenueController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var collectionViewImg: UICollectionView!
    
    var detailModel = DetailModel()
    var itemPhoto = [ItemsPhoto]()
    let cellReuseIdentifier = "cell"
    let cellPhotoReuseIdentifier = "PhotoCell"
    var screenWidth: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenWidth = UIScreen.main.bounds.width
        self.title = "Detail Venue"
        
        // Setup table view
        self.tblView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.tblView.rowHeight = UITableViewAutomaticDimension
        self.tblView.estimatedRowHeight = UITableViewAutomaticDimension
        
        if let photos = detailModel.photos {
            if (photos.groups?.isEmpty == false) {
                if let item = photos.groups?[0].items {
                    self.itemPhoto = item
                }
            }
        }
        
        
    }
    
    // MARK: - Table View - Load Tip Data
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (detailModel.tips?.groups?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tblView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        if let tips = detailModel.tips {
            if (tips.groups?.isEmpty == false) {
                if let item = tips.groups?[0].items {
                    let venue = item[(indexPath as NSIndexPath).row]
                    cell.textLabel?.numberOfLines = 0
                    cell.textLabel?.text = venue.text
                }
            }
        }
        return cell
    }
    
    private func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - Collection View - Load Photo Data
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemPhoto.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellPhotoReuseIdentifier, for: indexPath as IndexPath) as! MyCollectionViewCell
        myCell.backgroundColor = UIColor.black
        
        let item = self.itemPhoto[indexPath.row]
        let imageUrl:NSURL = NSURL(string: item.photoUrl)!
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                myCell.imgView.sd_cancelCurrentAnimationImagesLoad()
                myCell.imgView.sd_setImage(with: imageUrl as URL, placeholderImage: UIImage(named: "none"))
            }
        }
        
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth-40)/3, height: (screenWidth-40)/3);
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MyCollectionViewCell
        if let viewController = DTPhotoViewerController(referencedView: cell.imgView, image: cell.imgView.image) {
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

