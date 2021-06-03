//
//  AddCategoryViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/21.
//

import UIKit
import FlexColorPicker
import SCLAlertView
import CropViewController

protocol AddCategoryViewDelegate: AnyObject {

  func typeOfCategory(controller: AddCategoryViewController) -> CategoryType?

  func superIndexOfCategory(controller: AddCategoryViewController) -> Int

  func hierarchyOfCategory(controller: AddCategoryViewController) -> CategoryHierarchy?
}

class AddCategoryViewController: FloatingViewController {

  @IBOutlet var iconImageView: UIImageView! {
    didSet {
      let tap = UITapGestureRecognizer(target: self, action: #selector(showSelectImageView(tapGesture:)))
      tap.numberOfTouchesRequired = 1
      tap.numberOfTapsRequired = 1
      iconImageView.addGestureRecognizer(tap)
      iconImageView.isUserInteractionEnabled = true
    }
  }
  @IBOutlet var iconTextField: UITextField! {
    didSet {
      iconTextField.delegate = self
    }
  }
  @IBOutlet var brightnessSliderControl: BrightnessSliderControl!
  @IBOutlet var paletteControl: RectangularPaletteControl!
  @IBOutlet var confirmButton: UIButton!

  private var canConfirm = false {
    didSet {
      confirmButton.isEnabled = canConfirm
      confirmButton.backgroundColor = canConfirm ? UIColor.systemGray : UIColor.systemGray4
    }
  }
  private let colorPicker = ColorPickerController()
  private let defaultIcon = UIImage(systemName: "camera")

  var newIconImageString: String?
  weak var delegate: AddCategoryViewDelegate?

  override func viewDidLoad() {

    super.viewDidLoad()

    setBlurBackground()
    canConfirm = false

    colorPicker.brightnessSlider = brightnessSliderControl
    colorPicker.rectangularHsbPalette = paletteControl
    colorPicker.delegate = self
    
  }

  @objc private func showSelectImageView(tapGesture: UITapGestureRecognizer) {

    let alertProvider = SCLAlertViewProvider(rounded: self)

    alertProvider.showAlert(type: .roundedImage)
  }

  override func onVisibleChanged(isVisible: Bool) {
    if isVisable {
      iconImageView.image = defaultIcon
    }
  }

  @IBAction private func onConfirm(_ sender: UIButton) {
    guard let title = iconTextField.text,
          let imageString = newIconImageString,
          let type = delegate?.typeOfCategory(controller: self),
          let superIndex = delegate?.superIndexOfCategory(controller: self),
          let hierarchy = delegate?.hierarchyOfCategory(controller: self) else { dismiss(animated: true); return }
    let color = colorPicker.selectedColor

    var category = Category(
      id: -1,
      isCustom: String.verifyUrl(urlString: imageString),
      superIndex: superIndex,
      isSubEnable: false,
      title: title,
      imageLink: imageString,
      backgroundColor: color.StringFromUIColor())

    FirebaseManager.shared.addUserCategory(type: type, hierarchy: hierarchy, category: &category)
    isVisable = false
  }

  @IBAction private func onCancel(_ sender: UIButton) {
    isVisable = false
  }
}

extension AddCategoryViewController: ColorPickerDelegate {
  func colorPicker(_ colorPicker: ColorPickerController, selectedColor: UIColor, usingControl: ColorControl) {
    iconImageView.backgroundColor = selectedColor
  }
}

extension AddCategoryViewController: UITextFieldDelegate {

  func textFieldDidEndEditing(_ textField: UITextField) {
    guard textField.text != nil else { canConfirm = false; return }
    canConfirm = true
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}

extension AddCategoryViewController: CropViewControllerDelegate {

  func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
    cropViewController.dismiss(animated: true, completion: nil)
    
    iconImageView.image = image

    FirebaseManager.shared.uploadPhoto(image: image) { [weak self] result in
      switch result {
      case .success(let url):
        self?.newIconImageString = url.absoluteString
      case .failure(let error):
        print("\(error.localizedDescription)")
      }
    }
  }
}

extension AddCategoryViewController: SCLAlertViewProviderDelegate {

  func selectionView(selectionView: LocalIconSelectionView, didSelected named: String) {

    iconImageView.image = UIImage(named: named)

    print(named)
  }


  func alertIconType(provider: SCLAlertViewProvider) -> CategoryType? {
    delegate?.typeOfCategory(controller: self)
  }

  func alertProvider(provider: SCLAlertViewProvider, symbolName: String) {
    iconImageView.image = UIImage(systemName: symbolName)
  }

  func alertProvider(provider: SCLAlertViewProvider, rectImage image: UIImage) {
    iconImageView.image = image

    FirebaseManager.shared.uploadPhoto(image: image) { [weak self] result in
      switch result {
      case .success(let url):
        self?.newIconImageString = url.absoluteString
      case .failure(let error):
        print("\(error.localizedDescription)")
      }
    }
  }
}
