//
//  OnboardingFirstViewController.swift
//  Tracker
//
//  Created by Михаил Бобылев on 23.08.2025.
//

import UIKit
import SnapKit

final class OnboardingBackgroundViewController: UIViewController {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32.dfs, weight: .bold)
        label.textColor = .veryDark
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(backImage: UIImage, text: String) {
        super.init(nibName: nil, bundle: nil)
        imageView.image = backImage
        mainLabel.text = text
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension OnboardingBackgroundViewController {
    func setupUI() {
        view.addSubview(imageView)
        view.addSubview(mainLabel)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.dhs)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(270.dvs)
        }
    }
}
