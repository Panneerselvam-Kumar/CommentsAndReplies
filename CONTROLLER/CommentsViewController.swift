//
//  CommentsViewController.swift
//  CommentsAndReplies
//
//  Created by QOL on 21/10/20.
//  Copyright © 2020 QOL. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var x = CGFloat()
    var y = CGFloat()
    
    let commentsTableView = UITableView()
    var selectedIndex = -1
    
    var namesArray = [String]()
        
    var sectionHeading = [String]()
    var replyArray = [String]()
    
    var commentsAndReply = [String : Any]()
    
    override func viewDidLoad()
    {
        x = 10 / 375 * 100
         x = x * view.frame.width / 100
         
         y = 10 / 667 * 100
         y = y * view.frame.height / 100
        
        view.backgroundColor = UIColor.white
        
        guard let path = Bundle.main.path(forResource: "Comments", ofType: "json") else { return }

        let url = URL(fileURLWithPath: path)

        do {

            let data = try Data(contentsOf: url)

            let json = try JSON(data: data)
            
            let dict = json["Comments"]
            
            for i in 0..<dict.count
            {
                let comments = dict["\(i + 1)"]["comment"].string
                
                let replies = dict["\(i + 1)"]["reply"].arrayObject
                
                commentsAndReply[comments!] = replies
            }
        } catch {

            print("ERROR", error)
        }
                
        screenContents()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func screenContents()
    {
        let headingLabel = UILabel()
        headingLabel.frame = CGRect(x: 0, y: (5 * y), width: view.frame.width, height: (5 * y))
        headingLabel.text = "Comments"
        headingLabel.textColor = UIColor.black
        headingLabel.textAlignment = .center
        headingLabel.font = UIFont(name: "Avenir Black", size: (3 * x))
        view.addSubview(headingLabel)
        
        commentsTableView.frame = CGRect(x: 0, y: headingLabel.frame.maxY + y, width: view.frame.width, height: view.frame.height - (headingLabel.frame.maxY + (3 * y)))
        commentsTableView.dataSource = self
        commentsTableView.delegate = self
        commentsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        commentsTableView.separatorStyle = .none
        view.addSubview(commentsTableView)
        
        commentsTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return commentsAndReply.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if selectedIndex == section
        {
            let name = Array(commentsAndReply)[section].value as? NSArray
            return name!.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let name = Array(commentsAndReply)[indexPath.section].value as? NSArray
        
        let nameString = name![indexPath.row] as? String
        
        let nameArray = nameString?.components(separatedBy: ":")
        
        let att1 = [NSAttributedString.Key.font : UIFont(name: "Avenir Heavy", size: (1.25 * x)), NSAttributedString.Key.foregroundColor : UIColor.red]

        let att2 = [NSAttributedString.Key.font : UIFont(name: "Avenir Heavy", size: (1.25 * x)), NSAttributedString.Key.foregroundColor : UIColor.black]

        let attributedString1 = NSMutableAttributedString(string:nameArray![0], attributes:att1 as [NSAttributedString.Key : Any])

        let attributedString2 = NSMutableAttributedString(string:nameArray![1], attributes:att2 as [NSAttributedString.Key : Any])

        attributedString1.append(attributedString2)
        
        if selectedIndex == indexPath.section
        {
            if indexPath.row == 0
            {
                cell.textLabel?.attributedText = attributedString1
//                cell.textLabel?.text = name![indexPath.row] as? String
            }
            else
            {
                cell.textLabel?.attributedText = attributedString1
//                cell.textLabel?.text = name![indexPath.row] as? String
            }
        }
        else
        {
            cell.textLabel?.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        let name = Array(commentsAndReply)[section].key
        print("NAME", name)
        
        let reply = Array(commentsAndReply)[section].value as! NSArray
        
        let tapButton = UIButton()
        tapButton.frame = cell?.frame as! CGRect
        tapButton.setTitle("\(name)     (\(reply.count) Replies)", for: .normal)
        tapButton.setTitleColor(UIColor.black, for: .normal)
        tapButton.tag = section
        tapButton.contentHorizontalAlignment = .left
        tapButton.addTarget(self, action: #selector(self.buttonAction(sender:)), for: .touchUpInside)
        cell?.addSubview(tapButton)
        
        let arrowImageView = UIImageView()
        arrowImageView.frame = CGRect(x: (cell?.frame.width)! - (2 * x), y: y, width: (2 * x), height: (2 * y))
        cell?.addSubview(arrowImageView)
        
        if selectedIndex == section
        {
            tapButton.titleLabel?.font = UIFont(name: "Avenir Heavy", size: (1.5 * x))
            cell?.backgroundColor = UIColor.lightGray
            arrowImageView.image = UIImage(named: "downArrow")
        }
        else
        {
            tapButton.titleLabel?.font = UIFont(name: "Avenir Medium", size: (1.5 * x))
            cell?.backgroundColor = UIColor.clear
            arrowImageView.image = UIImage(named: "rightArrow")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndex == indexPath.section
        {
            selectedIndex = -1
        }
        else
        {
            selectedIndex = indexPath.section
        }
    }
    
    @objc func buttonAction(sender : UIButton)
    {
        if selectedIndex == sender.tag
        {
            selectedIndex = -1
        }
        else
        {
            selectedIndex = sender.tag
        }
        
        print("BUTTON SECTION", sender.tag)
        commentsTableView.reloadData()
        commentsTableView.beginUpdates()
        commentsTableView.endUpdates()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
