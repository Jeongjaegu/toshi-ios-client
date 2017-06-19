// Copyright (c) 2017 Token Browser, Inc
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import UIKit
import CameraScanner

class ScannerController: ScannerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupActivityIndicator()
    }
    
    fileprivate lazy var activityView: UIActivityIndicatorView = {
        return self.defaultActivityIndicator()
    }()

    override func setupToolbarItems() {
        self.toolbar.setItems([self.cancelItem], animated: true)
    }
}

extension ScannerController: ActivityIndicating {
    
    var activityIndicator: UIActivityIndicatorView {
        return activityView
    }
}

extension ScannerController: PaymentPresentable {

    func paymentFailed(with error: Error?, result: [String : Any]) {
        self.startScanning()
    }
    
    func paymentDeclined() {
        self.startScanning()
    }
    
    func paymentApproved(with parameters: [String: Any], userInfo: UserInfo) {
        guard userInfo.isLocal == false else {
            if let tabbarController = self.presentingViewController as? TabBarController, let address = userInfo.address as String? {
                tabbarController.openPaymentMessage(to: address, parameters: parameters)
            }
            
            return
        }
        
        self.showActivityIndicator()
        
        EthereumAPIClient.shared.createUnsignedTransaction(parameters: parameters) { transaction, error in
            
            guard let transaction = transaction as String? else {
                self.hideActivityIndicator()
                self.startScanning()
                
                return
            }
            
            let signedTransaction = "0x\(Cereal.shared.signWithWallet(hex: transaction))"
            
            EthereumAPIClient.shared.sendSignedTransaction(originalTransaction: transaction, transactionSignature: signedTransaction) { json, error in
                
                self.hideActivityIndicator()
                
                guard let json = json?.dictionary else { fatalError("!") }
                if error != nil {
                    self.presentPaymentError(error: error, json: json)
                } else {
                    self.presentSuccessAlert(with: { action in
                        self.startScanning()
                    })
                }
            }
        }
    }
}