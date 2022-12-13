//
//  TableWithCities.swift
//  Weather
//
//  Created by Гурген Хоршикян on 14.10.2022.
//

import UIKit

protocol CitiesWeatherViewProtocol: AnyObject {
    func reloadData()
    func stopActivity()
    func openNextVC(vc: UIViewController)
}

class CitiesWeatherViewController: UIViewController, CitiesWeatherViewProtocol {
    var presenter: CitiesWeatherPresenterProtocol?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return  false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
   
    @IBAction func showAlertButton(_ sender: Any) {
        let alert = UIAlertController(title: "Погода", message: "добавить город", preferredStyle: .alert)
        let addActionAlert = UIAlertAction(title: "Добавить", style: .default) {(action: UIAlertAction!) in
            
            let textField = alert.textFields![0]
            guard let text = textField.text else { return }
            self.presenter?.loadWeather(city: text)
        }
        let cancelActionAlert = UIAlertAction(title: "Закрыть", style: .default, handler: nil)
        alert.addAction(cancelActionAlert)
        alert.addAction(addActionAlert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Введите город"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        configUI()
        presenter?.didLoad()
    }
    
    func configUI() {
        let nib = UINib(nibName: CityWeatherCell.reuseID, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CityWeatherCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск города"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    //MARK: CitiesWeatherViewProtocol methods
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func openNextVC(vc: UIViewController) {
        present(vc, animated: true, completion: nil)
    }
    
    func stopActivity() {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
    }
 }

//MARK: DataSource and Delegate
extension CitiesWeatherViewController:
    UITableViewDelegate,
    UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return presenter?.filteredRows.count ?? 0
        }
        return presenter?.rowModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter = presenter else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CityWeatherCell", for: indexPath) as! CityWeatherCell
        
        if isFiltering {
            cell.config(with: presenter.filteredRows[indexPath.row])
        } else {
            cell.config(with: presenter.rowModels[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.openDetailWeather(for: indexPath.row)
    }
    
    //MARK: Delete
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let model = presenter?.rowModels[indexPath.row] else { return }
            presenter?.deletCity(at: model.cityName)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension CitiesWeatherViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        presenter?.filterContentForSearchText(text)
    }
}
