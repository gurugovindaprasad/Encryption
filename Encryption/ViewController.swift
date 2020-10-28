//
//  ViewController.swift
//  Encryption
//
//  Created by Guru Ranganathan on 10/28/20.
//

import UIKit
import CryptoKit


class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var encryptedLabel: UILabel!
    @IBOutlet weak var switch256: UISwitch!
    

    let key128   = "u123huop0987cv41"                   // 16 bytes for AES128
    let key256   = "7110eda4d09e062aa5e4a390b0a572ac"   // 32 bytes for AES256
    let iv       = "0000000000000000"                   
    lazy var aes128 = Encryption(key: key128, iv: iv)
    lazy var aes256 = Encryption(key: key256, iv: iv)
    var encrypted128: Data!
    var encrypted256: Data!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cryptoKit()
    }


    @IBAction func encrypt(_ sender: UIButton) {
        
        guard let text = textField.text else {return}
        
        if sender.titleLabel?.text == "Encrypt" {
            if switch256.isOn {
                encrypted256 = aes256?.encrypt(string: text)
                encryptedLabel.text = encrypted256?.base64EncodedString()
            }else {
                encrypted128 = aes128?.encrypt(string: text)
                encryptedLabel.text = encrypted128?.base64EncodedString()
            }
            sender.setTitle("Decrypt", for: .normal)
        }else {
            if switch256.isOn {
                encryptedLabel.text = aes256?.decrypt(data: encrypted256)
            }else{
                encryptedLabel.text = aes128?.decrypt(data: encrypted128)
            }
            sender.setTitle("Encrypt", for: .normal)
        }
    }
    
    //MARK:
    
    func cryptoKit() {
        
        let key = SymmetricKey(size: .bits256)
        
        print(key.bitCount)
        
        let sealedBox = try! AES.GCM.seal("hello".data(using: .utf8)!, using: key)
        
        print(sealedBox.nonce)
        
        let result = try! AES.GCM.open(sealedBox, using: key)
        
        let text = String(data: result, encoding: .utf8)
        
        print(text ?? "")
    }
}



