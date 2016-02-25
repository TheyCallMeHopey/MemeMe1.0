//
//  ViewController.swift
//  Meme Me
//
//  Created by Hope on 12/1/15.
//  Copyright © 2015 Hope Elizabeth. All rights reserved.
//

import UIKit

struct Meme
{
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    var meme: Meme!
    
    @IBOutlet weak var chooseImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let memeTextAttributes = [NSStrokeColorAttributeName : UIColor.blackColor(), NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, NSStrokeWidthAttributeName : -3.0]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
   
    func keyboardWillShow(notification: NSNotification)
    {
        if bottomTextField.isFirstResponder()
        {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        self.view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat
    {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        if textField.text == "TOP" || textField.text == "BOTTOM"
        {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField == topTextField
        {
            topTextField.resignFirstResponder()
        }
        else if textField == bottomTextField
        {
            bottomTextField.resignFirstResponder()
            self.view.frame.origin.y = 0
        }
        
        return true;
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            chooseImageView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
            topTextField.hidden = false
            bottomTextField.hidden = false
            chooseImageView.hidden = false
        }
    }
    
    func generateMemedImage() -> UIImage
    {
        navigationBar.hidden = true
        toolBar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navigationBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
    }
    
    func save()
    {
        meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: chooseImageView.image!, memedImage: generateMemedImage())
    }
    
    @IBAction func chooseImage(sender: AnyObject)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func openCamera(sender: AnyObject)
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        {
            let chooseImage = UIImagePickerController()
            chooseImage.delegate = self
            chooseImage.sourceType = UIImagePickerControllerSourceType.Camera
            presentViewController(chooseImage, animated: true, completion: nil)
        }
        else
        {
            let alertController = UIAlertController(title: "", message: "CAMERA IS UNAVAILABLE", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil )
            
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil )
        }
    }
    
    @IBAction func cancel(sender: AnyObject)
    {
        topTextField.hidden = true
        bottomTextField.hidden = true
        chooseImageView.hidden = true
    }
    
    @IBAction func createMeme(sender: AnyObject)
    {
        let theMemedImage = generateMemedImage()
        
        let nextController = UIActivityViewController(activityItems: [theMemedImage], applicationActivities: nil)
        self.presentViewController(nextController, animated: true, completion: nil)
    }
}

