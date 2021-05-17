//
//  PopMoodSelect.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/16.
//

import UIKit

class PopMoodSelectView: UIView {

  let userViewModel = UserViewModel()

  let stackView: UIStackView = {
    let statckView = UIStackView()
    statckView.translatesAutoresizingMaskIntoConstraints = false
    statckView.alignment = .fill
    statckView.distribution = .fillEqually
    statckView.axis = .horizontal
    statckView.spacing = 8
    return statckView
  }()

  var onSelected: ((UIImage, UIColor) -> Void)? {
    didSet {
      setUp()
    }
  }

  private func setUp() {
    addSubview(stackView)
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])

    addMoodButtons()
  }

  private func addMoodButtons() {
    userViewModel.fetchMood()
    userViewModel.moodsData.bind { [weak self] moods in
      for index in 0..<moods.count {
        let newButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        newButton.translatesAutoresizingMaskIntoConstraints = false
        newButton.setTitle(nil, for: .normal)
        moods[index].getImage { newButton.setImage($0, for: .normal) }
        newButton.backgroundColor = moods[index].getColor()
        newButton.tintColor = .white
        newButton.tag = index
        newButton.addTarget(self, action: #selector(self?.onTap(_:)), for: .touchDown)
        NSLayoutConstraint.init(item: newButton, attribute: .height, relatedBy: .equal, toItem: newButton, attribute: .width, multiplier: 1, constant: 0).isActive = true
        self?.stackView.addArrangedSubview(newButton)
        newButton.isCornerd = true
      }
      self?.layoutIfNeeded()
    }
  }

  @objc private func onTap(_ sender: UIButton) {
    onSelected?(sender.image(for: .normal)!, sender.backgroundColor ?? .systemGray)
  }
}
