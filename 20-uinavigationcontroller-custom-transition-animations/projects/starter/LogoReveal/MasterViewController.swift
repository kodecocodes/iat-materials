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

func delay(seconds: Double, completion: @escaping ()-> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

class MasterViewController: UIViewController {
  
  let logo = RWLogoLayer.logoLayer()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Start"

  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // add the tap gesture recognizer
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
    view.addGestureRecognizer(tap)
    
    // add the logo to the view
    logo.position = CGPoint(x: view.layer.bounds.size.width/2,
      y: view.layer.bounds.size.height/2 - 30)
    logo.fillColor = UIColor.white.cgColor
    view.layer.addSublayer(logo)
  }
  
  //
  // MARK: Gesture recognizer handler
  //
  @objc func didTap() {
    performSegue(withIdentifier: "details", sender: nil)
  }
  
}

