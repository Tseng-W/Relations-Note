//
//  PersonBookTests.swift
//  PersonBookTests
//
//  Created by 曾問 on 2021/4/30.
//

import XCTest
import Firebase
@testable import RelationBook

class RelationBookSortFeatureTests: XCTestCase {
  var sut: RelationDetailViewController!

  let mockFeatureT0 = Feature(
    id: 0,
    name: "one",
    index: 1,
    data: [
      FeatureContent(
        isProcessing: false,
        text: "FC1")
    ])
  let mockFeatureT1 = Feature(
    id: 2,
    name: "two",
    index: 10,
    data: [
      FeatureContent(
        isProcessing: false,
        text: "FC2")
    ])
  let mockFeatureT2 = Feature(
    id: 3,
    name: "three",
    index: 13,
    data: [
      FeatureContent(
        isProcessing: false,
        text: "FC3")
    ])
  let mockFeatureTN = Feature(
    id: 4,
    name: "outOfRange",
    index: 9999,
    data: [
      FeatureContent(
        isProcessing: false,
        text: "FCN")
    ])
  let mockCategories = CategoryViewModel(type: .feature).main
  typealias SortedFeatures = [(index: Int, features: [Feature])]

  override func setUpWithError() throws {
    try super.setUpWithError()
    sut = RelationDetailViewController()
  }

  override func tearDownWithError() throws {
    sut = nil
    try super.tearDownWithError()
  }

  func testFeatureSortedWithSameType() {
    let mockFeature = [mockFeatureT0, mockFeatureT0]
    let expected = [(index: 0, [mockFeatureT0, mockFeatureT0])]

    let mockCategories = CategoryViewModel(type: .feature).main

    let result = sut.getFeatureSourtedByType(
      features: mockFeature,
      categories: mockCategories
    )

    assertEqualFeatures(expected: expected, result: result)
  }

  func testFeatureSortedWithDifferentType() {
    let mockFeature = [mockFeatureT0, mockFeatureT1, mockFeatureT2]
    let mockCategories = CategoryViewModel(type: .feature).main
    let expected = [
      (index: 0, features: [mockFeatureT0]),
      (index: 1, features: [mockFeatureT1]),
      (index: 2, features: [mockFeatureT2])
    ]

    let result = sut.getFeatureSourtedByType(features: mockFeature, categories: mockCategories)

    assertEqualFeatures(expected: expected, result: result)
  }

  func testFeatureSortedWithMultiType() {
    let mockFeature = [mockFeatureT2, mockFeatureT0, mockFeatureT1, mockFeatureT0, mockFeatureT2, mockFeatureT1]
    let expected = [
      (index: 0, features: [mockFeatureT0, mockFeatureT0]),
      (index: 1, features: [mockFeatureT1, mockFeatureT1]),
      (index: 2, features: [mockFeatureT2, mockFeatureT2])
    ]

    let result = sut.getFeatureSourtedByType(features: mockFeature, categories: mockCategories)

    assertEqualFeatures(expected: expected, result: result)
  }

  func testFeatureSortedWithEmpty() {
    let expected: [(index: Int, features: [Feature])] = []

    let result = sut.getFeatureSourtedByType(features: [], categories: [])

    assertEqualFeatures(expected: expected, result: result)
  }

  func testFeatureSortedOufOfRange() {
    let mockFeature = [mockFeatureTN]

    let expected: SortedFeatures = []

    let result = sut.getFeatureSourtedByType(features: mockFeature, categories: mockCategories)

    assertEqualFeatures(expected: expected, result: result)
  }

  private func assertEqualFeatures(expected: SortedFeatures, result: SortedFeatures) {
    XCTAssertEqual(expected.count, result.count)
    for index in 0..<result.count {
      XCTAssertEqual(result[index].index, expected[index].index)
      XCTAssertEqual(result[index].features, expected[index].features)
    }
  }
}
