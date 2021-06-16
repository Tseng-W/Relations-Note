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

  func categoryStyleView(styleView: SetCategoryStyleView, isCropped: Bool, name: String, backgroundColor: UIColor, image: UIImage, imageString: String)
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
          let provider = SCLAlertViewProvider(roundedImage: strongSelf)
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

  var blurView: UIVisualEffectView?
  var onDismiss: (() -> Void)?

  weak var delegate: CategoryStyleViewDelegate?

  var canConfirm = false  {
    didSet {
      confirmButton.isEnabled = canConfirm
      confirmButton.isUserInteractionEnabled = canConfirm
      confirmButton.backgroundColor = canConfirm ? .button : .buttonDisable
//      confirmButton.titleLabel?.textColor = canConfirm ?
    }
  }
  var title = String.empty {
    didSet {
      guard let titleLabel = titleLabel else { return }
      titleLabel.text = title
    }
  }
  var selectedColor = IconView.defaultBackgroundColor
  var isImageCropped = false

  var name = String.empty {
    didSet {
      canConfirm = name != .empty
    }
  }
  var image: UIImage?
  var imageString: String?
  var hierarchy: CategoryHierarchy?
  var superIndex: Int?
  var placeholder: String = .empty

  var noSubmit = false  // MARK: 預設上傳 應調整

  var categoryType: CategoryType? {
    didSet {

      guard let type = categoryType,
            let hierarchy = hierarchy else { return }

      var title = String.empty
      var placeholder = String.empty
      
      switch type {
      case .relation:
        if hierarchy == .sub {
          title = "新增關係人"
          placeholder = "輸入姓名"
        } else {
          fallthrough
        }
      case .event, .feature:
        title = "新增子分類"
        placeholder = "輸入名稱"
      case .mood:
        break
      }

      if let titleLabel = titleLabel {
        titleLabel.text = title
      }

      if let iconSelectView = iconSelectView {
        iconSelectView.placeholder = placeholder
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    customInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    customInit()
  }

  override class func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
  }

  func customInit() {

    loadNibContent()

    canConfirm = false

    colorPicker.brightnessSlider = brightnessSlider
    colorPicker.rectangularHsbPalette = paletteControl
    paletteControl.setSelectedHSBColor(UIColor.systemTeal.hsba, isInteractive: true)
    colorPicker.delegate = self
  }

  func show(_ view: UIView, type: CategoryType, hierarchy: CategoryHierarchy, superIndex: Int, noSubmit: Bool = false) {

    reset()

    self.noSubmit = noSubmit
    self.hierarchy = hierarchy
    self.superIndex = superIndex
    categoryType = type

    blurView = view.addBlurView()

    view.addSubview(self)
    addConstarint(
      left: view.leftAnchor, right: view.rightAnchor,
      centerY: view.centerYAnchor,
      paddingLeft: 16, paddingRight: 16,
      height: max(view.frame.height / 2, 400))

    view.layoutIfNeeded()

    iconSelectView.initial(placeholder: placeholder)
  }

  private func reset() {
    name = .empty
    image = nil
    imageString = nil
    superIndex = nil
    hierarchy = nil
  }

  @IBAction func buttonTapped(_ sender: UIButton) {

    if sender == confirmButton {

      guard let imageString = imageString,
            let image = image,
            let superIndex = superIndex,
            let hierarchy = hierarchy,
            let categoryType = categoryType,
            name != .empty else { return }


      if !noSubmit {
        // MARK: 新增互動對象，透過 ralationViewModel 處理
        if categoryType == .relation && hierarchy == .sub {

          let relationViewModel = RelationViewModel()

          relationViewModel.addRelation(
            name: name, iconString: imageString,
            bgColor: colorPicker.selectedColor,
            superIndex: superIndex)

        } else {

          // MARK: 單純新增標籤部分直接呼叫 FirebaseManager 處理
          var category = Category(
            id: -1,
            isCustom: imageString.verifyUrl(),
            superIndex: superIndex,
            isSubEnable: Category.canSubView(
              type: categoryType,
              hierarchy: hierarchy),
            title: name,
            imageLink: imageString,
            backgroundColor: colorPicker.selectedColor.stringFromUIColor())

          FirebaseManager.shared.addUserCategory(type: categoryType, hierarchy: hierarchy, category: &category) { _ in
          }
        }
      }

      delegate?.categoryStyleView(
        styleView: self, isCropped: isImageCropped,
        name: name,
        backgroundColor: colorPicker.selectedColor, image: image, imageString: imageString)
    }

    blurView?.removeFromSuperview()
    removeFromSuperview()
    onDismiss?()
  }
}

// MARK: - Color picker delegate
extension SetCategoryStyleView: ColorPickerDelegate {

  func colorPicker(_ colorPicker: ColorPickerController, selectedColor: UIColor, usingControl: ColorControl) {

    layoutIfNeeded()

    iconSelectView.iconView.setIcon(isCropped: isImageCropped, bgColor: selectedColor)
    self.selectedColor = selectedColor
  }
}

// MARK: - SCLAlertProvider delegate
extension SetCategoryStyleView: SCLAlertViewProviderDelegate, CropViewControllerDelegate {

  func selectionView(selectionView: LocalIconSelectionView, didSelected image: UIImage, named: String) {

    isImageCropped = false
    self.image = image
    imageString = named
    iconSelectView.setUp(isCropped: isImageCropped, image: image)
  }

  func alertIconType(provider: SCLAlertViewProvider) -> CategoryType? {
    return categoryType
  }

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

  func alertIconHiierarchy(provider: SCLAlertViewProvider) -> CategoryHierarchy? {
    return hierarchy
  }
}
