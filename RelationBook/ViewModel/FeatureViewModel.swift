//
//  FeatureViewModel.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/25.
//

import Foundation

class FeatureViewModel {

  var feature = Box(Feature())

  var canMutiSelect: Bool = false {
    didSet {
      if !canMutiSelect {

        var content = feature.value
        for index in 0..<content.contents.count {
          content.contents[index].isProcessing = false
        }
        feature.value = content
      }
    }
  }

  func editCellContent(index: Int, content: FeatureContent) {
    
    if index == feature.value.contents.count {
      feature.value.contents.append(content)
    } else {
      feature.value.contents[index] = content
    }
  }

  func amount() -> Int {
    return feature.value.contents.count
  }

  func cellForRowAt(row: Int) -> FeatureContent? {

    if row < feature.value.contents.count {
      return feature.value.contents[row]
    }
    return nil
  }

  func selectedSwitchAt(row: Int) {

    guard row < feature.value.contents.count else { return }

    if !canMutiSelect {
      canMutiSelect = false
      feature.value.contents[row].isProcessing = true
    } else {
      feature.value.contents[row].isProcessing.toggle()
    }
  }
}
