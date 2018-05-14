//
//  HomeScannerExtension.swift
//  brandNewBIke
//
//  Created by Patipon Riebpradit on 5/13/18.
//  Copyright © 2018 Patipon Riebpradit. All rights reserved.
//

import Foundation
import QRCodeReader

extension HomeViewController: QRCodeReaderViewControllerDelegate {
    func openScanner(){
        self.bulletinManager.dismissBulletin()
        readerVC.delegate = self
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            if result != nil {
                self.readerVC.stopScanning()
                self.dismiss(animated: true, completion: nil)
                self.viewModel.inputs.scannerBikeUpdate.onNext(result!.value)
            }
        }
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        print("qr result")
        print(result.value)
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
}