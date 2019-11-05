//
//  RecieptViewController.swift
//  budget
//
//  Created by Bradley Yin on 7/27/19.
//  Copyright © 2019 bradleyyin. All rights reserved.
//

import UIKit

class ReceiptViewController: UIViewController {
    
    var image: UIImage?
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var cancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
        setUpView()
        
        scrollView.delegate = self
        scrollView.maximumZoomScale = 6.0
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setZoomScale()
        if view.traitCollection.userInterfaceStyle == .light {
            self.view.backgroundColor = .white
            self.cancelButton.tintColor = .black
        } else {
            self.view.backgroundColor = .black
            self.cancelButton.tintColor = .white
        }
    }
    func setUpView() {
        
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonWidth * heightRatio).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonHeight * heightRatio).isActive = true
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20 * heightRatio).isActive = true
        button.setImage(UIImage(named: "cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        self.cancelButton = button
        
        scrollView.topAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
    }
    private func configureScrollView() {
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scrollView)
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        self.imageView = imageView
        self.scrollView = scrollView
    }
    func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height

        let minZoomScale = min(widthScale, heightScale)
        scrollView.minimumZoomScale = minZoomScale
        scrollView.zoomScale = minZoomScale
    }
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }

}
extension ReceiptViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {

        return imageView
    }
}
