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

// A delay function
func delay(seconds: Double, completion: @escaping ()-> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

class ViewController: UIViewController {
  
  @IBOutlet var myAvatar: AvatarView!
  @IBOutlet var opponentAvatar: AvatarView!
  
  @IBOutlet var status: UILabel!
  @IBOutlet var vs: UILabel!
  @IBOutlet var searchAgain: UIButton!
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    searchForOpponent()
  }

  func searchForOpponent() {
    let avatarSize = myAvatar.frame.size
    let bounceXOffset: CGFloat = avatarSize.width/1.9
    let morphSize = CGSize(
      width: avatarSize.width * 0.85,
      height: avatarSize.height * 1.1)

    let rightBouncePoint = CGPoint(
      x: view.frame.size.width/2.0 + bounceXOffset,
      y: myAvatar.center.y)

    let leftBouncePoint = CGPoint(
      x: view.frame.size.width/2.0 - bounceXOffset,
      y: myAvatar.center.y)

    myAvatar.bounceOff(point: rightBouncePoint, morphSize: morphSize)
    opponentAvatar.bounceOff(point: leftBouncePoint, morphSize: morphSize)

    delay(seconds: 4.0, completion: foundOpponent)
  }

  func foundOpponent() {
    status.text = "Connecting..."

    opponentAvatar.image = UIImage(named: "avatar-2")
    opponentAvatar.name = "Ray"

    delay(seconds: 4.0, completion: connectedToOpponent)
  }

  func connectedToOpponent() {
    myAvatar.shouldTransitionToFinishedState = true
    opponentAvatar.shouldTransitionToFinishedState = true

    delay(seconds: 1.0, completion: completed)
  }

  func completed() {
    status.text = "Ready to play"
    UIView.animate(withDuration: 0.2) {
      self.vs.alpha = 1.0
      self.searchAgain.alpha = 1.0
    }
  }
  
  @IBAction func actionSearchAgain() {
    UIApplication.shared.keyWindow!.rootViewController = storyboard!.instantiateViewController(withIdentifier: "ViewController") as UIViewController
  }
}

