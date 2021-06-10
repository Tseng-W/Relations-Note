//
//  FeatureViewModel.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/25.
//

import Foundation

class FeatureViewModel {

  var feature: Box<Feature>

  init() {
    feature = Box(Feature())
  }

  init(feature: Feature) {
    self.feature = Box(feature)
  }



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

  func addFeatures(relation: Relation, features: [Feature], completion: @escaping () -> Void = {}) {

    var newFeatures = relation.feature

    features.forEach { feature in

      if let index = newFeatures.firstIndex(where: { oldFeature in
        oldFeature.categoryIndex == feature.categoryIndex
      }) {
        newFeatures[index].contents.append(contentsOf: feature.contents)
      } else {
        newFeatures.append(feature)
      }
    }

    newFeatures.sort(by: { $0.categoryIndex < $1.categoryIndex })

    updateFeature(categoryIndex: relation.categoryIndex, features: newFeatures) {
      completion()
    }
  }

  func updateFeature(categoryIndex: Int, features: [Feature], completion: @escaping () -> Void = { }) {

    let dict = features.map { $0.toDict() }

    FirebaseManager.shared.updateRelation(categoryIndex: categoryIndex, dict: ["feature": dict]) {
      completion()
    } 
  }
}
