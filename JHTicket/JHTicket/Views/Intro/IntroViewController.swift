//
//  IntroViewController.swift
//  JHTicket
//
//  Created by JH on 2021/09/05.
//

import UIKit

final class IntroViewController: BaseViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var imageLeadingConstraint: NSLayoutConstraint!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initTimer()
    }
    
    // MARK: - Initialize
    
    func initTimer() {
        // start the timer
        Timer.scheduledTimer(timeInterval: 6,
                             target: self,
                             selector: #selector(moveToMainVC),
                             userInfo: nil,
                             repeats: false)

        UIView.animate(withDuration: 6,
                       delay: 0,
                       options: [ ],
                       animations: { [weak self] in
            self?.loadingImageView.frame.origin.x -= 80
        }, completion: { [weak self] _ in
            self?.loadingImageView.layoutIfNeeded()
        })
    }
    
    // MARK: - Method
    @objc
    func moveToMainVC() {
        let mainVC: MainViewController = MainViewController.viewController(from: .main)
        mainVC.modalTransitionStyle = .crossDissolve
        navigationController?.pushViewController(mainVC, animated: false)
    }
}
