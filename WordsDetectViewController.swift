//
//  WordsDetectViewController.swift
//  MySpellBee
//
//  Created by Ravi Theja Karnatakam on 12/29/22.
//

import CoreGraphics
import UIKit
import MLKitTextRecognition
import MLKitVision

class WordsDetectViewController: UIViewController {
    /// A string holding current results from detection.
    var resultsText = ""
    var category = ""

    /// An overlay view that displays detection annotations.
    private lazy var annotationOverlayView: UIView = {
      precondition(isViewLoaded)
      let annotationOverlayView = UIView(frame: .zero)
      annotationOverlayView.translatesAutoresizingMaskIntoConstraints = false
      annotationOverlayView.clipsToBounds = true
      return annotationOverlayView
    }()

    // Image counter.
    var currentImage = 0

    let imageButton = UIButton(frame: .zero)
    let imagePicker = UIImagePickerController()
    let imageView = UIImageView(frame: .zero)
    let detectButton = UIButton(frame: .zero)
    let cameraRollButton = UIButton(frame: .zero)


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        setUp()
    }
    
    func setUp() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.lightGray
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.addSubview(annotationOverlayView)

        imageButton.translatesAutoresizingMaskIntoConstraints = false
        imageButton.backgroundColor = UIColor.blue
        imageButton.setTitle("Capture Image", for: .normal)
        imageButton.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        view.addSubview(imageButton)
        
        cameraRollButton.translatesAutoresizingMaskIntoConstraints = false
        cameraRollButton.backgroundColor = UIColor.blue
        cameraRollButton.setTitle("Camera Roll", for: .normal)
        cameraRollButton.addTarget(self, action: #selector(openPhotoLibrary), for: .touchUpInside)
        view.addSubview(cameraRollButton)

        detectButton.translatesAutoresizingMaskIntoConstraints = false
        detectButton.backgroundColor = UIColor.blue
        detectButton.setTitle("Detect Text", for: .normal)
        detectButton.addTarget(self, action: #selector(detect), for: .touchUpInside)
        view.addSubview(detectButton)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -150),
            imageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            imageButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            imageButton.heightAnchor.constraint(equalToConstant: 45),
            
            cameraRollButton.leadingAnchor.constraint(equalTo: imageButton.trailingAnchor, constant: 10),
            cameraRollButton.trailingAnchor.constraint(equalTo: detectButton.leadingAnchor, constant: -10),
            cameraRollButton.bottomAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 0),
            cameraRollButton.heightAnchor.constraint(equalTo: imageButton.heightAnchor),

            detectButton.leadingAnchor.constraint(equalTo: cameraRollButton.trailingAnchor, constant: 10),
            detectButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            detectButton.bottomAnchor.constraint(equalTo: imageButton.bottomAnchor, constant: 0),
            detectButton.heightAnchor.constraint(equalTo: imageButton.heightAnchor),
            imageButton.widthAnchor.constraint(equalTo: detectButton.widthAnchor),
            annotationOverlayView.topAnchor.constraint(equalTo: imageView.topAnchor),
            annotationOverlayView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            annotationOverlayView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            annotationOverlayView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
        ])
        
        imagePicker.delegate = self
    }
    
    @objc func openPhotoLibrary(_ sender: Any) {
      imagePicker.sourceType = .photoLibrary
      present(imagePicker, animated: true)
    }

    @objc func openCamera() {
        guard (UIImagePickerController.isCameraDeviceAvailable(.front) ||
               UIImagePickerController.isCameraDeviceAvailable(.rear)) else { return }
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    @objc func detect(_ sender: Any) {
      clearResults()
      detectTextOnDevice(image: imageView.image)
    }


}

extension WordsDetectViewController {
    private func clearResults() {
      removeDetectionAnnotations()
      self.resultsText = ""
    }

    private func removeDetectionAnnotations() {
      for annotationView in annotationOverlayView.subviews {
        annotationView.removeFromSuperview()
      }
    }
    
    
    private func showResults() {
        
        let wordsVC = AddWordsViewController(nibName: nil, bundle: nil)
        navigationController?.pushViewController(wordsVC, animated: true)
        wordsVC.setupWords(with: resultsText, to: category)
        
        /*
         let resultsAlertController = UIAlertController(
           title: "Detection Results",
           message: nil,
           preferredStyle: .actionSheet
         )
         resultsAlertController.addAction(
           UIAlertAction(title: "OK", style: .destructive) { _ in
             resultsAlertController.dismiss(animated: true, completion: nil)
           }
         )
         resultsAlertController.message = resultsText
   //      resultsAlertController.popoverPresentationController?.barButtonItem = detectButton
         resultsAlertController.popoverPresentationController?.sourceView = self.view
         present(resultsAlertController, animated: true, completion: nil)
         print(resultsText)
         */
        print(resultsText)

    }
}

/// Extension of WordsDetectViewController for On-Device detection.
extension WordsDetectViewController {
  private func detectTextOnDevice(image: UIImage?) {
    guard let image = image else { return }
      let latinOptions = TextRecognizerOptions()
      let latinTextRecognizer = TextRecognizer.textRecognizer(options:latinOptions)
      let visionImage = VisionImage(image: image)
      visionImage.orientation = image.imageOrientation
      process(visionImage, with: latinTextRecognizer)
  }
}

// MARK: - Enums

private enum Constants {
  static let images = ["image_has_text.jpg"]
  static let detectionNoResultsMessage = "No results returned."
  static let failedToDetectObjectsMessage = "Failed to detect objects in image."
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKeyDictionary(
  _ input: [UIImagePickerController.InfoKey: Any]
) -> [String: Any] {
  return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey)
  -> String
{
  return input.rawValue
}


// MARK: - UIImagePickerControllerDelegate

extension WordsDetectViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            updateImageView(with: pickedImage)
        }
        dismiss(animated: true)
    }
}

