//
//  ImagePicker.swift
//  TraumJobs
//
//  Created by Marco Antonio Martiniano on 27.02.26.
//

import SwiftUI
import UIKit

// MARK: - ImagePicker: A reusable UIViewControllerRepresentable for picking images from the photo library
struct ImagePicker: UIViewControllerRepresentable {
    
    // Binding to store the selected image
    @Binding var selectedImage: UIImage?
    
    // Environment dismiss to close the picker
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Coordinator to handle UIImagePickerController delegate methods
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        // Called when the user picks an image
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage // Save selected image
            }
            parent.dismiss() // Close the picker
        }
        
        // Called when the user cancels the picker
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss() // Close the picker
        }
    }
    
    // Create the coordinator instance
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    // Create and configure the UIImagePickerController
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator // Assign the delegate
        return picker
    }
    
    // Update the UIImagePickerController (no-op in this case)
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
