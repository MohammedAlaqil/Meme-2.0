//
//  MemeImageViewController.swift
//  Meme1.0
//
//  Created by M7md on 01/05/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

class MemeImageViewController : UIViewController {
    
    var selectedMeme: Meme!
    
    @IBOutlet weak var imagePicker: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.image = selectedMeme.memedImage
    }

}
