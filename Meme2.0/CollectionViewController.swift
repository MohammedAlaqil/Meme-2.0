//
//  CollectionViewController.swift
//  Meme1.0
//
//  Created by M7md on 01/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController : UICollectionViewController {
    
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        collectionView?.reloadData()
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
     override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CollectionViewControllerCell
        cell.memeImage.image = appDelegate.memes[indexPath.row].memedImage
        
        return cell
    }
    
      override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
    
     
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "MemeImageView") as! MemeImageViewController
        detailController.selectedMeme = appDelegate.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    
    }
}
