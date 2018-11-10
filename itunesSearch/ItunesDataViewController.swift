//
//  ItunesDataViewController.swift
//  itunesSearch
//
//  Created by Melisa on 20.10.2018.
//  Copyright © 2018 Melisa. All rights reserved.
//

import UIKit

struct ApiResults:Decodable {
    let resultCount: Int
    let results: [Music]
}

struct Music:Decodable {
    let trackName: String?
    let artistName: String?
    let artworkUrl60: String?
    let artworkUrl100: String?
    let collectionName: String?
    let collectionPrice: Double?
    let trackPrice: Double?
    let country: String?
}

var myIndex = 0
var filteredData:[Music] = []
var musicArray:[Music] = []
let searchController = UISearchController(searchResultsController: nil)

class ItunesDataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating  {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        getData()
        serachControllerSetup()
        
        searchController.hidesNavigationBarDuringPresentation = true
        definesPresentationContext = true
    }
    
    func getData()
    {
        let term = "rain"
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(term)&country=US&media=music&limit=100") else {return}
        URLSession.shared.dataTask(with: url){(data, response, error) in
            guard let data = data else {return}
            
            do
            {
                let apiressults = try JSONDecoder().decode(ApiResults.self, from: data)
                //                print(apiressults.results)
                print(apiressults.resultCount)
                musicArray = apiressults.results
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch let jsonError
            {
                print("Error:", jsonError)
            }
            }.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {        
        print("\n\nsearchText : \(searchText)\n\n")
        filteredRows(searchTerm: "\(searchText)")
    }
    
    func filteredRows(searchTerm: String)
    {
        filteredData = musicArray.filter({(model: Music) -> Bool in
            return (model.artistName?.lowercased().contains(searchTerm.lowercased()))! || (model.trackName?.lowercased().contains(searchTerm.lowercased()))!
        })
        self.tableView.reloadData()
        
    }
    func updateSearchResults(for searchController: UISearchController) {
        if let term = searchController.searchBar.text
        {
            filteredRows(searchTerm: term)
        }
    }
    
    private func serachControllerSetup()
    {
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "search music"
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.definesPresentationContext = false
        tableView.tableHeaderView = searchController.searchBar
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != ""
        {
            return filteredData.count
        }
        else
        {
            return musicArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath) as! ItunesDataTableViewCell        
        
        let model:Music
        if searchController.isActive && searchController.searchBar.text != ""
        {
            model = filteredData[indexPath.row]
        }
        else
        {
            model = musicArray[indexPath.row]
        }
        
        cell.lblDesc?.text = model.artistName
        cell.lblSongDesc?.text = model.trackName
        
        guard let imgString = model.artworkUrl60,
            let imgUrl = URL(string: imgString) else {
                return cell
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let imageData = try Data(contentsOf: imgUrl)
                DispatchQueue.main.async {
                    let image = UIImage(data: imageData)
                    cell.imgArt?.image = image
                }
            } catch let error {
                print("Error with the image URL: ", error)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        performSegue(withIdentifier: "detail", sender: self)
    }
    
   
}

