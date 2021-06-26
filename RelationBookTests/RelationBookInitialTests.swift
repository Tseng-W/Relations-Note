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
    for index in 0..<sutRelation.main.count {
      XCTAssertEqual(sutRelation.main[index].id, index)
    }
  }

  func testEventInitialResult() {
    for index in 0..<sutEvent.main.count {
      XCTAssertEqual(sutRelation.main[index].id, index)
    }
  }

  func testFeatureInitialResult() {
    for index in 0..<sutFeature.main.count {
      XCTAssertEqual(sutRelation.main[index].id, index)
    }
  }
}
