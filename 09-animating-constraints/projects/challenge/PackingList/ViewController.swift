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

class ViewController: UIViewController {
  
  //MARK: IB outlets
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var buttonMenu: UIButton!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
  
  //MARK: further class variables
  
  var slider: HorizontalItemList!
  var isMenuOpen = false
  var items: [Int] = [5, 6, 7]
  
  //MARK: class methods
  
  @IBAction func actionToggleMenu(_ sender: AnyObject) {
    
    titleLabel.superview?.constraints.forEach { constraint in
      print(" -> \(constraint.description)\n")
    }
    
    isMenuOpen = !isMenuOpen
    titleLabel.superview?.constraints.forEach { constraint in
      if constraint.firstItem === titleLabel &&
        constraint.firstAttribute == .centerX {
        constraint.constant = isMenuOpen ? -100.0 : 0.0
        return
      }
      if constraint.identifier == "TitleCenterY" {
        constraint.isActive = false
        let newConstraint = NSLayoutConstraint(
          item: titleLabel!,
          attribute: .centerY,
          relatedBy: .equal,
          toItem: titleLabel.superview!,
          attribute: .centerY,
          multiplier: isMenuOpen ? 0.67 : 1.0,
          constant: 0)
        newConstraint.identifier = "TitleCenterY"
        newConstraint.isActive = true
        return
      }
    }
    menuHeightConstraint.constant = isMenuOpen ? 184.0 : 44.0
    titleLabel.text = isMenuOpen ? "Select Item" : "Packing List"
    
    UIView.animate(withDuration: 1.0, delay: 0.0,
                   usingSpringWithDamping: 0.4, initialSpringVelocity: 10.0,
                   options: .curveEaseIn,
                   animations: {
                    self.view.layoutIfNeeded()
                    let angle: CGFloat = self.isMenuOpen ? .pi / 4 : 0.0
                    self.buttonMenu.transform = CGAffineTransform(rotationAngle: angle)
    },
                   completion: nil
    )
    
    if isMenuOpen {
      slider = HorizontalItemList(inView: view)
      slider.didSelectItem = {index in
        print("add \(index)")
        self.items.append(index)
        self.tableView.reloadData()
        self.actionToggleMenu(self)
      }
      self.titleLabel.superview!.addSubview(slider)
    } else {
      slider.removeFromSuperview()
    }
  }
  
  func showItem(_ index: Int) {
    print("tapped item \(index)")
    let imageView = UIImageView(image: UIImage(named: "summericons_100px_0\(index).png"))
    imageView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
    imageView.layer.cornerRadius = 5.0
    imageView.layer.masksToBounds = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(imageView)
    
    let conX = imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    let conBottom = imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: imageView.frame.height)
    let conWidth = imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.33, constant: -50.0)
    let conHeight = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
    
    NSLayoutConstraint.activate([conX, conBottom, conWidth, conHeight])
    
    view.layoutIfNeeded()
    
    UIView.animate(withDuration: 0.8, delay: 0.0,
                   usingSpringWithDamping:  0.4, initialSpringVelocity: 0.0,
                   animations: {
                    conBottom.constant = -imageView.frame.size.height/2
                    conWidth.constant = 0.0
                    self.view.layoutIfNeeded()
    },
                   completion: nil
    )
    
    UIView.animate(withDuration: 0.8, delay: 1.0, usingSpringWithDamping: 0.4,
                   initialSpringVelocity: 0.0,
                   animations: {
                    conBottom.constant = imageView.frame.size.height
                    conWidth.constant = -50.0
                    self.view.layoutIfNeeded()
    }, completion: { _ in
      imageView.removeFromSuperview()
    })
  }
}


let itemTitles = ["Icecream money", "Great weather", "Beach ball", "Swim suit for him", "Swim suit for her", "Beach games", "Ironing board", "Cocktail mood", "Sunglasses", "Flip flops"]

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  
  // MARK: View Controller methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView?.rowHeight = 54.0
  }
  
  // MARK: Table View methods
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
    cell.accessoryType = .none
    cell.textLabel?.text = itemTitles[items[indexPath.row]]
    cell.imageView?.image = UIImage(named: "summericons_100px_0\(items[indexPath.row]).png")
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    showItem(items[indexPath.row])
  }
  
}
