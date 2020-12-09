//
//  DetailViewController.swift
//  RickAndMortyCombineApp
//
//  Created by Пазин Даниил on 23.11.2020.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    
    // MARK: - Constants and Variables
    
    var character: Character? {
      didSet {
        configureView()
      }
    }
    
    // MARK: - View Controller
    
    override func viewDidLoad() {
      super.viewDidLoad()
      
      configureView()
    }
    
    // MARK: - Methods
    
    func configureView() {
      if let character = character,
        let detailDescriptionLabel = detailDescriptionLabel,
        let characterImageView = characterImageView {
        detailDescriptionLabel.text = character.name
        characterImageView.kf.setImage(with: URL(string: character.image))
        title = character.species
      }
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
