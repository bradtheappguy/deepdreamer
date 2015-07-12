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

    // Image view which displays image before and after editing
    @IBOutlet weak var imageView: UIImageView!
    
    // Collection view which contains parameter selection icons
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Image view which gets animated with three robot loading images
    @IBOutlet weak var robotLoadingAnimationView: UIImageView!
    
    // Constraint used for animating robot loading screen
    @IBOutlet weak var robotCenterConstraint: NSLayoutConstraint!
    
    // Input recieved when extension is launched
    var input: PHContentEditingInput?
    
    // Style to be sent to the server to decide which parameters the Deep Dream program should use
    var styleSelected: Int?
    
    // True when a parameter selection button has been tapped but the server hasn't returned yet. When true no new requests can be sent to the server.
    var isWaitingForServer = false
    
    // Parameter selection objects which appear in the collection view at the bottom of the screen
    let button1 = ParameterSelectionObject(imageName: "ParameterSelection1", style: 1)
    let button2 = ParameterSelectionObject(imageName: "ParameterSelection2", style: 2)
    let button3 = ParameterSelectionObject(imageName: "ParameterSelection3", style: 3)
    let button4 = ParameterSelectionObject(imageName: "ParameterSelection4", style: 4)
    let button5 = ParameterSelectionObject(imageName: "ParameterSelection5", style: 5)
    let button6 = ParameterSelectionObject(imageName: "ParameterSelection6", style: 6)
    
    // Images which are used for animating the robotLoadingAnimationView
    let robotLoadingImage1 = UIImage(named: "RobotLoadingFrame1")
    let robotLoadingImage2 = UIImage(named: "RobotLoadingFrame2")
    let robotLoadingImage3 = UIImage(named: "RobotLoadingFrame3")
    let robotLoadingImage4 = UIImage(named: "RobotLoadingFrame4")
    
    // MARK: - CollectionView properties
    
    // An array containing the parameter selection objects. Acts as the data source array for the parameter selection collection view. Make sure to add the ParameterSelectionObjects within ViewDidLoad.
    var parameterSelectionObjects: [ParameterSelectionObject] = []
    
    // Identifier for parameterSelectionCells
    let parameterSelectionCellIdentifier = "parameterSelectionCell"
    
    // MARK: - PhotoEditingViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Adding parameter selection objects to data source
        parameterSelectionObjects = [button1, button2, button3, button4, button5, button6]
        
        collectionView.reloadData()
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
                
                // Technically it's better to use the full image from the input object and send it to the server to get back a better quality image but as it is getting shrunk down anyway before getting sent to server and since this avoids sending another request to the server, the imageView.image is used anyway.
                
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
        if let image1 = robotLoadingImage1, image2 = robotLoadingImage2, image3 = robotLoadingImage3, image4 = robotLoadingImage4 {
            let images = [image1, image2, image3, image4]
            
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
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(parameterSelectionCellIdentifier, forIndexPath: indexPath) as! ParameterSelectionCell
        
        let object = parameterSelectionObjects[indexPath.row]
        
        if let image = UIImage(named: object.imageName) {
            cell.imageView?.image = image
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
        if isWaitingForServer == false {
            if let inputImage = self.input?.displaySizeImage {
                let object = parameterSelectionObjects[indexPath.row]
                
                let deepDream = DeepDreamAPIClient.sharedClient()
                
                self.isWaitingForServer = true
                
                startLoadingAnimation()
                deepDream.requestDeepDreamImageUsingImage(inputImage, withStyle: Int32(object.style)) { outputImage in
                    self.imageView.image = outputImage
                    self.styleSelected = object.style
                    self.isWaitingForServer = false
                    self.stopLoadingAnimation()
                }
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}
