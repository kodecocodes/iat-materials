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

class SideMenuViewController: UITableViewController {
  
  var centerViewController: CenterViewController!
  var headerHeight: CGFloat = 0

  // MARK: UITableViewDataSource
  
  override func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int {
    return MenuItem.sharedItems.count
  }
  
  override func tableView(_ tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for:indexPath) as UITableViewCell
    
    let menuItem = MenuItem.sharedItems[indexPath.row]
    cell.textLabel?.backgroundColor = .clear
    cell.textLabel?.textColor = .white
    cell.textLabel?.font = UIFont(name: "Helvetica", size: 36.0)
    cell.textLabel?.textAlignment = .center
    cell.textLabel?.text = menuItem.symbol
    
    cell.contentView.backgroundColor = menuItem.color
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView  {
    return tableView.dequeueReusableCell(withIdentifier: "HeaderCell")!
  }
  
  // MARK: UITableViewDelegate
  
  override func tableView(_ tableView:UITableView, didSelectRowAt indexPath:IndexPath) {
    tableView.deselectRow(at: indexPath, animated:true)
    
    centerViewController.menuItem = MenuItem.sharedItems[indexPath.row]
    
    let containerVC = parent as! ContainerViewController
    containerVC.toggleSideMenu()
  }
  
  override func tableView(_ tableView:UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat {
    return 84.0
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return headerHeight
  }
}
