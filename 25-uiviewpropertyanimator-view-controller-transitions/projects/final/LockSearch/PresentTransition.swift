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

class PresentTransition: UIPercentDrivenInteractiveTransition,
  UIViewControllerAnimatedTransitioning {
  var auxAnimations: (() -> Void)?
  var animator: UIViewPropertyAnimator?

  func transitionDuration(
    using transitionContext: UIViewControllerContextTransitioning?
  ) -> TimeInterval {
    return 0.75
  }

  func animateTransition(
    using transitionContext: UIViewControllerContextTransitioning
  ) {
    transitionAnimator(using: transitionContext).startAnimation()
  }

  func transitionAnimator(
    using transitionContext: UIViewControllerContextTransitioning
  ) -> UIViewImplicitlyAnimating {
    let duration = transitionDuration(using: transitionContext)

    let container = transitionContext.containerView
    guard let toView = transitionContext.view(forKey: .to) else {
      return UIViewPropertyAnimator()
    }

    container.addSubview(toView)
    toView.transform = CGAffineTransform(scaleX: 1.33, y: 1.33)
      .concatenating(CGAffineTransform(translationX: 0.0, y: 200))
    toView.alpha = 0

    let animator = UIViewPropertyAnimator(duration: duration, curve: .easeOut)

    animator.addAnimations({
      toView.transform = CGAffineTransform(translationX: 0.0, y: 100)
    }, delayFactor: 0.15)

    animator.addAnimations({
      toView.alpha = 1.0
    }, delayFactor: 0.5)

    animator.addCompletion { position in
      switch position {
      case .end:
        transitionContext.completeTransition(
          !transitionContext.transitionWasCancelled)
      default:
        transitionContext.completeTransition(false)
      }
    }

    if let auxAnimations = auxAnimations {
      animator.addAnimations(auxAnimations)
    }

    self.animator = animator

    animator.addCompletion { [unowned self] _ in
      self.animator = nil
    }

    animator.isUserInteractionEnabled = true
    return animator
  }

  func interruptibleAnimator(
    using transitionContext: UIViewControllerContextTransitioning
  ) -> UIViewImplicitlyAnimating {
    return animator ?? transitionAnimator(using: transitionContext)
  }
}
