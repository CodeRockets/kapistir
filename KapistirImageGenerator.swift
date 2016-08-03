//
//  KapistirImageGenerator.swift
//  Kapıştır
//
//  Created by Evren Yortuçboylu on 02/08/16.
//  Copyright © 2016 Evren Yortuçboylu. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class KapistirImageGenerator {
    
    private var leftImage: UIImage!
    private var rightImage: UIImage!
    private var answer: Answer?
    private var leftRect: CGRect
    private var rightRect: CGRect
    
    init(leftRect: CGRect, rightRect: CGRect, leftImage: UIImage, rightImage: UIImage, answer: Answer?) {
        self.leftImage = leftImage
        self.rightImage = rightImage
        self.leftRect = leftRect
        self.rightRect = rightRect
        self.answer = answer
    }
    
    private func resizeRect(rect: CGRect, byPercentage percentage: CGFloat) -> CGRect {
        let startWidth = CGRectGetWidth(rect)
        let startHeight = CGRectGetHeight(rect)
        let adjustmentWidth = (startWidth * percentage) / 2.0
        let adjustmentHeight = (startHeight * percentage) / 2.0
        return CGRectInset(rect, -adjustmentWidth, -adjustmentHeight)
    }

    func generateImage() -> UIImage {
       
        let checkImage = UIImage(named: "vote_check.png")!
        
        // pixel-density scale target rect
        self.leftRect = resizeRect(self.leftRect, byPercentage: 2)
        self.rightRect = resizeRect(self.rightRect, byPercentage: 2)

        let leftFit = AVMakeRectWithAspectRatioInsideRect(self.leftImage.size, self.leftRect)
        let rightFit = AVMakeRectWithAspectRatioInsideRect(self.rightImage.size, self.rightRect)
        
        let kapistirSize = CGSize(
            width: leftRect.size.width + rightRect.size.width,
            height: self.leftRect.size.height)

        UIGraphicsBeginImageContext(kapistirSize)
        
        self.leftImage.drawInRect(CGRect(
            x: 0,
            y: (kapistirSize.height - leftFit.size.height)/2,
            width: leftFit.size.width,
            height: leftFit.size.height))
        
        self.rightImage.drawInRect(CGRect(
            x: leftFit.size.width,
            y: (kapistirSize.height - rightFit.size.height)/2,
            width: rightFit.size.width,
            height: rightFit.size.height))
        
        // draw vote checkmark if exist
        if let hasAnswer = self.answer {
            var voteCheckSize:CGRect?
            let checkWidth = leftFit.size.width / 2
            
            switch hasAnswer {
            case .Left:
                voteCheckSize = CGRect(
                    x: (kapistirSize.width/2 - checkWidth)/2,
                    y: (kapistirSize.height-checkWidth)/2,
                    width: checkWidth,
                    height: checkWidth)
                break
            case .Right:
                voteCheckSize = CGRect(
                    x: kapistirSize.width/2 + (kapistirSize.width/2 - checkWidth)/2,
                    y: (kapistirSize.height-checkWidth)/2,
                    width: checkWidth,
                    height: checkWidth)
                break
            default:
                break
            }
            checkImage.drawInRect(voteCheckSize!, blendMode: CGBlendMode.Normal, alpha: 0.85)
        }
        
        let kapistirImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return kapistirImage
    }
}