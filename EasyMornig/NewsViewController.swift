//
//  DetailViewController.swift
//  Alarm
//
//  Created by Petar Korda on 5/6/17.
//  Copyright © 2017 Cash Me Outside. All rights reserved.
//

import UIKit


class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SPTAudioStreamingDelegate, SpotifyDelegate {
    

    var articles: [Article]?
    var getNews: Bool = false
    var player: SPTAudioStreamingController?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if getNews {
            fetchArticles()
        } else {
            //show not available
            
            tableView.isHidden = true
            
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setPlayer(player: SPTAudioStreamingController?) {
        self.player = player
    }
    
    func audioStreamingDidLogout(_ audioStreaming: SPTAudioStreamingController!) {
        try! player?.stop()
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        if player != nil {
            player!.logout()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticleCell
        
        cell.title.text = self.articles?[indexPath.item].headline
        cell.author.text = self.articles?[indexPath.item].author
        cell.desc.text = self.articles?[indexPath.item].desc
        cell.imgView.downloadImageArticle(from: (self.articles?[indexPath.item].imageUrl)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "web") as! WebViewController
        
        webVC.url = articles?[indexPath.item].url
        
        self.present(webVC , animated: true, completion: nil)
    }
    
    func fetchArticles() {
        let urlRequest = URLRequest(url: URL(string: "https://newsapi.org/v1/articles?source=bbc-news&sortBy=top&apiKey=68ded9f4c51943db9a3bcd4e5edcaa02")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            self.articles = [Article]()
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: AnyObject]
                
                if let articlesFromJson = json["articles"] as? [[String: AnyObject]] {
                    for articleFromJson in articlesFromJson {
                        let article = Article()
                        
                        if let title = articleFromJson["title"] as? String,
                            let author = articleFromJson["author"] as? String,
                            let desc = articleFromJson["description"] as? String,
                            let url = articleFromJson["url"] as? String,
                            let urlImage = articleFromJson["urlToImage"] as? String {
                            
                            article.headline = title
                            article.desc = desc
                            article.url = url
                            article.imageUrl = urlImage
                            article.author = author
                            
                        }
                        self.articles?.append(article)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch let error {
                print(error)
            }
            
        }
        task.resume()
    }
}


extension UIImageView {
    func downloadImageArticle(from url: String) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,responese,error) in
            
            if error != nil {
                print(error ?? "Error in downloading image")
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        }
        task.resume()
    }
}

