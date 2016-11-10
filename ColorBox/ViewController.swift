//
//  ViewController.swift
//  ColorBox
//
//  Created by Connor Fitzpatrick on 3/29/16.
//  Copyright © 2016 Connor Fitzpatrick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    var colors: [ColorBox] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ColorClient.sharedClient.getColors { [weak self](colors) in
            self?.colors = colors
            
            DispatchQueue.main.async(execute: {
                
            self?.tableView.reloadData()
                
                if colors.count > 0 {
                    self?.selected(colors.first!.color)
                }
            })
        }
    }
    func selected(_ color: UIColor) {
        headerView.backgroundColor = color
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "colorcell", for: indexPath) as! ColorBoxTableViewCell
        
        let color = colors[(indexPath as NSIndexPath).row]
        cell.configure(color)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let topSpace: CGFloat = 13
        let topLabelHeight: CGFloat = 21
        let topLabelSpacing: CGFloat = 7
        let font = UIFont(name: "Helvetica", size: 17.0)!
        
        let color = colors[(indexPath as NSIndexPath).row]
        let textRect = (color.desc as NSString).boundingRect(with: CGSize(width: 240, height: 9999), options: [.usesLineFragmentOrigin], attributes: [NSFontAttributeName: font], context: NSStringDrawingContext())
        let textHeight: CGFloat = textRect.height
        
        return topSpace + topLabelHeight + topLabelSpacing + textHeight + topSpace
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: headerView.frame.height)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let color = colors[(indexPath as NSIndexPath).row]
        
        selected(color.color)
    }
}
