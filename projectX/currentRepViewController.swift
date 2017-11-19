//
//  currentRepViewController.swift
//  projectX
//
//  Created by Eli Bunimovich on 19/11/2017.
//  Copyright © 2017 Eli Bunimovich. All rights reserved.
//

import UIKit

class currentRepViewController: UIViewController {
    
    var topSquare = UILabel()
    var starImage = UIImageView()
    var starCount = UILabel()
    var forkImage = UIImageView()
    var forkCount = UILabel()
    var userAvatar = UIImageView()
    var descriptionTextView = UITextView()
    var languageLabel = UILabel()
    var htmlUrl = UIButton()
    var createdAt = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Creating the view programmatically.
        
        self.title = currentLogin
        
        let topBarHeight: CGFloat = 64.0
        topSquare.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        topSquare.backgroundColor = mainColor
        topSquare.alpha = 0.1
        view.addSubview(topSquare)
        
        starImage.frame = CGRect(x: 0, y: topBarHeight + 20, width: view.frame.width/2, height: 30)
        starImage.image = #imageLiteral(resourceName: "star")
        starImage.contentMode = .scaleAspectFit
        view.addSubview(starImage)
        
        starCount.frame = CGRect(x: 0, y: starImage.frame.maxY, width: view.frame.width/2, height: 30)
        starCount.text = currentStargazersCount
        starCount.textAlignment = .center
        view.addSubview(starCount)
        
        forkImage.frame = CGRect(x: view.frame.width/2, y: topBarHeight + 20, width: view.frame.width/2, height: 30)
        forkImage.image = #imageLiteral(resourceName: "fork")
        forkImage.contentMode = .scaleAspectFit
        view.addSubview(forkImage)
        
        forkCount.frame = CGRect(x: view.frame.width/2, y: forkImage.frame.maxY, width: view.frame.width/2, height: 30)
        forkCount.text = currentForks
        forkCount.textAlignment = .center
        view.addSubview(forkCount)
        
        userAvatar.frame = CGRect(x: view.frame.width/2 - 45, y: topSquare.frame.maxY - 45, width: 90, height: 90)
        userAvatar.layer.cornerRadius = userAvatar.frame.width/2
        userAvatar.layer.masksToBounds = true
        let url = URL(string: currentAvatarUrl)
        let data = try? Data(contentsOf: url!)
        if let imageData = data {
            let image = UIImage(data: data!)
            userAvatar.image = image
        }
        view.addSubview(userAvatar)
        
        descriptionTextView.frame = CGRect(x: 10, y: userAvatar.frame.maxY, width: view.frame.width - 20, height: 200)
        descriptionTextView.text = currentDescription
        descriptionTextView.font = UIFont(name: (descriptionTextView.font?.fontName)!, size: 24)
        view.addSubview(descriptionTextView)
        
        languageLabel.frame = CGRect(x: -1, y: view.frame.height - 150, width: view.frame.width + 2, height: 50)
        languageLabel.text = "Language: \(currentLanguage)"
        languageLabel.textAlignment = .center
        view.addSubview(languageLabel)
        
        let line1 = UILabel()
        line1.frame = CGRect(x: 0, y: languageLabel.frame.minY, width: view.frame.width, height: 0.5)
        line1.backgroundColor = .black
        line1.alpha = 0.5
        view.addSubview(line1)
        
        
        let line2 = UILabel()
        line2.frame = CGRect(x: 30, y: languageLabel.frame.maxY, width: view.frame.width - 60, height: 0.5)
        line2.backgroundColor = .black
        line2.alpha = 0.5
        view.addSubview(line2)
        
        htmlUrl.frame = CGRect(x: -1, y: view.frame.height - 100, width: view.frame.width + 2, height: 50)
        htmlUrl.setTitle("Go to Repository Github Site", for: .normal)
        htmlUrl.setTitleColor(.black, for: .normal)
        htmlUrl.addTarget(self, action: #selector(goToGithub), for: .touchUpInside)
        view.addSubview(htmlUrl)
        
        let line3 = UILabel()
        line3.frame = CGRect(x: 30, y: htmlUrl.frame.maxY, width: view.frame.width - 60, height: 0.5)
        line3.backgroundColor = .black
        line3.alpha = 0.5
        view.addSubview(line3)
        
        createdAt.frame = CGRect(x: -1, y: view.frame.height - 50, width: view.frame.width + 2, height: 50)
        createdAt.text = "Created at: \(currentCreatedAt)"
        createdAt.textAlignment = .center
        view.addSubview(createdAt)
    }
    
    //Function that send the user to the original site of the repository in Github.
    @objc func goToGithub() {
        UIApplication.shared.openURL(NSURL(string: currentHtmlUrl)! as URL)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
