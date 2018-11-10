//
//  DetailViewController.swift
//  itunesSearch
//
//  Created by Melisa on 23.10.2018.
//  Copyright © 2018 Melisa. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var lblDetail: UILabel!   
    @IBOutlet weak var imgDetail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgDetail.translatesAutoresizingMaskIntoConstraints = false
        lblDetail.translatesAutoresizingMaskIntoConstraints = false
        
        setupLayout()
        
        if searchController.isActive && searchController.searchBar.text != ""
        {
            let cPrice: String = String(format: "%.1f", abs(filteredData[myIndex].collectionPrice!))
            let tPrice: String = String(format: "%.1f", abs(filteredData[myIndex].trackPrice!))
            
            let detail = "Artist Name : " + filteredData[myIndex].artistName! + "\n" +
                "Country : " + filteredData[myIndex].country! + "\n" +
                "Track Name : " + filteredData[myIndex].trackName! + "\n" +
                "Track Price : " + tPrice + "\n" +
                "Collection Name : " + filteredData[myIndex].collectionName! + "\n" +
                "Collection Price : " + cPrice
            
            
            lblDetail.text = detail
            
            let imgString = filteredData[myIndex].artworkUrl100!
            let imgUrl = URL(string: imgString)
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let imageData = try Data(contentsOf: imgUrl!)
                    DispatchQueue.main.async {
                        let image = UIImage(data: imageData)
                        self.imgDetail.image = image
                    }
                } catch let error {
                    print("Error with the image URL: ", error)
                }
            }
        }
        else
        {            
            let cPrice: String = String(format: "%.1f", abs(musicArray[myIndex].collectionPrice!))
            let tPrice: String = String(format: "%.1f", abs(musicArray[myIndex].trackPrice!))
            
            let detail = "Artist Name : " + musicArray[myIndex].artistName! + "\n" +
                "Country : " + musicArray[myIndex].country! + "\n" +
                "Track Name : " + musicArray[myIndex].trackName! + "\n" +
                "Track Price : " + tPrice + "\n" +
                "Collection Name : " + musicArray[myIndex].collectionName! + "\n" +
                "Collection Price : " + cPrice
            
            
            lblDetail.text = detail
            
            let imgString = musicArray[myIndex].artworkUrl100!
            let imgUrl = URL(string: imgString)
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let imageData = try Data(contentsOf: imgUrl!)
                    DispatchQueue.main.async {
                        let image = UIImage(data: imageData)
                        self.imgDetail.image = image
                    }
                } catch let error {
                    print("Error with the image URL: ", error)
                }
            }
        }
        
    }
    
    
    private func setupLayout() {
        let topImageContainerView = UIView()
        view.addSubview(topImageContainerView)
        
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        topImageContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        topImageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topImageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        topImageContainerView.addSubview(imgDetail)
        imgDetail.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        imgDetail.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor).isActive = true
        imgDetail.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.5).isActive = true
        
        
        topImageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
        lblDetail.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor).isActive = true
        lblDetail.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        lblDetail.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        lblDetail.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        imgDetail.leftAnchor.constraint(equalTo: topImageContainerView.leftAnchor, constant: 50).isActive = true
        imgDetail.rightAnchor.constraint(equalTo: topImageContainerView.rightAnchor, constant: -50) .isActive = true        
    }
}
