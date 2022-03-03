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
import QuartzCore

class SnowView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)

    guard
			let emitter = layer as? CAEmitterLayer,
			let image = UIImage(named: "flake.png")?.cgImage else { return }

    emitter.emitterPosition = CGPoint(x: bounds.size.width / 2, y: 0)
    emitter.emitterSize = bounds.size
    emitter.emitterShape = .rectangle

    let emitterCell = CAEmitterCell()
    emitterCell.contents = image
    emitterCell.birthRate = 200
    emitterCell.lifetime = 3.5
    emitterCell.color = UIColor.white.cgColor
    emitterCell.redRange = 0.0
    emitterCell.blueRange = 0.1
    emitterCell.greenRange = 0.0
    emitterCell.velocity = 10
    emitterCell.velocityRange = 350
    emitterCell.emissionRange = CGFloat(Double.pi / 2)
    emitterCell.emissionLongitude = CGFloat(-Double.pi)
    emitterCell.yAcceleration = 70
    emitterCell.xAcceleration = 0
    emitterCell.scale = 0.33
    emitterCell.scaleRange = 1.25
    emitterCell.scaleSpeed = -0.25
    emitterCell.alphaRange = 0.5
    emitterCell.alphaSpeed = -0.15

    emitter.emitterCells = [emitterCell]
  }

  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override class var layerClass: AnyClass {
    return CAEmitterLayer.self
  }
}
