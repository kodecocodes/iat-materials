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
    
  }
  
}
