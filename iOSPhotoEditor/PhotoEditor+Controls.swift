//
//  PhotoEditor+Controls.swift
//  Pods
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import Foundation
import UIKit

// MARK: - Control
public enum control {
    case crop
    case sticker
    case draw
    case text
    case rotate
    case save
    case share
    case clear
}

extension PhotoEditorViewController {

     //MARK: Top Toolbar
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        photoEditorDelegate?.canceledEditing()
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cropButtonTapped(_ sender: UIButton) {
        let controller = CropViewController()
        controller.delegate = self
        controller.image = image
        let navController = UINavigationController(rootViewController: controller)
        
        // Ensure navigation bar is opaque with proper styling
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.backgroundColor = UIColor.black
        navController.navigationBar.barTintColor = UIColor.black
        navController.navigationBar.tintColor = UIColor.white
        
        present(navController, animated: true, completion: nil)
    }

    @IBAction func stickersButtonTapped(_ sender: Any) {
        addStickersViewController()
    }

    @IBAction func drawButtonTapped(_ sender: Any) {
        isDrawing = true
        canvasImageView.isUserInteractionEnabled = false
        doneButton.isHidden = false
        colorPickerView.isHidden = false
        hideToolbar(hide: true)
    }

    @IBAction func textButtonTapped(_ sender: Any) {
        isTyping = true
        let textView = UITextView(frame: CGRect(x: 0, y: canvasImageView.center.y,
                                                width: UIScreen.main.bounds.width, height: 30))
        
        textView.textAlignment = .center
        textView.font = UIFont(name: "Helvetica", size: 30)
        textView.textColor = textColor
        textView.layer.shadowColor = UIColor.black.cgColor
        textView.layer.shadowOffset = CGSize(width: 1.0, height: 0.0)
        textView.layer.shadowOpacity = 0.2
        textView.layer.shadowRadius = 1.0
        textView.layer.backgroundColor = UIColor.clear.cgColor
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.delegate = self
        self.canvasImageView.addSubview(textView)
        addGestures(view: textView)
        textView.becomeFirstResponder()
    }    
    
    @IBAction func rotateButtonTapped(_ sender: Any) {
        guard let image = self.image else { return }
        
        // Rotate the full resolution image 90 degrees clockwise
        let rotatedImage = image.rotate(radians: .pi / 2)
        
        // Rotate the drawing layer as well
        rotateDrawingLayer()
        
        // Update the image view
        setImageView(image: rotatedImage)
        self.image = rotatedImage
        hasImageBeenModified = true
    }
    
    private func rotateDrawingLayer() {
        // Rotate the drawing image if it exists
        if let drawingImage = canvasImageView.image {
            let rotatedDrawing = drawingImage.rotate(radians: .pi / 2)
            canvasImageView.image = rotatedDrawing
        }
        
        // Rotate and reposition all subviews (text, stickers)
        let centerX = canvasImageView.bounds.width / 2
        let centerY = canvasImageView.bounds.height / 2
        
        for subview in canvasImageView.subviews {
            // Get current position relative to center
            let currentCenter = subview.center
            let relativeX = currentCenter.x - centerX
            let relativeY = currentCenter.y - centerY
            
            // Apply 90-degree clockwise rotation: (x,y) -> (-y,x)
            let newRelativeX = -relativeY
            let newRelativeY = relativeX
            
            // Set new position
            subview.center = CGPoint(x: centerX + newRelativeX, y: centerY + newRelativeY)
            
            // Rotate the subview itself 90 degrees clockwise
            subview.transform = subview.transform.rotated(by: .pi / 2)
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        view.endEditing(true)
        doneButton.isHidden = true
        colorPickerView.isHidden = true
        canvasImageView.isUserInteractionEnabled = true
        hideToolbar(hide: false)
        isDrawing = false
    }
    
    //MARK: Bottom Toolbar
    
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(createHighResolutionImage(),self, #selector(PhotoEditorViewController.image(_:withPotentialError:contextInfo:)), nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        let activity = UIActivityViewController(activityItems: [createHighResolutionImage()], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
        
    }
    
    @IBAction func clearButtonTapped(_ sender: AnyObject) {
        //clear drawing
        canvasImageView.image = nil
        //clear stickers and textviews
        for subview in canvasImageView.subviews {
            subview.removeFromSuperview()
        }
        
        // Restore original image (undo crops and rotations)
        if let originalImage = originalImage {
            setImageView(image: originalImage)
            self.image = originalImage
        }
        
        // Reset modification state
        hasImageBeenModified = false
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        if hasImageBeenModified {
            // Image was modified, process and return high-resolution edited image
            let img = createHighResolutionImage()
            Task { @MainActor in
                do {
                    // Call delegate to handle the edited image
                    try? await photoEditorDelegate?.doneEditing(image: img)
                }catch {
                    // Handle any errors that may occur during delegate call
                    print("Error in doneEditing: \(error)")
                }
            }
        }
        // If no changes made, just dismiss without calling delegate (like cancel/close)
        
        self.dismiss(animated: true, completion: nil)
    }

    //MAKR: helper methods
    
    @objc func image(_ image: UIImage, withPotentialError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(title: "Image Saved", message: "Image successfully saved to Photos library", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func hideControls() {
        for control in hiddenControls {
            switch control {
                
            case .clear:
                clearButton.isHidden = true
            case .crop:
                cropButton.isHidden = true
            case .draw:
                drawButton.isHidden = true
            case .save:
                saveButton.isHidden = true
            case .share:
                shareButton.isHidden = true
            case .sticker:
                stickerButton.isHidden = true
            case .text:
                textButton.isHidden = true
            case .rotate:
                rotateButton.isHidden = true
            }
        }
    }
    
}
