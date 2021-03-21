//
//  UIViewController+Extension.swift
//  ProFive
//
//  Created by Lokesh Kumar on 23/02/18.
//  Copyright © 2018 Lokesh Kumar. All rights reserved.
//

import UIKit

import MessageUI

extension UIViewController: MFMailComposeViewControllerDelegate {
    //https://stackoverflow.com/questions/35931946/basic-example-for-sharing-text-or-image-with-uiactivityviewcontroller-in-swift
    
    func sendEmail(receipent: [String], subject: String, body: String) {
        let mailComposeViewController = configuredMailComposeViewController(receipent, subject, body)
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    private func configuredMailComposeViewController(_ receipent: [String], _ subject: String, _ body: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(receipent)
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody(body, isHTML: false)
        
        return mailComposerVC
    }
    
    private func showSendMailErrorAlert() {
        AKAlertController.alert("Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

