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
    
    var input: PHContentEditingInput?

    // MARK: - Input selection objects
    
    let testButton = ParameterSelectionObject(imageName: "testImage") {
        println("Doing something useful")
    }
    
    // MARK: - CollectionView properties
    var parameterSelectionObjects: [ParameterSelectionObject] = []
    let parameterSelectionCellIdentifier = "parameterSelectionCell"
    
    // MARK: - PhotoEditingViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        parameterSelectionObjects.append(testButton)
        
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
            
            // Provide new adjustments and render output to given location.
            // output.adjustmentData = <#new adjustment data#>
            // let renderedJPEGData = <#output JPEG#>
            // renderedJPEGData.writeToURL(output.renderedContentURL, atomically: true)
            
            // Call completion handler to commit edit to Photos.
            completionHandler?(output)
            
            // Clean up temporary files, etc.
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
    }

}

extension PhotoEditingViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(parameterSelectionCellIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        
        let object = parameterSelectionObjects[indexPath.row]
        
        if let image = UIImage(named: object.imageName) {
            cell.contentView.addSubview(UIImageView(image: image))
        } else {
            println("Image could not be loaded or wasn't found")
            
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
        let object = parameterSelectionObjects[indexPath.row]
        
        object.action()
    }
}
