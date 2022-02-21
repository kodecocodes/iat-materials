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

let herbs = HerbModel.all()

class ViewController: UIViewController {
  @IBOutlet var listView: UIScrollView!
  @IBOutlet var bgImage: UIImageView!
  var selectedImage: UIImageView?

  let transition = PopAnimator()

  // MARK: UIViewController

  override func viewDidLoad() {
    super.viewDidLoad()

    transition.dismissCompletion = {
      self.selectedImage?.isHidden = false
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if listView.subviews.count < herbs.count {
      while let view = listView.viewWithTag(0) {
        view.tag = 1000 // prevent confusion when looking up images
      }
      setupList()
    }
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  // MARK: View setup

  // add all images to the list
  func setupList() {
    for i in herbs.indices {
      // create image view
      let imageView = UIImageView(image: UIImage(named: herbs[i].image))
      imageView.tag = i
      imageView.contentMode = .scaleAspectFill
      imageView.isUserInteractionEnabled = true
      imageView.layer.cornerRadius = 20.0
      imageView.layer.masksToBounds = true
      listView.addSubview(imageView)

      // attach tap detector
      imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImageView)))
    }

    listView.backgroundColor = UIColor.clear
    positionListItems()
  }

  // position all images inside the list
  func positionListItems() {
    let listHeight = listView.frame.height
    let itemHeight: CGFloat = listHeight * 1.33
    let aspectRatio = UIScreen.main.bounds.height / UIScreen.main.bounds.width
    let itemWidth: CGFloat = itemHeight / aspectRatio

    let horizontalPadding: CGFloat = 10.0

    for i in herbs.indices {
      guard let imageView = listView.viewWithTag(i) as? UIImageView else { continue }
      imageView.frame = CGRect(
        x: CGFloat(i) * itemWidth + CGFloat(i + 1) * horizontalPadding,
        y: 0.0,
        width: itemWidth,
        height: itemHeight)
    }

    listView.contentSize = CGSize(
      width: CGFloat(herbs.count) * (itemWidth + horizontalPadding) + horizontalPadding,
      height: 0)
  }

  // MARK: Actions

  @objc func didTapImageView(_ tap: UITapGestureRecognizer) {
    selectedImage = tap.view as? UIImageView

    guard let index = selectedImage?.tag else { return }
    let selectedHerb = herbs[index]

    // present details view controller
    guard let herbDetails = storyboard?.instantiateViewController(
      identifier: "HerbDetailsViewController", creator: { coder in
        HerbDetailsViewController(coder: coder, herb: selectedHerb)
      }) else {
      return
    }
    herbDetails.modalPresentationStyle = .overFullScreen
    herbDetails.transitioningDelegate = self
    present(herbDetails, animated: true, completion: nil)
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)

    coordinator.animate(alongsideTransition: { _ in
      self.bgImage.alpha = (size.width > size.height) ? 0.25 : 0.55
      self.positionListItems()
    }, completion: nil)
  }
}

extension ViewController: UIViewControllerTransitioningDelegate {
  func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController,
    source: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    guard let selectedImage = selectedImage else {
      return nil
    }
    transition.originFrame = selectedImage.convert(selectedImage.bounds, to: nil)

    transition.presenting = true
    selectedImage.isHidden = true

    return transition
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.presenting = false
    return transition
  }
}
