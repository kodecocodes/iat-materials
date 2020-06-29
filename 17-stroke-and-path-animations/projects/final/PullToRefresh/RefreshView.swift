/*
* Copyright (c) 2014-present Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit
import QuartzCore

// MARK: Refresh View Delegate Protocol
protocol RefreshViewDelegate: class {
  func refreshViewDidRefresh(_ refreshView: RefreshView)
}

// MARK: Refresh View
class RefreshView: UIView, UIScrollViewDelegate {
  
  weak var delegate: RefreshViewDelegate?
  var scrollView: UIScrollView
  var refreshing: Bool = false
  var progress: CGFloat = 0.0
  
  var isRefreshing = false
  
  let ovalShapeLayer: CAShapeLayer = CAShapeLayer()
  let airplaneLayer: CALayer = CALayer()
  
  init(frame: CGRect, scrollView: UIScrollView) {
    self.scrollView = scrollView

    super.init(frame: frame)
    
    //add the background image
    let imgView = UIImageView(image: UIImage(named: "refresh-view-bg.png"))
    imgView.frame = bounds
    imgView.contentMode = .scaleAspectFill
    imgView.clipsToBounds = true
    addSubview(imgView)

    ovalShapeLayer.strokeColor = UIColor.white.cgColor
    ovalShapeLayer.fillColor = UIColor.clear.cgColor
    ovalShapeLayer.lineWidth = 4.0
    ovalShapeLayer.lineDashPattern = [2, 3]

    let refreshRadius = frame.size.height/2 * 0.8

    ovalShapeLayer.path = UIBezierPath(ovalIn: CGRect(
      x: frame.size.width/2 - refreshRadius,
      y: frame.size.height/2 - refreshRadius,
      width: 2 * refreshRadius,
      height: 2 * refreshRadius)
      ).cgPath

    layer.addSublayer(ovalShapeLayer)

    let airplaneImage = UIImage(named: "airplane.png")!
    airplaneLayer.contents = airplaneImage.cgImage
    airplaneLayer.bounds = CGRect(x: 0.0, y: 0.0,
                                  width: airplaneImage.size.width,
                                  height: airplaneImage.size.height)

    airplaneLayer.position = CGPoint(
      x: frame.size.width/2 + frame.size.height/2 * 0.8,
      y: frame.size.height/2)

    layer.addSublayer(airplaneLayer)

    airplaneLayer.opacity = 0.0
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: Scroll View Delegate methods
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = max(-(scrollView.contentOffset.y + scrollView.contentInset.top), 0.0)
    progress = min(max(offsetY / frame.size.height, 0.0), 1.0)
    
    if !isRefreshing {
      redrawFromProgress(self.progress)
    }
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    if !isRefreshing && self.progress >= 1.0 {
      delegate?.refreshViewDidRefresh(self)
      beginRefreshing()
    }
  }
  
  // MARK: animate the Refresh View
  
  func beginRefreshing() {
    isRefreshing = true
    
    UIView.animate(withDuration: 0.3) {
      var newInsets = self.scrollView.contentInset
      newInsets.top += self.frame.size.height
      self.scrollView.contentInset = newInsets
    }

    let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
    strokeStartAnimation.fromValue = -0.5
    strokeStartAnimation.toValue = 1.0

    let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
    strokeEndAnimation.fromValue = 0.0
    strokeEndAnimation.toValue = 1.0

    let strokeAnimationGroup = CAAnimationGroup()
    strokeAnimationGroup.duration = 1.5
    strokeAnimationGroup.repeatDuration = 5.0
    strokeAnimationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
    ovalShapeLayer.add(strokeAnimationGroup, forKey: nil)

    let flightAnimation = CAKeyframeAnimation(keyPath: "position")
    flightAnimation.path = ovalShapeLayer.path
    flightAnimation.calculationMode = .paced

    let airplaneOrientationAnimation = CABasicAnimation(keyPath: "transform.rotation")
    airplaneOrientationAnimation.fromValue = 0
    airplaneOrientationAnimation.toValue = 2.0 * .pi

    let flightAnimationGroup = CAAnimationGroup()
    flightAnimationGroup.duration = 1.5
    flightAnimationGroup.repeatDuration = 5.0
    flightAnimationGroup.animations = [flightAnimation, airplaneOrientationAnimation]
    airplaneLayer.add(flightAnimationGroup, forKey: nil)
  }
  
  func endRefreshing() {
    
    isRefreshing = false
    
    UIView.animate(withDuration: 0.3, delay:0.0, options: .curveEaseOut,
      animations: {
        var newInsets = self.scrollView.contentInset
        newInsets.top -= self.frame.size.height
        self.scrollView.contentInset = newInsets
      },
      completion: {_ in
        //finished
      }
    )
  }
  
  func redrawFromProgress(_ progress: CGFloat) {
    ovalShapeLayer.strokeEnd = progress
    airplaneLayer.opacity = Float(progress)
  }
  
}
