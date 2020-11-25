//
//  TableViewController.swift
//  RickAndMortyCombineApp
//
//  Created by Пазин Даниил on 23.11.2020.
//

import UIKit
import Combine

class MasterTableViewController: UITableViewController {
    
    // MARK: - Constants and Variables
    
    let apiClient = APIClient()
    var subscriptions: Set<AnyCancellable> = []
    var charactersInfo: CharacterPage? {
        didSet {
            for i in 1...(self.charactersInfo?.results.count)! {
                totalCharacters.append(i)
            }
        }
    }
    var totalCharacters: [Int] = [] {
        didSet{
            apiClient.mergedCharacters(ids: self.totalCharacters)
                .sink(receiveCompletion: { print($0) },
                      receiveValue: { self.characters.append($0)
                        print($0)
                      })
                .store(in: &subscriptions)
        }
    }
    var characters: [Character] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var filteredCharacters: [Character] = []
    let searchController = UISearchController(searchResultsController: nil)
    var episodes: [Episode] = []
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }


    // MARK: - View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiClient.getTotalCharactersNumber()
            .sink(receiveCompletion: { print($0) }) { self.charactersInfo = $0
                print($0)
            }
            .store(in: &subscriptions)
        
        // Do any additional setup after loading the view.
        
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Найти персонажа"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering {
            return filteredCharacters.count
          }
            
        return characters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let character: Character
        
        if isFiltering {
            character = filteredCharacters[indexPath.row]
        } else {
            character = characters[indexPath.row]
        }
        
        cell.textLabel?.text = character.name
        cell.detailTextLabel?.text = character.species

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Methods
    func filterContentForSearchText(_ searchText: String) {
      filteredCharacters = characters.filter { (character: Character) -> Bool in
        return character.name.lowercased().contains(searchText.lowercased())
      }
      
      tableView.reloadData()
    }

    
    func filterContentByEpisodes(_ searchText: String) {
        apiClient.mergedEpisodes(ids: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
            .sink(receiveCompletion: { print($0) },
                  receiveValue: { self.episodes.append($0)
                    print($0)
                  })
            .store(in: &subscriptions)
        
        tableView.reloadData()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard
          segue.identifier == "ShowDetailSegue",
          let indexPath = tableView.indexPathForSelectedRow,
          let detailViewController = segue.destination as? DetailViewController
          else {
            return
        }
        
        let character = characters[indexPath.row]
        detailViewController.character = character
    }
}

extension MasterTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}
