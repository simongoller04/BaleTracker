//
//  CameraView.swift
//  BaleTracker
//
//  Created by Simon Goller on 08.11.23.
//

import PhotosUI
import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Binding var video: URL?
    var cameraCaptureMode: UIImagePickerController.CameraCaptureMode
    
    init(
        cameraCaptureMode: UIImagePickerController.CameraCaptureMode,
        image: Binding<UIImage?> = .constant(nil),
        video: Binding<URL?> = .constant(nil))
    {
        self.cameraCaptureMode = cameraCaptureMode
        _image = image
        _video = video
    }
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()

        if cameraCaptureMode == .video {
            picker.mediaTypes = [UTType.movie.identifier]
        } else {
            picker.mediaTypes = [UTType.image.identifier]
        }

        picker.sourceType = .camera
        picker.cameraCaptureMode = cameraCaptureMode
        picker.videoQuality = .typeHigh
        picker.delegate = context.coordinator
        
        return picker
    }

    func updateUIViewController(_: UIImagePickerController, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            picker.dismiss(animated: true)
            
            if parent.cameraCaptureMode == .video {
                guard let video = info[.mediaURL] as? URL else { return }
                parent.video = video
            } else {
                guard let image = info[.originalImage] as? UIImage else { return }
                parent.image = image
            }
        }
    }
}
