//
//  PersonBookUITests.swift
//  PersonBookUITests
//
//  Created by 曾問 on 2021/4/30.
//

import XCTest

class RelationBookUITests: XCTestCase {
  var app: XCUIApplication!

  override func setUpWithError() throws {
    continueAfterFailure = false

    app = XCUIApplication()
  }

  override func tearDownWithError() throws {
  }

  func testAddEventViewAppear() throws {
    app.launch()
//    let addEventImage = app.images["addEventButton"]
//
//    addEventImage.tap()
    
  }

  func testLaunchPerformance() throws {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
      measure(metrics: [XCTApplicationLaunchMetric()]) {
        XCUIApplication().launch()
      }
    }
  }
}
