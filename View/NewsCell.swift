//
//  NewsCell.swift
//  FluperTest
//
//  Created by Sandeep on 7/13/20.
//  Copyright © 2020 SandMan. All rights reserved.
//

import UIKit
import Kingfisher
import CoreData

class NewsCell: UITableViewCell {

    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(data: NSManagedObject){
        self.titleLbl.text = data.value(forKey: "newsTitle") as? String
        self.descLbl.text = data.value(forKey: "newsDescription") as? String
        if let imgUrl = data.value(forKey: "newsImage") as? String{
            self.newsImg.kf.indicatorType = .activity
            self.newsImg.kf.setImage(with: URL(string: imgUrl), placeholder: UIImage(named: "placeholder"))
        }
        
    }
}
