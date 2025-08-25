//
//  NewCategoryViewController.swift
//  Tracker
//
//  Created by Михаил Бобылев on 24.08.2025.
//

import UIKit
import SnapKit

final class NewCategoryViewController: UIViewController {
    private struct Constants {
        static var titleText = "Новая категория"
        static var textFieldPlaceholderText = "Введите название категории"
        static var buttonText = "Готово"
        static var maxTextLength = 38
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.titleText
        label.font = UIFont.systemFont(ofSize: 16.dfs, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.smartInsertDeleteType = .no
        tf.borderStyle = .roundedRect
        tf.placeholder = Constants.textFieldPlaceholderText
        tf.font = UIFont.systemFont(ofSize: 17.dfs, weight: .regular)
        tf.returnKeyType = .done
        tf.borderStyle = .none
        tf.clearButtonMode = .whileEditing
        tf.backgroundColor = UIColor(resource: .grayLightBlue)
        tf.layer.cornerRadius = 16
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16.dhs, height: 0))
        tf.leftViewMode = .always
        return tf
    }()
    
    private lazy var addCategoryButton: TrackerCustomButton = {
        let button = TrackerCustomButton(style: .primary)
        button.setTitle(Constants.buttonText, for: .normal)
        button.addTarget(self, action: #selector(addCategoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var didTapAddNewCategory: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupUI()
        view.addKeyboardDismissTap()
    }
    
    func changeButtonState(to isEnabled: Bool) {
        addCategoryButton.isEnabled = isEnabled
    }
}

extension NewCategoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        changeButtonState(to: count > 0)
        return count <= Constants.maxTextLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private extension NewCategoryViewController {
    @objc func addCategoryButtonTapped() {
        guard let text = textField.text else { return }
        didTapAddNewCategory?(text)
        dismiss(animated: true)
    }
    
    func setupAppearance() {
        changeButtonState(to: textField.text?.count ?? 0 > 0)
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(textField)
        view.addSubview(addCategoryButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27.dvs)
            make.leading.trailing.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24.dvs)
            make.leading.trailing.equalToSuperview().inset(16.dhs)
            make.height.equalTo(75.dvs)
        }
        
        addCategoryButton.snp.makeConstraints { make in
            make.height.equalTo(60.dvs)
            make.leading.trailing.equalToSuperview().inset(20.dhs)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16.dvs)
        }
    }
}
