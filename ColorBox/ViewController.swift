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
            
            dispatch_async(dispatch_get_main_queue(), {
                
            self?.tableView.reloadData()
                
                if colors.count > 0 {
                    self?.selected(colors.first!.color)
                }
            })
        }
    }
    func selected(color: UIColor) {
        headerView.backgroundColor = color
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("colorcell", forIndexPath: indexPath) as! ColorBoxTableViewCell
        
        let color = colors[indexPath.row]
        cell.configure(color)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let topSpace: CGFloat = 13
        let topLabelHeight: CGFloat = 21
        let topLabelSpacing: CGFloat = 7
        let font = UIFont(name: "Helvetica", size: 17.0)!
        
        let color = colors[indexPath.row]
        let textRect = (color.desc as NSString).boundingRectWithSize(CGSize(width: 240, height: 9999), options: [.UsesLineFragmentOrigin], attributes: [NSFontAttributeName: font], context: NSStringDrawingContext())
        let textHeight: CGFloat = textRect.height
        
        return topSpace + topLabelHeight + topLabelSpacing + textHeight + topSpace
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: headerView.frame.height)
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let color = colors[indexPath.row]
        
        selected(color.color)
    }
}