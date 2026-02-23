import SwiftUI
import Mantis

struct ImageCropperView: UIViewControllerRepresentable {
    
    var image: UIImage
    var onCropped: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIViewController {
        
        var config = Mantis.Config()
        config.cropShapeType = .circle(maskOnly: false)
        
        let cropViewController = Mantis.cropViewController(
            image: image,
            config: config
        )
        
        cropViewController.delegate = context.coordinator
        return cropViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, CropViewControllerDelegate {
        
        let parent: ImageCropperView
        
        init(_ parent: ImageCropperView) {
            self.parent = parent
        }
        
        func cropViewControllerDidCrop(
            _ cropViewController: CropViewController,
            cropped: UIImage,
            transformation: Transformation,
            cropInfo: CropInfo
        ) {
            parent.onCropped(cropped)
            cropViewController.dismiss(animated: true)
        }
        
        func cropViewControllerDidCancel(
            _ cropViewController: CropViewController,
            original: UIImage
        ) {
            cropViewController.dismiss(animated: true)
        }
        
        func cropViewControllerDidFailToCrop(
            _ cropViewController: CropViewController,
            original: UIImage
        ) {
            cropViewController.dismiss(animated: true)
        }
        
        func cropViewControllerDidBeginResize(_ cropViewController: CropViewController) { }
        
        func cropViewControllerDidEndResize(
            _ cropViewController: CropViewController,
            original: UIImage,
            cropInfo: CropInfo
        ) { }
    }
}
