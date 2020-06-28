//
//  ViewController.swift
//  Meme1.0
//
//  Created by M7md on 08/04/2019.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UITextFieldDelegate {
  
    
    //IBbOutlet ..
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var activityButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    
    //Text Fields ..
    var topEdited = false
    var bottomEdited = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField(topText, text: "TOP")
        configureTextField(bottomText, text: "BOTTOM")
    }
    // reinitializer ..
    func configureTextField(_ textField: UITextField, text: String) {
        textField.text = text
        textField.defaultTextAttributes = [
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            .foregroundColor: UIColor.white,
            .strokeColor: UIColor.black,
            .strokeWidth: -8.0
        ]
        textField.textAlignment = .center
        textField.delegate = self
  
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        activityButton.isEnabled = imagePickerView.image != nil
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
   
    @IBAction func cancelEditing(_ sender: Any) {
        imagePickerView.image = nil
        topText.text = "TOP"
        topEdited = false
        bottomText.text = "BOTTOM"
        bottomEdited = false
        activityButton.isEnabled = false
        dismiss(animated: false, completion: nil)
    }
    func pickingAnImage (Source: UIImagePickerController.SourceType ){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = Source
        self.present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        pickingAnImage(Source: .camera)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        pickingAnImage(Source: .photoLibrary)
    }
    
    @IBAction func activityView(_ sender: Any) {
        let image = UIImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil )
        controller.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save(memedImage: self.generateMemedImage())
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
            imagePickerView.contentMode = UIView.ContentMode.scaleAspectFit
            topText.isHidden = false
            bottomText.isHidden = false
            dismiss(animated: true, completion: nil)
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePickerView.image = nil
        topText.isHidden = true
        bottomText.isHidden = true
        dismiss(animated: true, completion: nil)
    }
    
  
     func textFieldDidBeginEditing(_ textField: UITextField) {
     if textField == topText && !topEdited {
     textField.text = ""
     topEdited = true
     }
     
     if textField == bottomText && !bottomEdited {
     textField.text = ""
     bottomEdited = true
   
     }
     
     }
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     textField.resignFirstResponder()
     return true
     }
    
    @objc func keyboardWillShow(_ notification:Notification) {
       if bottomText.isFirstResponder{
        view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
   @objc func keyboardWillHide(_ notification:Notification) {
     if bottomText.isFirstResponder{
        view.frame.origin.y = 0
    }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    

    
   func save(memedImage: UIImage?) {
        // Create the meme
        guard let _ = memedImage,
            let _ = imagePickerView.image else {
                return
    }
    
    let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePickerView.image!, memedImage:memedImage!)
    
    let object = UIApplication.shared.delegate
    let appDelegate = object as! AppDelegate
    appDelegate.memes.append(meme)
    }
   
    func generateMemedImage() -> UIImage {
        topToolBar.isHidden = true
        bottomToolBar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        topToolBar.isHidden = false
        bottomToolBar.isHidden = false
        
        return memedImage
    }
    
    //close the keyboard when touch the screen
    override func touchesBegan(_ touch: Set<UITouch>, with event: UIEvent?) {
       view.endEditing(true)
    }
 
   
}

