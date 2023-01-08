//
//  HeroesTableViewController.swift
//  HeroisMarvel
//
//  Created by Eric Brito on 22/10/17.
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class HeroesTableViewController: UITableViewController {
    
    var name: String?
    
    var heroes: [Hero] = []
    var loadingHeroes = false
    var currentPage: Int = 0
    var total = 0

    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = "Buscando heróis...aguarde..beep...beep"
        loadHeroes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! HeroViewController
        vc.hero = heroes[tableView.indexPathForSelectedRow!.row]
    }
    
    func loadHeroes() {
        loadingHeroes = true
        MarvelAPI.loadHeroes(name: name, page: currentPage) { (info) in
            if let info = info {
                self.heroes += info.data.results
                self.total = info.data.total
                print ("Total: ", self.total, "- Ja incluídos: ", self.heroes.count)
                DispatchQueue.main.async {
                    self.loadingHeroes = false // Posso fazer outra requisição, pois a anterior acaba de ser finalizada
                    self.label.text = "Nenhum herói com o nome: \(self.name!), foi encontrado"
                    self.tableView.reloadData()
                }
                
            }
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if heroes.count == 0 {
            tableView.backgroundView = label
        } else {
            tableView.backgroundView = nil
        }
        return heroes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HeroTableViewCell
        let hero = heroes[indexPath.row]
        cell.prepare(with: hero)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == heroes.count && !loadingHeroes && heroes.count != total  {
            currentPage += 1
            loadHeroes()
            print("Carregando Heróis...")
        }
    }
}
