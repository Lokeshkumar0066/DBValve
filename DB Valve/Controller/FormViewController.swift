//
//  FormViewController.swift
//  DB Valve
//
//  Created by Lokesh Kumar on 19/04/20.
//  Copyright © 2020 Lokesh Kumar. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {
    
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        phoneTF.text = "+91"
        
        fullNameTF.delegate = self
        emailTF.delegate = self
        phoneTF.delegate = self
        addressTF.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    @IBAction func submitButtonAction(_ sender: AKLoadingButton) {
        
        guard !fullNameTF.text!.isEmpty else {
            AKAlertController.alert("Alert", message: "Please enter your name")
            return
        }
        guard emailTF.text!.isEmail else {
            AKAlertController.alert("Alert", message: "Please enter valid email")
            return
        }
        guard !phoneTF.text!.isEmpty else {
            AKAlertController.alert("Alert", message: "Please enter phone number")
            return
        }

        guard !addressTF.text!.isEmpty else {
            AKAlertController.alert("Alert", message: "Please enter address")
            return
        }

        sender.isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            sender.isLoading = false
            self.navigationController?.popToRootViewController(animated: false)
            
//            AppDelegate.instance.payAmount(self.phoneTF.text!, email: self.emailTF.text!, amount: 50000.stringValue, desc: "")
            
        }
    }
    
}

extension FormViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let points = textField.convert(CGPoint.zero, to: self.view)
        if (points.y >= self.view.bounds.size.height/2 - 40) {
            
            var frame = self.view.frame
            frame.origin.y = self.view.bounds.size.height/2 - 40 - points.y
            UIView.animate(withDuration: 0.4, animations: {
                self.view.frame = frame
            })
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var returnframe = self.view.frame
        returnframe.origin.y = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = returnframe
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        return true
    }
    
}

