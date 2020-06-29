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

class WidgetView: UIView {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  let items: [String] = ["Bahama Air", "PackMe", "Fight", "Slide", "Iris", "Herbs", "Reveal", "Office"]
  
  var previewInteraction: UIPreviewInteraction?
  var owner: WidgetsOwnerProtocol!
  
  var expanded = false
  
  func reload() {
    collectionView.reloadData()
  }
  
  override func didMoveToWindow() {
    super.didMoveToWindow()

    guard let _ = superview else {
      previewInteraction?.delegate = nil
      return
    }
    
    previewInteraction = UIPreviewInteraction(view: collectionView)
    previewInteraction?.delegate = self
  }
}

//
// MARK: - Peak delegate methods
//
extension WidgetView: UIPreviewInteractionDelegate {
  
  public func previewInteractionDidCancel(_ previewInteraction: UIPreviewInteraction) {
    owner.cancelPreview()
  }
  
  func previewInteractionShouldBegin(_ previewInteraction: UIPreviewInteraction) -> Bool {
    
    if let indexPath = collectionView?.indexPathForItem(at: previewInteraction.location(in: collectionView!)),
      let cell = collectionView?.cellForItem(at: indexPath) as? IconCell {
      
      owner.startPreview(for: cell.icon)
    }
    return true
  }
  
  func previewInteraction(_ previewInteraction: UIPreviewInteraction, didUpdatePreviewTransition transitionProgress: CGFloat, ended: Bool) {
    owner.updatePreview(percent: transitionProgress)
    
    if ended {
      owner.finishPreview()
    }
  }
}

//
// MARK: - Collection View data source
//
extension WidgetView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return expanded ? 8 : 4
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! IconCell
    cell.name.text = items[indexPath.row]
    cell.icon.image = UIImage(named: "icon\(indexPath.row+1)")
    return cell
  }
}

extension WidgetView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: false)
    if let cell = collectionView.cellForItem(at: indexPath) as? IconCell {
      cell.iconJiggle()
    }
  }
}
