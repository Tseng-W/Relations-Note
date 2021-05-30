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

  func categoryStyleView(styleView: SetCategoryStyleView, title: String, backgroundColor: UIColor, image: UIImage?, symbolString: String?)
}

class SetCategoryStyleView: UIView, NibLoadable {

  @IBOutlet var titleLabel: UILabel! {
    didSet {
      titleLabel.text = title
    }
  }
  @IBOutlet var iconSelectView: IconSelectView! {
    didSet {

      iconSelectView.textField.placeholder = placeholder

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

  var placeholder = String.empty

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
  var title = String.empty
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

  init(title: String, placeholder: String) {
    super.init(frame: CGRect())
    self.title = title
    self.placeholder = placeholder
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

    } else {
      removeFromSuperview()
      onDismiss?()
    }
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
    isImageCropped = true
    iconSelectView.iconView.setIcon(isCropped: isImageCropped, image: image)
  }

  func alertProvider(provider: SCLAlertViewProvider, symbolName: String) {
    guard let image = UIImage(systemName: symbolName) else { return }
    isImageCropped = false
    iconSelectView.iconView.setIcon(isCropped: isImageCropped, image: image)
  }

  func alertProvider(provider: SCLAlertViewProvider, rectImage image: UIImage) {
    isImageCropped = false
    iconSelectView.iconView.setIcon(isCropped: isImageCropped, image: image)
  }
}
