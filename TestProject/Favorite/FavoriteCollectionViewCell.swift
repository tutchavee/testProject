//
//  FavoriteCollectionViewCell.swift
//  TestProject
//
//  Created by Bas on 24/8/2565 BE.
//

import UIKit

class FavoriteCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var contentImageView: UIImageView!
//    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
//    @IBOutlet weak var scoreLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setMovieDataCell(movie: MovieModel) {
        titleLabel.text = movie.title
        subTitleLabel.text = movie.synopsis
        do {
            let url = try? movie.images.jpg.image_url.asURL()
            contentImageView.kf.setImage(with: url)
        }
        
//        scoreLabel.text = "Score \(movie.score)/10"
        
//        starImageView.image = UIImage(named: isFavorite ? "starlight" : "star")
    }

}
