//
//  RelationBookSortFeatureTests.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/20.
//

import XCTest
import Firebase
@testable import RelationBook

class RelationBookInitialTests: XCTestCase {
  var sutRelation: CategoryViewModel!
  var sutEvent: CategoryViewModel!
  var sutFeature: CategoryViewModel!

  override func setUpWithError() throws {
    try super.setUpWithError()
    sutRelation = CategoryViewModel(type: .relation)
    sutEvent = CategoryViewModel(type: .event)
    sutFeature = CategoryViewModel(type: .feature)
  }

  override func tearDownWithError() throws {
    sutRelation = nil
    sutEvent = nil
    sutFeature = nil
    try super.tearDownWithError()
  }

  func testRelationInitialResult() {
    print(sutRelation.main)
  }

  func testEventInitialResult() {
    print(sutEvent.main)
  }

  func testFeatureInitialResult() {
    print(sutFeature.main)
  }
}
