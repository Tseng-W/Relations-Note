//
//  SCLAlertViewWrapper.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/29.
//

import UIKit
import SCLAlertView
import CropViewController
import FirebaseStorage

protocol SCLAlertViewProviderDelegate: AnyObject {

  func alertProvider(provider: SCLAlertViewProvider, symbolName: String)

  func alertProvider(provider: SCLAlertViewProvider, rectImage image: UIImage)
}

class SCLAlertViewProvider: NSObject {

  enum AlertType {
    case roundedImage

    var appearance: SCLAlertView.SCLAppearance {
      switch self {
      case .roundedImage:
        return SCLAlertView.SCLAppearance(
          showCloseButton: false,
          shouldAutoDismiss: false,
          contentViewColor: .systemBackground,
          titleColor: .label
        )
      }
    }

    var title: String {
      switch self {
      case .roundedImage:
        return "設定圖片"
      }
    }

    var subTitle: String {
      switch self {
      case .roundedImage:
        return "選擇既有圖示或上傳圖片"
      }
    }

    var buttons: [(title: String, action: Selector)] {
      switch self {
      case .roundedImage:
        return [
          ("內建圖示", #selector(loadLocalIcon)),
          ("照片", #selector(loadPicture)),
          ("拍照", #selector(loadCamera)),
          ("取消", #selector(cancel))
        ]
      }
    }

    var icon: UIImage {
      switch self {
      case .roundedImage:
        let icon = UIImage(systemName: "camera")!
        return icon.withTintColor(.systemGray6)
      }
    }
  }

  var onSelectedLocalIcon: ((String) -> Void)?
  var onSelectedImage: ((String) -> Void)?

  var alertView: SCLAlertView?
  var alertDelegate: SCLAlertViewProviderDelegate?
  var cropViewDelegate: CropViewControllerDelegate?

  var type: AlertType?

  init<T: UIViewController & SCLAlertViewProviderDelegate & CropViewControllerDelegate >(delegate: T) {
    alertDelegate = delegate
    cropViewDelegate = delegate
  }

  func showAlert(type: AlertType) {

    self.type = type

    alertView = SCLAlertView(appearance: type.appearance)

    type.buttons.forEach { button in
      alertView!.addButton(button.title, backgroundColor: .systemGray, textColor: .label, showTimeout: nil, target: self, selector: button.action)
    }

    alertView!.showCustom(type.title, subTitle: type.subTitle, color: .secondarySystemBackground, icon: type.icon)

  }
}

// MARK: - Private functions
extension SCLAlertViewProvider {

  @objc private func loadLocalIcon() {

    alertDelegate?.alertProvider(provider: self, symbolName: "sparkles")

    alertView?.hideView()
  }

  @objc private func loadPicture() {

    guard let alertView = alertView else { return }

    let provider = CameraProvider(delegate: self)

    do {
      let picker = try provider.getImagePicker(source: .photoLibrary)
      alertView.present(picker, animated: true) {
        picker.delegate = self
      }
    } catch {
      NSLog("error: \(error.localizedDescription)")
    }
  }

  @objc private func loadCamera() {

    guard let alertView = alertView else { return }

    let provider = CameraProvider(delegate: self)

    do {
      let picker = try provider.getImagePicker(source: .camera)
      alertView.present(picker, animated: true) {
        picker.delegate = self
      }
    } catch {
      NSLog("error: \(error.localizedDescription)")
    }
  }

  @objc private func cancel() {
    alertView?.dismiss(animated: true, completion: nil)
  }
}

extension SCLAlertViewProvider: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

    picker.dismiss(animated: true, completion: nil)

    guard let image = (
            info[UIImagePickerController.InfoKey.editedImage] as? UIImage ?? info[UIImagePickerController.InfoKey.originalImage] as? UIImage) else { return }

    switch type {
    case .roundedImage:
      guard let alertView = alertView else { return }

      let cropVC = CropViewController(croppingStyle: .circular, image: image)
      cropVC.delegate = cropViewDelegate
      alertView.present(cropVC, animated: true) {
        self.alertView?.hideView()
      }
    default:
      alertDelegate?.alertProvider(provider: self, rectImage: image)
    }
  }
}
