//
//  CreateViewController.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 17/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit
import ALCameraViewController

class CreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var viewLeft: UIView!
    
    @IBOutlet weak var viewRight: UIView!
    
    @IBOutlet weak var imgLeft: UIImageView!
    
    @IBOutlet weak var imgRight: UIImageView!
    
    @IBOutlet weak var imgTapLeft: UIImageView!
    
    @IBOutlet weak var imgTapRight: UIImageView!
    
    @IBOutlet weak var scrollViewRight: UIScrollView!
    
    @IBAction func cancel() {
        print("cancel")
    }
    
    @IBOutlet weak var viewHeader: UIVisualEffectView!
    
    @IBOutlet weak var lblTags: UILabel!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    private var imageViewRight = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgProfile.layer.cornerRadius = imgProfile.bounds.size.width / 2
        imgProfile.clipsToBounds = true
        
        let tapRecLeft = UITapGestureRecognizer()
        tapRecLeft.addTarget(self, action: "tappedLeft")
        imgLeft.addGestureRecognizer(tapRecLeft)
        
        let tapRecRight = UITapGestureRecognizer()
        tapRecRight.addTarget(self, action: "tappedRight")
        scrollViewRight.addGestureRecognizer(tapRecRight)
    }

    func tappedLeft(){
        self.getImage()
    }

    func tappedRight(){
        self.getImage()
    }
    
    func getImage() {
        #if (arch(i386) || arch(x86_64))
            
            print("simülatör getImage")
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        #else
            
            print("non-simülatör getImage")
            
            let cameraViewController = ALCameraViewController(croppingEnabled: true) { image in
                // self.imageTarget.image = image
                // scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tileableImage.png"]];
            }
            
            self.presentViewController(cameraViewController, animated: true, completion: nil)
            
        #endif
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("didFinishPickingImage")
        
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
