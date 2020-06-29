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

func delay(seconds: Double, completion: @escaping ()-> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

let kRefreshViewHeight: CGFloat = 110.0
let packItems = ["Ice cream money", "Great weather", "Beach ball", "Swimsuit for him", "Swimsuit for her", "Beach games", "Ironing board", "Cocktail mood", "Sunglasses", "Flip flops", "Spare flip flops"]

class ViewController: UITableViewController, RefreshViewDelegate {
  
  var refreshView: RefreshView!
  
  // MARK: View controller methods
  override func viewDidLoad() {
    
    self.title = "Vacation pack list"
    self.view.backgroundColor = UIColor(red: 0.0, green: 154.0/255.0, blue: 222.0/255.0, alpha: 1.0)
    self.tableView.rowHeight = 64.0
    
    let refreshRect = CGRect(x: 0.0, y: -kRefreshViewHeight, width: view.frame.size.width, height: kRefreshViewHeight)
    refreshView = RefreshView(frame: refreshRect, scrollView: self.tableView)
    refreshView.delegate = self
    view.addSubview(refreshView)
  }
  
  // MARK: Refresh control methods
  func refreshViewDidRefresh(_ refreshView: RefreshView) {
    delay(seconds: 4) {
      refreshView.endRefreshing()
    }
  }
  
  // MARK: Scroll view methods
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    refreshView.scrollViewDidScroll(scrollView)
  }
  
  override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
  }
  
  // MARK: Table View methods
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 11
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
    cell.accessoryType = .none
    cell.textLabel!.text = packItems[indexPath.row]
    cell.imageView!.image = UIImage(named: "summericons_100px_\(indexPath.row).png")
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
