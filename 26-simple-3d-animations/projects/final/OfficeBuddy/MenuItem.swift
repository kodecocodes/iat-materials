/// Copyright (c) 2022-present Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

let menuColors = [
  UIColor(red: 249 / 255, green: 84 / 255, blue: 7 / 255, alpha: 1.0),
  UIColor(red: 69 / 255, green: 59 / 255, blue: 55 / 255, alpha: 1.0),
  UIColor(red: 249 / 255, green: 194 / 255, blue: 7 / 255, alpha: 1.0),
  UIColor(red: 32 / 255, green: 188 / 255, blue: 32 / 255, alpha: 1.0),
  UIColor(red: 207 / 255, green: 34 / 255, blue: 156 / 255, alpha: 1.0),
  UIColor(red: 14 / 255, green: 88 / 255, blue: 149 / 255, alpha: 1.0),
  UIColor(red: 15 / 255, green: 193 / 255, blue: 231 / 255, alpha: 1.0)
]

class MenuItem {
  let title: String
  let symbol: String
  let color: UIColor

  init(symbol: String, color: UIColor, title: String) {
    self.symbol = symbol
    self.color = color
    self.title = title
  }

  static let sharedItems: [MenuItem] = [
    MenuItem(symbol: "☎︎", color: menuColors[0], title: "Phone book"),
    MenuItem(symbol: "✉︎", color: menuColors[1], title: "Email directory"),
    MenuItem(symbol: "♻︎", color: menuColors[2], title: "Company recycle policy"),
    MenuItem(symbol: "♞", color: menuColors[3], title: "Games and fun"),
    MenuItem(symbol: "✾", color: menuColors[4], title: "Training programs"),
    MenuItem(symbol: "✈︎", color: menuColors[5], title: "Travel"),
    MenuItem(symbol: "🃖", color: menuColors[6], title: "Etc.")
  ]
}
