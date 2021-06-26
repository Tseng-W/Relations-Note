//
//  Box.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/11.
//

import Foundation

class Box<T> {

  typealias Listener = (T) -> Void

  var listeners: [Listener?] = []

  init(_ value: T) {
    self.value = value
  }

  var value: T {
    didSet {
      listeners.forEach { listener in
        listener?(value)
      }
    }
  }

  func bind(listener: Listener?) {
    listeners.append(listener)
    listeners.forEach { listener in
      listener?(value)
    }
  }

  func unbind(listener: Listener?) {
    self.listeners = self.listeners.filter { $0 as AnyObject !== listener as AnyObject }
  }
}
