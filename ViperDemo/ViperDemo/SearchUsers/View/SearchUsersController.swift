//
//  SearchUsersController.swift
//  ViperDemo
//
//  Created by Adeel Tahir on 17/12/2022.
//

import UIKit

protocol SearchUsersViewProtocol {
    
    var presenter: SearchUsersPresenterProtocol? { get set }
    
    func updateUsersList(_ usersList: GithubUserList)
    func updateLoadingState(_ isLoading: Bool)
    func showError(_ error: HTTPError)
}

struct Matrix {
    var row: Int
    var column: Int
}

class SearchUsersController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    var presenter: SearchUsersPresenterProtocol?
    
    private var users = [GithubUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("")
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        _ = climbingLeaderboard(ranked: [100 ,90 ,90 ,80 ,75 ,60], player: [50, 65, 77, 90, 102])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    func climbingLeaderboard(ranked: [Int], player: [Int]) -> [Int] {
        // Write your code here
        var ranks = [Int]()
        let sortedRanks = Set(ranked).sorted()
        
//        for p in player {
//            var currPlayerRank = 0
//            for rank in ranked {
//                if p >= rank {
//                    currPlayerRank += 1
//                }
//            }
//            ranks.append(currPlayerRank)
//        }
        
        for i in 0...player.count {
            var currPlayerRank = sortedRanks.count + 1
            for j in 0...sortedRanks.count {
                if player[i] >= ranked[j] {
                    currPlayerRank -= 1
                    if j == sortedRanks.count - 1 {
                        ranks.append(currPlayerRank)
                    } else {
                        continue
                    }
                } else {
                    ranks.append(currPlayerRank)
                    break
                }
            }
        }
        
        for p in player {
            var currPlayerRank = sortedRanks.count + 1
            for rank in sortedRanks {
                if p >= rank {
                    currPlayerRank -= 1
                    if rank == sortedRanks.last {
                        ranks.append(currPlayerRank)
                    } else {
                        continue
                    }
                } else {
                    ranks.append(currPlayerRank)
                    break
                }
            }
        }
        
        return ranks
    }
}

extension SearchUsersController: SearchUsersViewProtocol {
    
    //MARK: SearchUsersViewProtocol
    func updateUsersList(_ usersList: GithubUserList) {
        users = usersList.items
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateLoadingState(_ isLoading: Bool) {
        
    }
    
    func showError(_ error: HTTPError) {
        
    }
}

extension SearchUsersController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableViewDelegate, UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as? UserTableViewCell {
            cell.configure(user: users[indexPath.row])
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectUser(user: users[indexPath.row].login)
    }
}

extension SearchUsersController: UITextFieldDelegate {
    
    //MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presenter?.fetchUsersList(user: textField.text!)
        return true
    }
}
