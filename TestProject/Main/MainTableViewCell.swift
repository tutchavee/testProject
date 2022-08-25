//
//  MainTableViewCell.swift
//  TestProject
//
//  Created by Bas on 24/8/2565 BE.
//

import UIKit
import Kingfisher

protocol MainTableViewCellProtocol: NSObjectProtocol {
    func mainTableViewCellProtocolFavorite(movie: MovieModel)
}

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var starImageView: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var movieModel: MovieModel?
    
    weak var delegate: MainTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        starImageView.setImage(UIImage(named: "star"), for: .normal)
        starImageView.setImage(UIImage(named: "starlight"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func favoriteAction(_ sender: Any) {
        if let movieModel = movieModel {
            delegate?.mainTableViewCellProtocolFavorite(movie: movieModel)
        }
    }
    
    func setMovieDataCell(movie: MovieModel, isFavorite: Bool) {
        movieModel = movie
        titleLabel.text = movie.title
        subTitleLabel.text = movie.synopsis
        do {
            let url = try? movie.images.jpg.image_url.asURL()
            contentImageView.kf.setImage(with: url)
        }
        
        if let score = movie.score {
            scoreLabel.isHidden = false
            scoreLabel.text = "Score \(score.string)/10"
        } else {
            scoreLabel.isHidden = true
        }
        
        starImageView.isSelected = isFavorite
    }
    
}
