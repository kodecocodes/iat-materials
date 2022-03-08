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

class RevealAnimator: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
  let animationDuration = 2.0
  var operation: UINavigationController.Operation = .push
  var interactive = false

  weak var storedContext: UIViewControllerContextTransitioning?

  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return animationDuration
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    if interactive && isLayerBased {
      let transitionLayer = transitionContext.containerView.layer
      pausedTime = transitionLayer.convertTime(CACurrentMediaTime(), from: nil)
      transitionLayer.speed = 0
      transitionLayer.timeOffset = pausedTime
    }

    storedContext = transitionContext

    if
      operation == .push,
      let fromVC = transitionContext
        .viewController(forKey: .from) as? MainViewController,
      let toVC = transitionContext
        .viewController(forKey: .to) as? DetailViewController {
      transitionContext.containerView.addSubview(toVC.view)
      toVC.view.frame = transitionContext.finalFrame(for: toVC)

      let animation = CABasicAnimation(keyPath: "transform")
      animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
      animation.toValue = NSValue(caTransform3D: CATransform3DConcat(
        CATransform3DMakeTranslation(0.0, -10.0, 0.0),
        CATransform3DMakeScale(150.0, 150.0, 1.0)
      ))

      animation.duration = animationDuration
      animation.delegate = self
      animation.fillMode = .forwards
      animation.isRemovedOnCompletion = false
      animation.timingFunction = CAMediaTimingFunction(name: .easeIn)

      let maskLayer: CAShapeLayer = RWLogoLayer.logoLayer()
      maskLayer.position = fromVC.logo.position
      toVC.view.layer.mask = maskLayer
      maskLayer.add(animation, forKey: nil)

      fromVC.logo.add(animation, forKey: nil)

      let fadeIn = CABasicAnimation(keyPath: "opacity")
      fadeIn.fromValue = 0.0
      fadeIn.toValue = 1.0
      fadeIn.duration = animationDuration
      toVC.view.layer.add(fadeIn, forKey: nil)
    } else if
      operation == .pop,
      let fromView = transitionContext.view(forKey: .from),
      let toView = transitionContext.view(forKey: .to) {
      transitionContext.containerView.insertSubview(toView, belowSubview: fromView)

      UIView.animate(
        withDuration: animationDuration,
        delay: 0.0,
        options: .curveEaseIn,
        animations: {
          fromView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion: { _ in
          transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
  }

  override func update(_ percentComplete: CGFloat) {
    super.update(percentComplete)
    if isLayerBased {
      let animationProgress = TimeInterval(animationDuration) * TimeInterval(percentComplete)
      storedContext?.containerView.layer.timeOffset =
        pausedTime + animationProgress
    }
  }

  override func cancel() {
    if isLayerBased {
      restart(forFinishing: false)
    }
    super.cancel()
  }

  override func finish() {
    if isLayerBased {
      restart(forFinishing: true)
    }
    super.finish()
  }

  private func restart(forFinishing: Bool) {
    let transitionLayer = storedContext?.containerView.layer
    transitionLayer?.beginTime = CACurrentMediaTime()
    transitionLayer?.speed = forFinishing ? 1 : -1
  }

  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if let context = storedContext {
      context.completeTransition(!context.transitionWasCancelled)
      // reset logo
      let fromVC = context.viewController(forKey: .from) as? MainViewController
      fromVC?.logo.removeAllAnimations()

      let toVC = context.viewController(forKey: .to) as? DetailViewController
      toVC?.view.layer.mask = nil
    }
    storedContext = nil
  }

  func handlePan(_ recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: recognizer.view)
    var progress: CGFloat = abs(translation.x / 200.0)
    progress = min(max(progress, 0.01), 0.99)
    switch recognizer.state {
    case .changed:
      update(progress)
    case .cancelled, .ended:
      if progress < 0.5 {
        cancel()
      } else {
        finish()
      }
      interactive = false
    default:
      break
    }
  }

  private var pausedTime: CFTimeInterval = 0
  private var isLayerBased: Bool {
    return operation == .push
  }
}
