//
//  ViewController.swift
//  projectX
//
//  Created by Eli Bunimovich on 16/11/2017.
//  Copyright © 2017 Eli Bunimovich. All rights reserved.
//

import UIKit

var allRep = [NSDictionary()]
var currentRep = [NSDictionary()]

var currentLogin = String()
var currentAvatarUrl = String()
var currentDescription = String()
var currentStargazersCount = String()
var currentLanguage = String()
var currentForks = String()
var currentCreatedAt = String()
var currentHtmlUrl = String()
var mainColor = UIColor()
var currentRepIndex = 0

class ViewController: UIViewController, UISearchBarDelegate, UITabBarDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var repTableView: UITableView!
    
    var repDay = String()
    var repMonth = String()
    var repYear = String()
    var segmentControllerSender = 0
    var reloadTableView = false
    var reachedToBottom = true
    var sortOn = true
    var mySegmentedControl = UISegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allRep.removeAll()
        currentRep.removeAll()
        
        mainColor = UIColor(red: 28/255, green: 28/255, blue: 32/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = mainColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white
        self.title = "Trending Repositories"
        
        //Segmented Control
        mySegmentedControl = UISegmentedControl (items: ["Last Day","Last Month","Last Year"])
        mySegmentedControl.frame = CGRect(x: 20, y: 0, width: view.frame.width - 40, height: 30)
        mySegmentedControl.selectedSegmentIndex = 0
        mySegmentedControl.tintColor = .black
        mySegmentedControl.addTarget(self, action: #selector(ViewController.segmentedValueChanged(_:)), for: .valueChanged)
        view.addSubview(mySegmentedControl)
        
        self.repTableView.rowHeight = 177.0
        repTableView.frame = CGRect(x: 0, y: 64, width: view.frame.width, height: view.frame.height)
        
        getDate()
    
    }
    
    //User changing the time sort of the repositories.
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!) {
        segmentControllerSender = sender.selectedSegmentIndex
        getDate()
    }

    //Sort button. including animation.
    @IBAction func button(_ sender: Any) {
        if sortOn {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.mySegmentedControl.frame = CGRect(x: 20, y: 76, width: self.view.frame.width - 40, height: 30)
                self.repTableView.frame = CGRect(x: 0, y: 110, width: self.view.frame.width, height: self.view.frame.height)
            })
            sortOn = false
        } else {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.mySegmentedControl.frame = CGRect(x: 20, y: 0, width: self.view.frame.width - 40, height: 30)
                self.repTableView.frame = CGRect(x: 0, y: 64, width: self.view.frame.width, height: self.view.frame.height)
            })
            sortOn = true
        }
    }
    
    // Check the current date. check which reportsitory sort the user chose. in the end - starts the session function.
    func getDate() {
        let currentDate = NSDate()
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        let currentDay = dayFormatter.string(from: currentDate as Date)
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        let currentMonth = monthFormatter.string(from: currentDate as Date)
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let currentYear = yearFormatter.string(from: currentDate as Date)
        
        switch segmentControllerSender {
        case 0:
            repDay = String(Int(currentDay)! - 1)
            repMonth = currentMonth
            repYear = currentYear
        case 1:
            repDay = String(31 - Int(currentDay)!+1)
            if Int(currentMonth) == 1 {
                repMonth = "12"
                repYear = String(Int(currentYear)! - 1)
            } else {
                repMonth = String(Int(currentMonth)! - 1)
                repYear = currentYear
            }
        default:
            repDay = currentDay
            repMonth = currentMonth
            repYear = String(Int(currentYear)! - 1)
        }
        
        allRep.removeAll()
        currentRep.removeAll()
        
        startSession()
    }
    
    //Gets the data from Github by the sort. when everything is corret - start ordering the repositories in app.
    func startSession() {
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: nil)
        
        guard var urlComponent = URLComponents(string: "https://api.github.com/search/repositories") else { return }
        let items = [
            URLQueryItem(name: "q", value: "created:>\(repYear)-\(repMonth)-\(repDay)"),
            URLQueryItem(name: "sort", value: "stars"),
            URLQueryItem(name: "order", value: "desc")
        ]
        
        urlComponent.queryItems = items
        guard let url = urlComponent.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Headers
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Form URL-Encoded Body
        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    let newArray = json!["items"]
                    let secondArray = newArray as! [NSDictionary]
                    allRep = newArray as! [NSDictionary]
                    self.showRepositories()
                } catch {
                    print(error)
                }
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    //Start showing repositories in the tableView.
    func showRepositories() {
        var addMoreResIndex = 0
        for index in 0...4 {
            currentRep.append(allRep[0])
            
            allRep.remove(at: 0)
            addMoreResIndex += 1
        }
        reloadTableView = true
        
        DispatchQueue.main.async {
            self.repTableView.reloadData()
        }
    }
    
    //Show all the data in the tableView Cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! repTableViewCell
        
        if reloadTableView {
            var fetchRes = currentRep[indexPath.row]
            
            let ownerDetails = fetchRes["owner"] as? [String: Any]
            //User Name
            cell.username.text = ownerDetails!["login"] as! String
            //Description
            let description = fetchRes["description"] as? String
            if description == nil {
                cell.descriptionLabel?.text = "No Description"
            } else {
                cell.descriptionLabel?.text = description
            }
            //Stargazers Count
            let stargazersCount = fetchRes["stargazers_count"]
            cell.stargazerscount.text = "\(String(describing: fetchRes["stargazers_count"]!)) Stars"
            //User Avatar
            cell.avatar.layer.cornerRadius = cell.avatar.frame.width/2
            cell.avatar.layer.masksToBounds = true
            let avatarUrl = URL(string: (ownerDetails!["avatar_url"] as? String)!)
            let data = try? Data(contentsOf: avatarUrl!)
            
            if let imageData = data {
                let image = UIImage(data: data!)
                cell.avatar.image = image
                reachedToBottom = true
            }
        }
        return cell
    }
    
    //Number of section in the tableView by the number of repositories showing.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentRep.count
    }
    
    //Getting data from the specific repository.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fetchRes = currentRep[indexPath.row]
        let ownerDetails = fetchRes["owner"] as? [String: Any]

        currentLogin = ownerDetails!["login"] as! String
        currentAvatarUrl = ownerDetails!["avatar_url"] as! String
        if fetchRes["description"] as? String == nil {
            currentDescription = "No Description"
        } else {
            currentDescription = fetchRes["description"] as! String
        }
        currentStargazersCount = String(describing: fetchRes["stargazers_count"]!)
        if fetchRes["language"] as? String == nil {
            currentLanguage = "-"
        } else {
            currentLanguage = fetchRes["language"] as! String
        }
        print(currentLanguage)
        currentForks = String(describing: fetchRes["forks"]!)
        currentCreatedAt = fetchRes["created_at"] as! String
        currentHtmlUrl = fetchRes["html_url"] as! String
        currentRepIndex = indexPath.row
        
        let currentRepVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "currentRepVC") as! currentRepViewController
        self.navigationController?.pushViewController(currentRepVC, animated: true)
    }
    
    //Height of each Cell in the tableView.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 177.0
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if reachedToBottom {
                reachedToBottom = false
                print(" you reached end of the table")
                showRepositories()
            }
        }
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

