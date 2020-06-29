/*
 * Copyright (c) 2016-present Razeware LLC
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

class WidgetCell: UITableViewCell {
  
  private var showsMore = false
  @IBOutlet weak var widgetHeight: NSLayoutConstraint!

  weak var tableView: UITableView?
  var toggleHeightAnimator: UIViewPropertyAnimator?
  
  @IBOutlet weak var widgetView: WidgetView!
  
  var owner: WidgetsOwnerProtocol? {
    didSet {
      if let owner = owner {
        widgetView.owner = owner
      }
    }
  }
  
  @IBAction func toggleShowMore(_ sender: UIButton) {
    self.showsMore = !self.showsMore

    let animations = {
      self.widgetHeight.constant = self.showsMore ? 230 : 130
      if let tableView = self.tableView {
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.layoutIfNeeded()
      }
    }

    let textTransition = {
      UIView.transition(with: sender, duration: 0.25, options: .transitionFlipFromTop, animations: {
        sender.setTitle(self.showsMore ? "Show Less" : "Show More", for: .normal)
      }, completion: nil)
    }

    if let toggleHeightAnimator = toggleHeightAnimator, toggleHeightAnimator.isRunning {
      toggleHeightAnimator.pauseAnimation()
      toggleHeightAnimator.addAnimations(animations)
      toggleHeightAnimator.addAnimations(textTransition, delayFactor: 0.5)
      toggleHeightAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 1.0)
    } else {
      let spring = UISpringTimingParameters(mass: 30, stiffness: 1000, damping: 300, initialVelocity: CGVector.zero)
      toggleHeightAnimator = UIViewPropertyAnimator(duration: 0.0, timingParameters: spring)
      toggleHeightAnimator?.addAnimations(animations)
      toggleHeightAnimator?.addAnimations(textTransition, delayFactor: 0.5)
      toggleHeightAnimator?.startAnimation()
    }

    widgetView.expanded = showsMore
    widgetView.reload()
  }
}
