//
//  NavigationPanelVC.swift
//  Boxing 247
//
//  Copyright © 2018 Omar. All rights reserved.
//

import UIKit
import MessageUI

class HelpMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let viewModel = HelpMenuVM()
    
    // MARK: - Configuration
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = dark247
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = test247
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        
        return viewModel.sections[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return viewModel.rows.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.rows[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PanelCell", for: indexPath) as? HelpMenuCell else { return UITableViewCell() }
        
        cell.configureCell(with: viewModel, and: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch true {
        
        case indexPath.row == 0:
            performSegue(withIdentifier: "showAboutUs", sender: nil)
            
        case indexPath.row == 1:
            showEmailController()
            
        case indexPath.row == 2:
            let activityVC = UIActivityViewController(activityItems: ["Check out this free app called 'Boxing Updates' to keep updated with the latest boxing news!"], applicationActivities: nil)
            present(activityVC, animated: true, completion: nil)
        //https://stackoverflow.com/questions/37938722/how-to-implement-share-button-in-swift
        
        //case indexPath.row == 3:
        
        default:
            return
        }
    }
    
    // MARK: - Mail Compose view delegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult,error: Error?) {
        controller.dismiss(animated: true)
    }
}

private extension HelpMenuVC {
    
    func showEmailController() {
        
        if MFMailComposeViewController.canSendMail() {
            let emailController = MFMailComposeViewController()
            
            emailController.view.backgroundColor = dark247
            emailController.mailComposeDelegate = self
            emailController.setToRecipients(["help@boxingupdates.co.uk"])
            emailController.setMessageBody("<p><br><br><br><br><br><br> iOS version 14.6 </p>", isHTML: true)
            emailController.setSubject("User Feedback ios v.1.0.0 Ticket Number \(Int.random(in: 1..<10000000))")
            present(emailController, animated: true)
            emailController.view.backgroundColor = dark247

            
        } else {
            // show failure alert
        }
    }
}

