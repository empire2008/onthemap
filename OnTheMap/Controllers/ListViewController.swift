//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Nuttapong Nateetaweesak on 3/8/2562 BE.
//  Copyright © 2562 Nuttapong Nateetaweesak. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        UdacityClient.getLocations(url: UdacityClient.EndPoint.getLimitLocations(100).url, completion: handleLocationsResponse(data:error:))
    }
    
    func handleLocationsResponse(data: LocationsResponse?, error: Error?){
        if let data = data{
            UdacityClient.Auth.userList.removeAll()
            for user in data.results{
                UdacityClient.Auth.userList.append(user)
            }
            tableView.reloadData()
        }
        else{
            self.popupAlert(topic: "Download Failed", message: error?.localizedDescription ?? "")
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        UdacityClient.Auth.key = ""
        UdacityClient.Auth.sessionId = ""
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func refreshButton(_ sender: Any) {
        UdacityClient.getLocations(url: UdacityClient.EndPoint.getLimitLocations(100).url, completion: handleLocationsResponse(data:error:))
    }
    @IBAction func addButton(_ sender: Any) {
        self.performSegue(withIdentifier: "AddLocation", sender: self)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UdacityClient.Auth.userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell")!
        cell.imageView?.image = UIImage(named: "icon_pin")
        cell.textLabel?.text = "\(UdacityClient.Auth.userList[indexPath.row].firstName) \(UdacityClient.Auth.userList[indexPath.row].lastName)"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: UdacityClient.Auth.userList[indexPath.row].mediaURL) else { return }
        UIApplication.shared.open(url)
    }
}
