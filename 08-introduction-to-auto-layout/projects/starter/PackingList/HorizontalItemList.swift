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

//
// A scroll view, which loads all 10 images, and has a callback
// for when the user taps on one of the images
//
class HorizontalItemList: UIScrollView {
  
  var didSelectItem: ((_ index: Int)->())?
  
  let buttonWidth: CGFloat = 60.0
  let padding: CGFloat = 10.0
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init(inView: UIView) {
    let rect = CGRect(x: inView.bounds.width, y: 120.0, width: inView.frame.width, height: 80.0)
    self.init(frame: rect)
    
    alpha = 0.0
    
    for i in 0 ..< 10 {
      let image = UIImage(named: "summericons_100px_0\(i).png")
      let imageView  = UIImageView(image: image)
      imageView.center = CGPoint(x: CGFloat(i) * buttonWidth + buttonWidth/2, y: buttonWidth/2)
      imageView.tag = i
      imageView.isUserInteractionEnabled = true
      addSubview(imageView)
      
      let tap = UITapGestureRecognizer(target: self, action: #selector(HorizontalItemList.didTapImage(_:)))
      imageView.addGestureRecognizer(tap)
    }
    
    contentSize = CGSize(width: padding * buttonWidth, height:  buttonWidth + 2*padding)
  }
  
  @objc func didTapImage(_ tap: UITapGestureRecognizer) {
    didSelectItem?(tap.view!.tag)
  }
  
  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    
    guard superview != nil else {
      return
    }
    
    UIView.animate(withDuration: 1.0, delay: 0.01, usingSpringWithDamping: 0.5,
      initialSpringVelocity: 10.0, options: .curveEaseIn,
      animations: {
        self.alpha = 1.0
        self.center.x -= self.frame.size.width
      },
      completion: nil
    )
  }
}
