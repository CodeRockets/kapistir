//
//  CreateViewController.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 17/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit
import ALCameraViewController

class CreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var viewLeft: UIView!
    
    @IBOutlet weak var viewRight: UIView!
    
    @IBOutlet weak var imgLeft: UIImageView!
    
    @IBOutlet weak var scrollViewRight: UIScrollView! {
        didSet{
            print("didiset")
            scrollViewRight.contentSize = imageViewRight.frame.size
            scrollViewRight.delegate = self
            scrollViewRight.minimumZoomScale = 0.03
            scrollViewRight.maximumZoomScale = 2.0
        }
    }
    
    private var imageViewRight = UIImageView()
    
    private var imageRight: UIImage? {
        get { return imageViewRight.image }
        set {
            imageViewRight.image = newValue // change image
            imageViewRight.sizeToFit()      // resize image with sizes
            scrollViewRight?.contentSize = imageViewRight.frame.size
        }
    }
    
    @IBAction func cancel() {
        print("cancel")
    }
    
    @IBOutlet weak var viewHeader: UIVisualEffectView!
    
    @IBOutlet weak var lblTags: UILabel!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgProfile.layer.cornerRadius = imgProfile.bounds.size.width / 2
        imgProfile.clipsToBounds = true
        
        let tapRecLeft = UITapGestureRecognizer()
        tapRecLeft.addTarget(self, action: "tappedLeft")
        imgLeft.addGestureRecognizer(tapRecLeft)
        
        //let tapRecRight = UITapGestureRecognizer()
        //tapRecRight.addTarget(self, action: "tappedRight")
        //scrollViewRight.addGestureRecognizer(tapRecRight)
        
        //
        scrollViewRight.addSubview(imageViewRight)
    }

    func tappedLeft(){
        self.getImage()
    }

    func tappedRight(){
        self.getImage()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        print("zooming")
        return imageViewRight
    }
    
    @IBAction func addRight(sender: UIButton) {
        self.tappedRight()
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
                self.imageRight = image
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            self.presentViewController(cameraViewController, animated: true, completion: nil)
            
        #endif
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("didFinishPickingImage")
        
        self.imageRight = image
        
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
