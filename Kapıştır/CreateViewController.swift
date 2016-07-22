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
import SwiftyJSON
import SAConfettiView

class CreateViewController:
    UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UIScrollViewDelegate
{
    private var target = 0
    
    private var uploadedImageCount = 0
    
    private var uploadedImageUrls = [Int:String]()
    
    private var images = [Int:UIImage]()
    
    @IBOutlet weak var lblUserName: UILabel!
    
    
    @IBOutlet weak var btnAddImageLeft: UIButton!
    
    @IBAction func addImageLeft(sender: AnyObject) {
        tappedLeft()
    }
    
    @IBOutlet weak var btnAddImageRight: UIButton!
    
    @IBAction func addImageRight(sender: AnyObject) {
        tappedRight()
    }
    
    private var working = false {
        didSet{
            if working {
                self.btnSend.hidden = true
                self.indWorking.hidden = false
                self.indWorking.startAnimating()
            }
            else{
                self.indWorking.hidden = true
                self.lblLoaderLeft.hidden = true
                self.lblLoaderRight.hidden = true
                self.loaderLeftHeight.constant = 0
                self.loaderRightHeight.constant = 0
                self.btnSend.enabled = false
            }
        }
    }
    
    @IBOutlet weak var indWorking: UIActivityIndicatorView!
    
    private var settedImageCount = 0 {
        didSet{
            if settedImageCount == 2 {
                btnSend.enabled = true
                
                // get default button color
                let defaultButtonColor = UIButton(type: UIButtonType.System).titleColorForState(.Normal)!
                btnSend.setTitleColor(defaultButtonColor, forState: .Normal)
            }
        }
    }
    
    @IBOutlet weak var lblLoaderLeft: UILabel!
    
    @IBOutlet weak var lblLoaderRight: UILabel!
    
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
    
    @IBOutlet weak var btnSend: RoundedImageButton!
    
    @IBAction func add(sender: RoundedImageButton) {
        let croppedLeft = crop(image: self.imageLeft!, targetScrollView: self.scrollViewLeft)
        let croppedRight = crop(image: self.imageRight!, targetScrollView: self.scrollViewRight)

        print("\(croppedLeft.size)")
        print("\(croppedRight.size)")
        
        uploadImage(croppedLeft, target: 1)
        uploadImage(croppedRight, target: 0)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgProfile.layer.cornerRadius = imgProfile.bounds.size.width / 2
        self.imgProfile.clipsToBounds = true
        self.imgProfile.image = UserStore.user?.profileImage
        self.lblUserName.text = UserStore.user?.userName
        
        self.scrollViewRight.addSubview(imageViewRight)
        self.scrollViewLeft.addSubview(imageViewLeft)
        
        let tapRight = UITapGestureRecognizer(target: self, action: #selector(CreateViewController.tappedRight))
        let tapLeft = UITapGestureRecognizer(target: self, action: #selector(CreateViewController.tappedLeft))
        self.scrollViewRight.addGestureRecognizer(tapRight)
        self.scrollViewLeft.addGestureRecognizer(tapLeft)
        
        //self.imageLeft = UIImage(named: "tap")
        //self.imageRight = UIImage(named: "tap")
        
        // center views
        centerImageInScrollview(self.scrollViewLeft, imageView: self.imageViewLeft)
        centerImageInScrollview(self.scrollViewRight, imageView: self.imageViewRight)
        
        self.setupActionSheet()
        
        self.working = false
    }
    
    func uploadImage(image:UIImage, target: Int) {
        
        self.working = true
        
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
        
        // show progress bars and info labels
        self.lblLoaderLeft.hidden = false
        self.lblLoaderRight.hidden = false
        
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
                        
                        let height = (self.view.frame.height - 104) * CGFloat(ratio)
                        
                        dispatch_async(dispatch_get_main_queue()) {

                            UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
                                
                                if target == 0 {
                                    self.loaderLeftHeight.constant = height
                                    self.viewLoaderLeft.layoutIfNeeded()
                                    
                                    self.lblLoaderLeftBottom.constant = self.loaderLeftHeight.constant - 30
                                    self.viewLeft.layoutIfNeeded()
                                    self.lblLoaderLeft.text = "Yükleniyor %\(Int(ratio*100.0))"
                                } else{
                                    self.loaderRightHeight.constant = height
                                    self.viewLoaderRight.layoutIfNeeded()
                                    
                                    self.lblLoaderRightBottom.constant = self.loaderRightHeight.constant - 30
                                    self.viewRight.layoutIfNeeded()
                                    self.lblLoaderRight.text = "Yükleniyor %\(Int(ratio*100.0))"
                                }
                                
                            }), completion: nil)
                        }
                    }
                    upload.responseJSON { response in
                        print("result: \(response)")
                        
                        
                        switch response.result {
                        case .Success(let data):
                            let responseData = JSON(data)
                            
                            // cloudinary timed-out
                            if responseData["statusCode"] == 408 {
                                print("cloudinary timedout")
                                
                                UIView.animateWithDuration(0.6, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
                                        if target == 0 {
                                            self.loaderLeftHeight.constant = 0
                                            self.viewLoaderLeft.layoutIfNeeded()
                                    
                                            self.lblLoaderLeftBottom.constant = self.loaderLeftHeight.constant - 30
                                            self.viewLeft.layoutIfNeeded()
                                            self.lblLoaderLeft.text = "Tekrar Yükleniyor"
                                        } else{
                                            self.loaderRightHeight.constant = 0
                                            self.viewLoaderRight.layoutIfNeeded()
                                    
                                            self.lblLoaderRightBottom.constant = self.loaderRightHeight.constant - 30
                                            self.viewRight.layoutIfNeeded()
                                            self.lblLoaderRight.text = "Tekrar Yükleniyor"
                                        }
                                    }), completion: nil)
                                
                                self.uploadImage(image, target: target)
                                return
                            }
                            
                            self.uploadedImageCount += 1
                            self.uploadedImageUrls[target] = responseData["data"].stringValue
                            self.images[target] = image
                        
                            if self.uploadedImageCount == 2 {
                                
                                // image yüklemeleri tamamlandı
                                // soruyu kaydet
                                
                                Api.saveQuestion(
                                    imageUrls: (self.uploadedImageUrls[1]!, self.uploadedImageUrls[0]!),
                                    images: (self.images[1]!, self.images[0]!),
                                    errorCallback: {
                                        //print("question save error")
                                    },
                                    successCallback: { (question) in
                                        print("question saved \(question)")
                                        
                                        App.Play.Applause()
                                        
                                        self.working = false
                                        
                                        //question.imageLeft = self.images[0]
                                        //question.imageRight = self.images[1]
                                        QuestionStore.insertCurrentQuestion(question)
                                        
                                        let view = ModalSaveQuestionSuccess.instantiateFromNib()
                                        let window = UIApplication.sharedApplication().delegate?.window!
                                        let modal = PathDynamicModal.show(modalView: view, inView: window!)
                                        view.closeButtonHandler = {[weak modal] in
                                            modal?.closeWithLeansRandom()
                                            self.dismissViewControllerAnimated(true, completion: {
                                                print("question/created")
                                                App.Play.Stop()
                                                Publisher.publish("question/created", data: nil)
                                            })
                                            return
                                        }
                                        modal.closedHandler = {
                                            print("modal closed")
                                            self.dismissViewControllerAnimated(true, completion: {
                                                print("question/created")
                                                App.Play.Stop()
                                                Publisher.publish("question/created", data: nil)
                                            })
                                        }
                                    })
                            }
                        case .Failure(_):
                            print("question save error")
                        }
                    }
                case .Failure(let encodingError):
                    print("fail \(encodingError)")
                }
            })
    }
    
    func crop(image originalImage: UIImage, targetScrollView: UIScrollView) -> UIImage {
        let scale = UIScreen.mainScreen().scale
        let posX = targetScrollView.contentOffset.x * scale
        let posY = targetScrollView.contentOffset.y * scale
        let width = min( scale * targetScrollView.bounds.width, originalImage.scale * originalImage.size.width )
        let height = min( scale * targetScrollView.bounds.height, originalImage.scale * originalImage.size.height )
        
        let rect: CGRect = CGRectMake(posX, posY, width, height)
        
        print("crop rect \(rect)")
        
        // Create bitmap image from context using the rect
        let imageResized = resizeImage(originalImage, newWidth: width * targetScrollView.zoomScale )
        
        print("resized width: \(imageResized.size), image scale: \(imageResized.scale)")
        
        let imageCropped = CGImageCreateWithImageInRect(imageResized.CGImage, rect)!
        // let imageCroppedResized = resizeImage( UIImage(CGImage: imageCropped), newWidth: width)
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image = UIImage(CGImage: imageCropped)
        
        return image
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    private var imageViewLeft = UIImageView()
    
    private var imageLeft: UIImage? {
        get { return imageViewLeft.image }
        set {
            setImage(newValue!, scrollView: self.scrollViewLeft, imageView: self.imageViewLeft)
        }
    }
    
    func setImage(image: UIImage, scrollView: UIScrollView, imageView: UIImageView) {
        imageView.image = image                 // change image
        imageView.contentMode = .ScaleToFill    //.ScaleAspectFit
        
        let widthImage = scrollView.frame.size.width
        let scaleImage = image.size.width * image.scale / widthImage
        let heightImage = image.size.height * image.scale / scaleImage
        let imageSize = CGSize(width: widthImage, height: heightImage)
        
        imageView.frame.size = imageSize        //scrollViewLeft.frame.size
        
        scrollView.contentSize = imageView.frame.size
        centerImageInScrollview(scrollView, imageView: imageView)
    }
    
    @IBOutlet weak var scrollViewLeft: UIScrollView! {
        didSet{
            scrollViewLeft.contentSize = imageViewLeft.frame.size
            scrollViewLeft.delegate = self
            scrollViewLeft.minimumZoomScale = 1
            scrollViewLeft.maximumZoomScale = 3.0
        }
    }
    
    private var imageViewRight = UIImageView()
    
    private var imageRight: UIImage? {
        get { return imageViewRight.image }
        set {
            setImage(newValue!, scrollView: self.scrollViewRight, imageView: self.imageViewRight)
        }
    }
    
    @IBOutlet weak var scrollViewRight: UIScrollView! {
        didSet{
            scrollViewRight.contentSize = imageViewRight.frame.size
            scrollViewRight.delegate = self
            scrollViewRight.minimumZoomScale = 1
            scrollViewRight.maximumZoomScale = 3.0
        }
    }
    
    @IBOutlet weak var lblTags: UILabel!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    private var actionSheet: UIAlertController!
    
    func setupActionSheet() {
        actionSheet = UIAlertController(title: nil, message: "Resim Ekle", preferredStyle: .ActionSheet)
        
        let actionTakePhoto = UIAlertAction(title: "Fotoğraf Çek", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        })
        
        let actionSelectPhoto = UIAlertAction(title: "Galeriden Seç", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        })
        
        let actionCancel = UIAlertAction(title: "İptal", style: .Cancel, handler: nil)
        
        //let actionSearchWeb = UIAlertAction(title: "Ara", style: .Default, handler: {
        //    (alert: UIAlertAction!) -> Void in
            // search
        //})
        
        actionSheet.addAction(actionSelectPhoto)
        actionSheet.addAction(actionTakePhoto)
        actionSheet.addAction(actionCancel)
        //actionSheet.addAction(actionSearchWeb)
    }
    
    func centerImageInScrollview(scrollView: UIScrollView, imageView: UIImageView) {
        let offsetX: CGFloat = max( (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY: CGFloat = max( (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)
        
        imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY)
    }

    func tappedLeft(){
        target = 1
        actionSheet.message = "← Resim Ekle"
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }

    func tappedRight(){
        target = 0
        actionSheet.message = "Resim Ekle →"
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        if scrollView == self.scrollViewLeft {
            centerImageInScrollview(self.scrollViewLeft, imageView: self.imageViewLeft)
        } else {
            centerImageInScrollview(self.scrollViewRight, imageView: self.imageViewRight)
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        if scrollView == self.scrollViewLeft {
            return self.imageViewLeft
        } else{
            return self.imageViewRight
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("didFinishPickingImage")
        
        if target == 0 {
            self.imageRight = image
            self.btnAddImageRight.hidden = true
        } else{
            self.imageLeft = image
            self.btnAddImageLeft.hidden = true
        }
        
        self.settedImageCount += 1
        
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