extension WordsDetectViewController {
    private func updateImageView(with image: UIImage) {
        
      weak var weakSelf = self
        DispatchQueue.main.async {
          weakSelf?.imageView.image = image
        }

        /**
         let orientation = UIApplication.shared.statusBarOrientation
         var scaledImageWidth: CGFloat = 0.0
         var scaledImageHeight: CGFloat = 0.0
         switch orientation {
         case .portrait, .portraitUpsideDown, .unknown:
           scaledImageWidth = imageView.bounds.size.width
           scaledImageHeight = image.size.height * scaledImageWidth / image.size.width
         case .landscapeLeft, .landscapeRight:
           scaledImageWidth = image.size.width * scaledImageHeight / image.size.height
           scaledImageHeight = imageView.bounds.size.height
         @unknown default:
           fatalError()
         }
           
         weak var weakSelf = self
         DispatchQueue.global(qos: .userInitiated).async {
           // Scale image while maintaining aspect ratio so it displays better in the UIImageView.
           var scaledImage = image.scaledImage(with: CGSize(width: scaledImageWidth, height: scaledImageHeight))
           scaledImage = scaledImage ?? image
           guard let finalImage = scaledImage else { return }
           DispatchQueue.main.async {
             weakSelf?.imageView.image = finalImage
           }
         }

         */
        
        
        
    }
    
    private func transformMatrix() -> CGAffineTransform {
      guard let image = imageView.image else { return CGAffineTransform() }
      let imageViewWidth = imageView.frame.size.width
      let imageViewHeight = imageView.frame.size.height
      let imageWidth = image.size.width
      let imageHeight = image.size.height

      let imageViewAspectRatio = imageViewWidth / imageViewHeight
      let imageAspectRatio = imageWidth / imageHeight
      let scale =
        (imageViewAspectRatio > imageAspectRatio)
        ? imageViewHeight / imageHeight : imageViewWidth / imageWidth

      // Image view's `contentMode` is `scaleAspectFit`, which scales the image to fit the size of the
      // image view by maintaining the aspect ratio. Multiple by `scale` to get image's original size.
      let scaledImageWidth = imageWidth * scale
      let scaledImageHeight = imageHeight * scale
      let xValue = (imageViewWidth - scaledImageWidth) / CGFloat(2.0)
      let yValue = (imageViewHeight - scaledImageHeight) / CGFloat(2.0)

      var transform = CGAffineTransform.identity.translatedBy(x: xValue, y: yValue)
      transform = transform.scaledBy(x: scale, y: scale)
      return transform
    }

    private func pointFrom(_ visionPoint: VisionPoint) -> CGPoint {
      return CGPoint(x: visionPoint.x, y: visionPoint.y)
    }

    private func process(_ visionImage: VisionImage, with textRecognizer: TextRecognizer?) {
      weak var weakSelf = self
      textRecognizer?.process(visionImage) { text, error in
        guard let strongSelf = weakSelf else {
          print("Self is nil!")
          return
        }
        guard error == nil, let text = text else {
          let errorString = error?.localizedDescription ?? Constants.detectionNoResultsMessage
          strongSelf.resultsText = "Text recognizer failed with error: \(errorString)"
          strongSelf.showResults()
          return
        }
        // Blocks.
        for block in text.blocks {
          let transformedRect = block.frame.applying(strongSelf.transformMatrix())
          UIUtilities.addRectangle(
            transformedRect,
            to: strongSelf.annotationOverlayView,
            color: UIColor.purple
          )

          // Lines.
          for line in block.lines {
            let transformedRect = line.frame.applying(strongSelf.transformMatrix())
            UIUtilities.addRectangle(
              transformedRect,
              to: strongSelf.annotationOverlayView,
              color: UIColor.orange
            )

            // Elements.
            for element in line.elements {
              let transformedRect = element.frame.applying(strongSelf.transformMatrix())
              UIUtilities.addRectangle(
                transformedRect,
                to: strongSelf.annotationOverlayView,
                color: UIColor.green
              )
              let label = UILabel(frame: transformedRect)
              label.text = element.text
              label.adjustsFontSizeToFitWidth = true
              strongSelf.annotationOverlayView.addSubview(label)
            }
          }
        }
        strongSelf.resultsText += "\(text.text)"
        strongSelf.showResults()
      }
    }
  }


extension UIImage {

  /// Creates and returns a new image scaled to the given size. The image preserves its original PNG
  /// or JPEG bitmap info.
  ///
  /// - Parameter size: The size to scale the image to.
  /// - Returns: The scaled image or `nil` if image could not be resized.
  public func scaledImage(with size: CGSize) -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    defer { UIGraphicsEndImageContext() }
    draw(in: CGRect(origin: .zero, size: size))
    return UIGraphicsGetImageFromCurrentImageContext()?.data.flatMap(UIImage.init)
  }

  // MARK: - Private

  /// The PNG or JPEG data representation of the image or `nil` if the conversion failed.
  private var data: Data? {
    #if swift(>=4.2)
      return self.pngData() ?? self.jpegData(compressionQuality: Constant.jpegCompressionQuality)
    #else
      return self.pngData() ?? self.jpegData(compressionQuality: Constant.jpegCompressionQuality)
    #endif  // swift(>=4.2)
  }
}

// MARK: - Constants

private enum Constant {
  static let jpegCompressionQuality: CGFloat = 0.8
}

