//
//  AddRelationViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/24.
//

import UIKit
import CropViewController

class AddContactFlowViewController: FloatingViewController {

  @IBOutlet var iconSelectView: IconSelectView! {
    didSet {

      iconSelectView.subviews.forEach { $0.isUserInteractionEnabled = false }

      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showCategoryStyleView(tapGesture:)))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      iconSelectView.addGestureRecognizer(tapGesture)
    }
  }
  @IBOutlet var relationButton: TitledInputView! {
    didSet {
      relationButton.titleLabel.text = "關係"

      relationButton.onTapped = {

        self.edittingType = .relation

        let blurView = self.view.addBlurView()

        self.view.layoutIfNeeded()

        let filterView = FilterView()
        self.view.addSubview(filterView)
        filterView.addConstarint(
          top: self.view.topAnchor,
          left: self.view.leftAnchor,
          bottom: self.view.bottomAnchor,
          right: self.view.rightAnchor,
          paddingTop: self.view.frame.height / 3,
          paddingLeft: 32,
          paddingBottom: self.view.frame.height / 3,
          paddingRight: 32)

        self.view.layoutIfNeeded()

        filterView.cornerRadius = 16
        filterView.setUp(type: .relation, isMainOnly: true)

        filterView.onSelected = { [weak self] categories in
          self?.category = categories.first
          self?.relationButton.selectedContent = self?.category?.title
          filterView.removeFromSuperview()
          blurView.removeFromSuperview()
        }
      }
    }
  }
  @IBOutlet var featureButton: TitledInputView! {
    didSet {
      featureButton.titleLabel.text = "特徵關係"

      featureButton.onTapped = {

        self.edittingType = .feature

        let blurView = self.view.addBlurView()

        let addFeatureView = AddFeatureFloatView()
        self.view.addSubview(addFeatureView)
        addFeatureView.addConstarint(
          top: self.view.topAnchor,
          left: self.view.leftAnchor,
          bottom: self.view.bottomAnchor,
          right: self.view.rightAnchor,
          paddingTop: self.view.frame.height / 4,
          paddingLeft: 32,
          paddingBottom: self.view.frame.height / 4,
          paddingRight: 32,
          width: 0, height: 0)

        self.view.layoutIfNeeded()

        addFeatureView.cornerRadius = 16

        addFeatureView.filterView.setUp(type: .feature, isMainOnly: false)

        addFeatureView.onCancel = {
          blurView.removeFromSuperview()
          addFeatureView.removeFromSuperview()
        }

        addFeatureView.onConfirm = { [weak self] category, feature in
          self?.featureButton.selectedContent = category.title
          self?.feature = feature
        }
      }
    }
  }

  @IBOutlet var confirmButton: UIButton! {
    didSet {
      confirmButton.isEnabled = false
    }
  }

  var relationViewModel = RelationViewModel()

  var edittingType: CategoryType?
  var feature: Feature? {
    didSet {
      checkContactData()
    }
  }
  var category: Category? {
    didSet {
      checkContactData()
    }
  }

  var name: String? {
    didSet {
      checkContactData()
    }
  }
  var imageString: String?
  var imageBackgroundColor: UIColor?

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func checkContactData() {
    guard let _ = category,
          let _ = feature,
          let _ = name,
          let _ = imageString,
          let _ = imageBackgroundColor else {
      confirmButton.isEnabled = false
      return
    }
    confirmButton.isEnabled = true
  }

  @IBAction func onTapButton(_ sender: UIButton) {
    if sender == confirmButton {
      guard let category = category,
            let feature = feature,
            let name = name,
            let image = imageString,
            let bgColor = imageBackgroundColor else { return }
      relationViewModel.addRelation(name: name, iconString: image, bgColor: bgColor, superIndex: category.id, feature: feature)
    }
    self.view.removeFromSuperview()
  }

  @objc func showCategoryStyleView(tapGesture: UITapGestureRecognizer) {

    edittingType = .relation

    let setCategoryView = SetCategoryStyleView()
    let blurView = view.addBlurView()

    setCategoryView.delegate = self

    setCategoryView.onDismiss = {
      blurView.removeFromSuperview()
    }

    view.addSubview(setCategoryView)

    let verticalPadding: CGFloat = 16.0

    setCategoryView.addConstarint(
      left: view.leftAnchor, right: view.rightAnchor,
      centerY: view.centerYAnchor,
      paddingLeft: verticalPadding, paddingRight: verticalPadding,
      height: view.frame.height / 2.3)

    view.layoutIfNeeded()

    setCategoryView.iconSelectView.setUp()
  }
}

extension AddContactFlowViewController: CategoryStyleViewDelegate {

  func iconType(styleView: SetCategoryStyleView) -> CategoryType? {
    edittingType
  }

  func categoryStyleView(styleView: SetCategoryStyleView, isCropped: Bool, name: String, backgroundColor: UIColor, image: UIImage, imageString: String) {
    
    self.imageString = imageString
    self.name = name
    imageBackgroundColor = backgroundColor

    iconSelectView.iconView.setIcon(isCropped: isCropped, image: image, bgColor: backgroundColor)
    iconSelectView.textField.text = name
  }
}

extension AddContactFlowViewController:
  SCLAlertViewProviderDelegate, CropViewControllerDelegate {

  func selectionView(selectionView: LocalIconSelectionView, didSelected image: UIImage, named: String) {

    iconSelectView.iconView.setIcon(isCropped: false, image: image, bgColor: .clear)
    imageString = named
  }

  func alertIconType(provider: SCLAlertViewProvider) -> CategoryType? {
    edittingType
  }

  func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {

    cropViewController.dismiss(animated: true)

    iconSelectView.iconView.setIcon(isCropped: true, image: image, bgColor: .clear, tintColor: .label)

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
    print()
  }

  func alertProvider(provider: SCLAlertViewProvider, rectImage image: UIImage) {
    print()
  }
}
