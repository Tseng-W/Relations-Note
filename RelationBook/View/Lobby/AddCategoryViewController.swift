//
//  AddCategoryViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/21.
//

import UIKit
import FlexColorPicker
import SCLAlertView

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
      confirmButton.backgroundColor = canConfirm ? UIColor.systemGray2 : UIColor.systemGray4
    }
  }
  private let colorPicker = ColorPickerController()
  private var iconSelectAlerts: [(String, Selector)] = [
    ("內建圖示", #selector(setIconFromLocalIcon)),
    ("照片", #selector(setIconFromPicture)),
    ("拍照", #selector(setIconFromCamera)),
    ("取消", #selector(setIconCancel))
  ]

  var onIconCreated: ((Category) -> Void)?
  var userViewModel = UserViewModel.shared
  var newIconImageString: String?
  var newIconColor: UIColor?
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
    let appearance = SCLAlertView.SCLAppearance(
      showCloseButton: false,
      contentViewColor: .systemBackground,
      titleColor: .label
    )
    let alertView = SCLAlertView(appearance: appearance)


    iconSelectAlerts.forEach { title, selector in
      alertView.addButton(title, target: self, selector: selector)
    }

    let cameraIcon = UIImage(systemName: "camera")!.withTintColor(.systemGray6)

    alertView.showCustom("類別圖片", subTitle: "選擇既有圖示或上傳照片", color: .systemGray2, icon: cameraIcon, colorStyle: UIColor.white.toUInt())
  }

  @objc private func setIconFromLocalIcon() {
    newIconImageString = "sparkles"
    iconImageView.image = UIImage(systemName: newIconImageString!)!
  }

  @objc private func setIconFromPicture() {
    iconImageView.image = UIImage(systemName: "sparkles")!
  }

  @objc private func setIconFromCamera() {
    iconImageView.image = UIImage(systemName: "sparkles")!
  }

  @objc private func setIconCancel() {

  }

  @IBAction private func onConfirm(_ sender: UIButton) {
    guard let title = iconTextField.text,
          let imageString = newIconImageString,
          let iconColor = newIconColor,
          let type = delegate?.typeOfCategory(controller: self),
          let superIndex = delegate?.superIndexOfCategory(controller: self),
          let hierarchy = delegate?.hierarchyOfCategory(controller: self) else { dismiss(animated: true); return }
    let color = colorPicker.selectedColor

    var category = Category(
      id: -1,
      isCustom: true,
      superIndex: superIndex,
      isSubEnable: false,
      title: title,
      imageLink: imageString,
      backgroundColor: iconColor.StringFromUIColor())

    userViewModel.addCategoryAt(type: type, hierarchy: hierarchy, category: &category) { error in
      if let error = error { print(error) }
      else {
        self.onDismiss?()
      }
    }
  }

  @IBAction private func onCancel(_ sender: UIButton) {
    dismiss(animated: true) {
      self.onDismiss?()
    }
  }
}

extension AddCategoryViewController: ColorPickerDelegate {
  func colorPicker(_ colorPicker: ColorPickerController, selectedColor: UIColor, usingControl: ColorControl) {

    newIconColor = selectedColor
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
