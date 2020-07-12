//
//  ViewController.swift
//  FluperTest
//
//  Created by Sandeep on 7/12/20.
//  Copyright © 2020 SandMan. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 13.0, *)
class ViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Properties
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var newsData: [NSManagedObject] = []
    private unowned var dataService = DataService.instance
    let newsEndpoint = "https://newsapi.org/v2/top-headlines?country=us&apiKey=cfd7271d404643af8f50cab38d282eee"
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 200
        self.title = "News"
        self.getNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchSavedData()
    }
    
    //MARK:- Helpers
    
    func fetchSavedData(){
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "News")
        do {
          newsData = try managedContext.fetch(fetchRequest)
          self.tableView.reloadData()
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func saveNews(news: NewsResponse){
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "News", in: managedContext)!
        let temp = NSManagedObject(entity: entity, insertInto: managedContext)
        temp.setValue(news.title, forKeyPath: "newsTitle")
        temp.setValue(news.description, forKeyPath: "newsDescription")
        temp.setValue(news.urlToImage, forKeyPath: "newsImage")
        do {
          try managedContext.save()
            newsData.append(temp)
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getNews(){
        dataService.getRequest(url: self.newsEndpoint) { (status, data) in
            if status{
                if let articles = data?.value(forKey: "articles") as? [NSDictionary]{
                    articles.forEach { (article) in
                        let title = article.value(forKey: "title") as? String
                        let desc = article.value(forKey: "description") as? String
                        let imgUrl = article.value(forKey: "urlToImage") as? String
                        
                        let temp = NewsResponse(title: title, description: desc, urlToImage: imgUrl)
                        self.saveNews(news: temp)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }else{
                let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
        }
    }
    
}

@available(iOS 13.0, *)
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell") as! NewsCell
        let data = self.newsData[indexPath.row]
        cell.setData(data: data)
        return cell
    }
}
