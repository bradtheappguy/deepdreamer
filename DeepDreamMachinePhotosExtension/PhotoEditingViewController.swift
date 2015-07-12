//
//  PhotoEditingViewController.swift
//  DeepDreamMachinePhotosExtension
//
//  Created by Isaac Arvestad on 11/07/15.
//  Copyright (c) 2015 Jet. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class PhotoEditingViewController: UIViewController, PHContentEditingController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var robotLoadingAnimationView: UIImageView!
    @IBOutlet weak var robotCenterConstraint: NSLayoutConstraint!
    
    var input: PHContentEditingInput?
    var styleSelected: Int?
    
    let testButton = ParameterSelectionObject(imageName: "testImage", style: 1)
    
    let robotLoadingImage1 = UIImage(named: "RobotLoadingFrame1")
    let robotLoadingImage2 = UIImage(named: "RobotLoadingFrame2")
    let robotLoadingImage3 = UIImage(named: "RobotLoadingFrame3")
    
    // MARK: - CollectionView properties
    var parameterSelectionObjects: [ParameterSelectionObject] = []
    let parameterSelectionCellIdentifier = "parameterSelectionCell"
    
    // MARK: - PhotoEditingViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        parameterSelectionObjects.append(testButton)
        
        //thoughtBubble.collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - PHContentEditingController

    func canHandleAdjustmentData(adjustmentData: PHAdjustmentData?) -> Bool {
        // Inspect the adjustmentData to determine whether your extension can work with past edits.
        // (Typically, you use its formatIdentifier and formatVersion properties to do this.)
        return false
    }

    func startContentEditingWithInput(contentEditingInput: PHContentEditingInput?, placeholderImage: UIImage) {
        // Present content for editing, and keep the contentEditingInput for use when closing the edit session.
        // If you returned YES from canHandleAdjustmentData:, contentEditingInput has the original image and adjustment data.
        // If you returned NO, the contentEditingInput has past edits "baked in".
        input = contentEditingInput
        
        imageView.image = input?.displaySizeImage
    }

    func finishContentEditingWithCompletionHandler(completionHandler: ((PHContentEditingOutput!) -> Void)!) {
        // Update UI to reflect that editing has finished and output is being rendered.
        
        // Render and provide output on a background queue.
        dispatch_async(dispatch_get_global_queue(CLong(DISPATCH_QUEUE_PRIORITY_DEFAULT), 0)) {
            // Create editing output from the editing input.
            let output = PHContentEditingOutput(contentEditingInput: self.input)
            
            if let style = self.styleSelected {
                
                let archivedData = NSKeyedArchiver.archivedDataWithRootObject("Deep dream with style: \(style)")
                let identifier = "Deep dream"
                let version = "0.1"
                let adjustmentData = PHAdjustmentData(formatIdentifier: identifier, formatVersion: version, data: archivedData)
                
                output.adjustmentData = adjustmentData
                
                if let finalImage = self.imageView.image {
                    let jpegData = UIImageJPEGRepresentation(finalImage, 1.0)
                    
                    var error: NSError?
                    jpegData.writeToURL(output.renderedContentURL, options: .DataWritingAtomic, error: &error)
                    if let error = error {
                        println(error)
                        completionHandler(nil)
                    }
                    
                    completionHandler(output)
                } else {
                    println("No image found when attempting to save")
                    completionHandler(nil)
                }
            } else {
                println("No style selected")
                completionHandler(nil)
            }
        }
    }

    var shouldShowCancelConfirmation: Bool {
        // Determines whether a confirmation to discard changes should be shown to the user on cancel.
        // (Typically, this should be "true" if there are any unsaved changes.)
        return true
    }

    func cancelContentEditing() {
        // Clean up temporary files, etc.
        // May be called after finishContentEditingWithCompletionHandler: while you prepare output.
        
        stopLoadingAnimation()
    }
    
    func startLoadingAnimation() {
        if let image1 = robotLoadingImage1, image2 = robotLoadingImage2, image3 = robotLoadingImage3 {
            let images = [image1, image2, image3]
            
            robotLoadingAnimationView.hidden = false
            self.robotLoadingAnimationView.animationImages = images
            self.robotLoadingAnimationView.animationDuration = 1.0
            self.robotLoadingAnimationView.startAnimating()
            
            robotCenterConstraint.constant = 0
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseIn, animations: { self.view.layoutIfNeeded() }) { success in
                
            }
        }
    }

    func stopLoadingAnimation() {
        
        robotCenterConstraint.constant = 500
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseIn, animations: { self.view.layoutIfNeeded() }) { success in
            self.robotLoadingAnimationView.stopAnimating()
            self.robotLoadingAnimationView.hidden = true
            self.robotCenterConstraint.constant = -500
            self.view.layoutIfNeeded()
        }
    }
}

extension PhotoEditingViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(parameterSelectionCellIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        
        let object = parameterSelectionObjects[indexPath.row]
        
        if let image = UIImage(named: object.imageName) {
            cell.contentView.addSubview(UIImageView(image: image))
        } else {
            println("Icon for cell could not be loaded or wasn't found")
            
            cell.backgroundColor = UIColor.redColor()
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return parameterSelectionObjects.count
    }
}

extension PhotoEditingViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let inputImage = self.input?.displaySizeImage {
            let object = parameterSelectionObjects[indexPath.row]

            let deepDream = DeepDreamAPIClient.sharedClient()
            
            startLoadingAnimation()
            deepDream.requestDeepDreamImageUsingImage(inputImage, withStyle: Int32(object.style)) { outputImage in
                self.imageView.image = outputImage
                self.styleSelected = object.style
                self.stopLoadingAnimation()
            }
        }
    }
}
