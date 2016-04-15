//
//  CreateViewController.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 17/03/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import UIKit
import ALCameraViewController
import Alamofire

class CreateViewController:
    UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UIScrollViewDelegate
{
    
    var target = 0
    
    @IBOutlet weak var loaderLeftHeight: NSLayoutConstraint!
    
    @IBOutlet weak var loaderRightHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblLoaderLeftBottom: NSLayoutConstraint!
    
    @IBOutlet weak var lblLoaderRightBottom: NSLayoutConstraint!
    
    @IBOutlet weak var viewLoaderLeft: UIVisualEffectView!
    
    @IBOutlet weak var viewLoaderRight: UIVisualEffectView!
    
    @IBOutlet weak var viewLeft: UIView!
    
    @IBOutlet weak var viewRight: UIView!
    
    @IBAction func cancel(sender: RoundedImageButton) {
        print("cancel")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func add(sender: RoundedImageButton) {
        let croppedLeft = crop(image: self.imageLeft!, targetScrollView: self.scrollViewLeft)
        let croppedRight = crop(image: self.imageRight!, targetScrollView: self.scrollViewRight)

        print("\(croppedLeft.size)")
        print("\(croppedRight.size)")
        
        uploadImage(croppedLeft, target: 1)
        uploadImage(croppedRight, target: 0)
    }
    
    func uploadImage(image:UIImage, target: Int) {
        let headers = [
            "Authorization": "Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==",
            "Content-Type": "application/x-www-form-urlencoded",
            "x-voter-client-id": App.Keys.clientId!,
            "x-voter-version": App.Keys.version!,
            "x-voter-installation": App.Keys.installation!
        ]
        
        // Create a URL in the /tmp directory
        let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory().stringByAppendingString(String(target) + ".jpeg"))
        
        // save image to URL
        UIImageJPEGRepresentation(image, 1.0)?.writeToURL(imageURL, atomically: true)
        
        Alamofire.upload(
            .POST,
            App.URLs.uploadImage,
            headers:headers,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: imageURL, name: "file")
            },
            encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                        let ratio = Double(totalBytesRead)/Double(totalBytesExpectedToRead)
                        print(String(target) + " uploaded : \(ratio*100)")
                        
                        // cell.viewLeft.frame.size.height * CGFloat(question.ratioA)
                        
                        let height = (self.view.frame.height - 104) * CGFloat(ratio)
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
                                
                                if target == 0 {
                                    self.loaderLeftHeight.constant = height
                                    self.viewLoaderLeft.layoutIfNeeded()
                                    
                                    self.lblLoaderLeftBottom.constant = self.loaderLeftHeight.constant - 30
                                    self.viewLeft.layoutIfNeeded()
                                } else{
                                    self.loaderRightHeight.constant = height
                                    self.viewLoaderRight.layoutIfNeeded()
                                    
                                    self.lblLoaderRightBottom.constant = self.loaderRightHeight.constant - 30
                                    self.viewRight.layoutIfNeeded()
                                }
                                
                                
                            }), completion: nil)
                        }
                    }
                    upload.responseJSON { result in
                        print("result: \(result)")
                    }
                case .Failure(let encodingError):
                    print("fail \(encodingError)")
                }
            })
    }
    
    func crop(image originalImage: UIImage, targetScrollView: UIScrollView) -> UIImage {
        // Create a copy of the image without the imageOrientation property so it is in its native orientation (landscape)
        let contextImage: UIImage = UIImage(CGImage: originalImage.CGImage!)
        
        let posX: CGFloat
        let posY: CGFloat
        let width: CGFloat
        let height: CGFloat
        
        posX = targetScrollView.contentOffset.x
        posY = targetScrollView.contentOffset.y
        width = targetScrollView.bounds.width
        height = targetScrollView.bounds.height
        
        let rect: CGRect = CGRectMake(posX, posY, width, height)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imageRef, scale: originalImage.scale, orientation: originalImage.imageOrientation)
        
        return image
    }
    
    private var imageViewLeft = UIImageView()
    
    private var imageLeft: UIImage? {
        get { return imageViewLeft.image }
        set {
            imageViewLeft.image = newValue // change image
            imageViewLeft.sizeToFit()      // resize image with sizes
            scrollViewLeft?.contentSize = imageViewLeft.frame.size
        }
    }
    
    @IBOutlet weak var scrollViewLeft: UIScrollView! {
        didSet{
            scrollViewLeft.contentSize = imageViewLeft.frame.size
            scrollViewLeft.delegate = self
            scrollViewLeft.minimumZoomScale = 0.03
            scrollViewLeft.maximumZoomScale = 2.0
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
    
    @IBOutlet weak var scrollViewRight: UIScrollView! {
        didSet{
            scrollViewRight.contentSize = imageViewRight.frame.size
            scrollViewRight.delegate = self
            scrollViewRight.minimumZoomScale = 0.03
            scrollViewRight.maximumZoomScale = 2.0
        }
    }
    
    @IBOutlet weak var lblTags: UILabel!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgProfile.layer.cornerRadius = imgProfile.bounds.size.width / 2
        self.imgProfile.clipsToBounds = true
        
        self.scrollViewRight.addSubview(imageViewRight)
        self.scrollViewLeft.addSubview(imageViewLeft)
        
        let tapRight = UITapGestureRecognizer(target: self, action: #selector(CreateViewController.tappedRight))
        let tapLeft = UITapGestureRecognizer(target: self, action: #selector(CreateViewController.tappedLeft))
        self.scrollViewRight.addGestureRecognizer(tapRight)
        self.scrollViewLeft.addGestureRecognizer(tapLeft)
        
        self.imageLeft = UIImage(named: "tap")
        self.imageRight = UIImage(named: "tap")
        
        //let offsetX: CGFloat = max( (self.scrollViewLeft.bounds.size.width - self.scrollViewLeft.contentSize.width) * 0.5, 0.0)
        //let offsetY: CGFloat = max( (self.scrollViewLeft.bounds.size.height - self.scrollViewLeft.contentSize.height) * 0.5, 0.0)
        
        //self.imageViewLeft.center = CGPointMake(self.scrollViewLeft.contentSize.width * 0.5 + offsetX, self.scrollViewLeft.contentSize.height * 0.5 + offsetY)
        //self.imageViewRight.center = CGPointMake(self.scrollViewRight.contentSize.width * 0.5 + offsetX, self.scrollViewRight.contentSize.height * 0.5 + offsetY)
    }

    func tappedLeft(){
        target = 1
        self.getImage()
    }

    func tappedRight(){
        target = 0
        self.getImage()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        if scrollView == self.scrollViewLeft {
            return self.imageViewLeft
        } else{
            return self.imageViewRight
        }
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

                if self.target == 0 {
                    self.imageRight = image
                } else{
                    self.imageLeft = image
                }
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            self.presentViewController(cameraViewController, animated: true, completion: nil)
            
        #endif
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("didFinishPickingImage")
        
        if target == 0 {
            self.imageRight = image
        } else{
            self.imageLeft = image
        }
        
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
