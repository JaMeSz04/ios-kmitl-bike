//
//  ProfileTableViewController.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/21/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileTableViewController: UITableViewController {

    var borrowModel = [String]()
    var borrowDateTime = [String]()
    var borrowDuration = [String]()
    var viewModel: ProfileViewModel = ProfileViewModel()
    let disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        
        self.refreshControl?.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        self.tableView.rowHeight = 83
        self.viewModel.fetchData()
        
        self.viewModel.outputs.onHistoriesLoad.observeOn(MainScheduler.instance).subscribe(onNext: { (userSessions) in
            print(userSessions)
            self.borrowModel = userSessions.map({ (userSession:Session) -> String in
                return (userSession.bike?.bike_model)!
            })
            self.borrowDateTime = userSessions.map({ (userSession:Session) -> String in
                let result: String = ((userSession.timestamps?.borrow_date)! + " " + (userSession.timestamps?.borrow_time)!)
                return result
            })
            self.borrowDuration = userSessions.map({ (userSession:Session) -> String in
                return String(Int((userSession.duration)! / 60)) + " minutes"
            })
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
            
        }).disposed(by: self.disposeBag)
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.title = "Histories"
    }
    
    @objc func reloadData(){
        
        self.viewModel.fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.borrowModel.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileTableViewCell
        
        // Configure the cell...
        let row = indexPath.row
        cell.bikeModel.text = self.borrowModel[row]
        cell.dateTime.text = self.borrowDateTime[row]
        cell.duration.text = self.borrowDuration[row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
