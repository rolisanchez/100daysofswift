//
//  ViewController.swift
//  Project25
//
//  Created by Victor Rolando Sanchez Jara on 3/28/20.
//  Copyright © 2020 Victor Rolando Sanchez Jara. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController {
    // MARK: Properties
    var images = [UIImage]()
    
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
//    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    var mcNearbyServiceAdvertiser: MCNearbyServiceAdvertiser?
    // MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Selfie Share"
        // Right Bar Button Items
        let sharePhotoButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        let shareTextButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(shareText))
        navigationItem.rightBarButtonItems = [sharePhotoButton, shareTextButton]
        
        // Left Bar Button Items
        let addConnectionButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        let showConnectionButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showConnections))

        navigationItem.leftBarButtonItems = [addConnectionButton, showConnectionButton]
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }
    
    // MARK: UICollectionView DataSource and Delegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        let imageViewTag = 1000
        if let imageView = cell.viewWithTag(imageViewTag) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
    }
    
    // MARK: Other Methods
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc func shareText() {
        let ac = UIAlertController(title: "Share Text", message: "Write what you want to share", preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac, weak self] _ in
            let answer = ac.textFields![0]
            
            guard let answerText = answer.text else { return }
            guard let mcSession = self?.mcSession else { return }
            
            if mcSession.connectedPeers.count > 0 {
                let textData = Data(answerText.utf8)
                do {
                    try mcSession.send(textData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(ac, animated: true)
                }
            }
        }
        ac.addAction(submitAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(ac, animated: true)
    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    
    @objc func showConnections() {
        if let mcSession = mcSession {
            let connectedPeers = mcSession.connectedPeers
            var peerDisplayNames = [String]()
            for peerID in connectedPeers {
                peerDisplayNames.append(peerID.displayName)
            }
            let ac = UIAlertController(title: "Current Connections", message: "Peers connected: \(peerDisplayNames)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "No Connections", message: "You are not connected to any Session", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .cancel))
            present(ac, animated: true)
        }

        
    }
    
    func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
//        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
//        mcAdvertiserAssistant?.start()
        
        mcNearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: "hws-project25")
        mcNearbyServiceAdvertiser?.delegate = self
        mcNearbyServiceAdvertiser?.startAdvertisingPeer()

    }
    
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 145, height: 145)
    }
}

// MARK: UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
    
}

// MARK: UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        // 1
        guard let mcSession = mcSession else { return }
        
        // 2
        if mcSession.connectedPeers.count > 0 {
            // 3
            if let imageData = image.pngData() {
                // 4
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    // 5
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
}

// MARK: MCSessionDelegate and MCBrowserViewControllerDelegate
extension ViewController: MCSessionDelegate, MCBrowserViewControllerDelegate {
    // No need to do anything here in our app
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    // No need to do anything here in our app
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    // No need to do anything here in our app
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    // We just need to dismiss here
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    // We just need to dismiss here
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    // MARK: Detect State Change
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
            case .connected:
                print("Connected: \(peerID.displayName)")
            
            case .connecting:
                print("Connecting: \(peerID.displayName)")
            
            case .notConnected:
                print("Not Connected: \(peerID.displayName)")
                let ac = UIAlertController(title: "Disconnection", message: "\(peerID.displayName) has disconnected", preferredStyle: .alert)
                ac.addAction(.init(title: "Ok", style: .cancel, handler: nil))
                DispatchQueue.main.async { [weak self] in
                    self?.present(ac, animated: true)
                }
            
            
            @unknown default:
                print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        DispatchQueue.main.async { [weak self] in
//            if let image = UIImage(data: data) {
//                self?.images.insert(image, at: 0)
//                self?.collectionView.reloadData()
//            }
//        }
        // Just run code on main thread if Image is there
        if let image = UIImage(data: data) {
            images.insert(image, at: 0)
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        } else {
            let text = String(decoding: data, as: UTF8.self)
            let ac = UIAlertController(title: "Received Text", message: "\(peerID.displayName) shared: \"\(text)\"", preferredStyle: .alert)
            ac.addAction(.init(title: "Ok", style: .cancel, handler: nil))
            DispatchQueue.main.async { [weak self] in
                self?.present(ac, animated: true)
            }
        }
    }
    
    
}

extension ViewController: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, mcSession)
    }
}
