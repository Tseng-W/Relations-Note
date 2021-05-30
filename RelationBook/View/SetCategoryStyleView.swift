//
//  SetCategoryStyleView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/30.
//

import UIKit
import FlexColorPicker
import CropViewController

protocol CategoryStyleViewDelegate: AnyObject {

  func categoryStyleView(styleView: SetCategoryStyleView, name: String, backgroundColor: UIColor, image: UIImage, imageString: String )
}

class SetCategoryStyleView: UIView, NibLoadable {

  @IBOutlet var titleLabel: UILabel! {
    didSet {
      titleLabel.text = title
    }
  }
  @IBOutlet var iconSelectView: IconSelectView! {
    didSet {

      layoutIfNeeded()

      iconSelectView.onIconTapped = { [weak self] view in

        if let strongSelf = self {
          let provider = SCLAlertViewProvider(rounded: strongSelf)
          provider.showAlert(type: .roundedImage)
        }
      }

      iconSelectView.onEndEditTitle = { [weak self] title in
        self?.name = title
      }
    }
  }
  @IBOutlet var brightnessSlider: BrightnessSliderControl!
  @IBOutlet var paletteControl: RectangularPaletteControl!
  @IBOutlet var confirmButton: UIButton!

  private let colorPicker = ColorPickerController()

  var onDismiss: (() -> Void)?

  weak var delegate: CategoryStyleViewDelegate?

  var canConfirm = false {
    didSet {
      confirmButton.isEnabled = canConfirm
      confirmButton.alpha = canConfirm ? 1.0 : 0.5
    }
  }
  var name = String.empty {
    didSet {
      canConfirm = name != .empty
    }
  }
  var title = String.empty {
    didSet {
      guard let titleLabel = titleLabel else { return }
      titleLabel.text = title
    }
  }
  var image: UIImage?
  var imageString: String?
  var selectedColor = IconView.defaultBackgroundColor
  var isImageCropped = false

  override init(frame: CGRect) {
    super.init(frame: frame)
    customInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    customInit()
  }

  convenience init(title: String, placeholder: String) {
    self.init(frame: CGRect())

    if let titleLabel = titleLabel {
      titleLabel.text = title
    }

    if let iconSelectView = iconSelectView {
      iconSelectView.textField.placeholder = placeholder
    }
  }

  override class func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
  }

  func customInit() {
    loadNibContent()

    colorPicker.brightnessSlider = brightnessSlider
    colorPicker.rectangularHsbPalette = paletteControl
    colorPicker.delegate = self
  }

  @IBAction func buttonTapped(_ sender: UIButton) {

    if sender == confirmButton {

      guard let imageString = imageString,
            let image = image,
            name != .empty else { return }
      delegate?.categoryStyleView(styleView: self, name: name, backgroundColor: colorPicker.selectedColor, image: image, imageString: imageString)
    }

    removeFromSuperview()
    onDismiss?()
  }
}

// MARK: - Color picker delegate
extension SetCategoryStyleView: ColorPickerDelegate {

  func colorPicker(_ colorPicker: ColorPickerController, selectedColor: UIColor, usingControl: ColorControl) {
    iconSelectView.iconView.setIcon(isCropped: isImageCropped, bgColor: selectedColor)
    self.selectedColor = selectedColor
  }
}

// MARK: - SCLAlertProvider delegate
extension SetCategoryStyleView: SCLAlertViewProviderDelegate, CropViewControllerDelegate {

  func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {

    cropViewController.dismiss(animated: true, completion: nil)

    isImageCropped = true
    iconSelectView.iconView.setIcon(isCropped: isImageCropped, image: image)
    self.image = image

    FirebaseManager.shared.uploadPhoto(image: image) { [weak self] result in
      switch result {
      case .success(let url):
        self?.imageString = url.absoluteString
      case .failure(let error):
        print("\(error.localizedDescription)")
      }
    }
  }

  func alertProvider(provider: SCLAlertViewProvider, symbolName: String) {
    guard let image = UIImage(systemName: symbolName) else { return }
    isImageCropped = false

    iconSelectView.iconView.setIcon(isCropped: isImageCropped, image: image)
    self.image = image
    imageString = symbolName
  }

  func alertProvider(provider: SCLAlertViewProvider, rectImage image: UIImage) {
    isImageCropped = false
    iconSelectView.iconView.setIcon(isCropped: isImageCropped, image: image)
    self.image = image

    FirebaseManager.shared.uploadPhoto(image: image) { [weak self] result in
      switch result {
      case .success(let url):
        self?.imageString = url.absoluteString
      case .failure(let error):
        print("\(error.localizedDescription)")
      }
    }
  }
}
