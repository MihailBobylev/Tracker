//
//  TitleTextFieldCell.swift
//  Tracker
//
//  Created by Михаил Бобылев on 27.07.2025.
//

import UIKit
import SnapKit

final class TitleTextFieldCell: UICollectionViewCell {
    static var reuseID: String {
        String(describing: Self.self)
    }
    
    private let mainVStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.delegate = self
        tf.borderStyle = .roundedRect
        tf.placeholder = "Введите название трекера"
        tf.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        tf.returnKeyType = .done
        tf.borderStyle = .none
        tf.clearButtonMode = .whileEditing
        tf.backgroundColor = UIColor(resource: .grayLightBlue)
        tf.layer.cornerRadius = 16
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        tf.leftViewMode = .always
        tf.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        return tf
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.text = "Ограничение 38 символов"
        label.textColor = UIColor(resource: .redSoft)
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.isHidden = true
        label.numberOfLines = 1
        return label
    }()
    
    var errorLabelIsVisible: Bool {
        !errorLabel.isHidden
    }

    var onTextChanged: ((String) -> Void)?
    var onEditingEnded: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeErrorState(isError: Bool) {
        errorLabel.isHidden = !isError
    }
}

extension TitleTextFieldCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        onEditingEnded?(textField.text ?? "")
    }
}

private extension TitleTextFieldCell {
    @objc func textDidChange() {
        onTextChanged?(textField.text ?? "")
    }
    
    func setupUI() {
        contentView.addSubview(mainVStack)
        mainVStack.addArrangedSubview(textField)
        mainVStack.addArrangedSubview(errorLabel)
        
        mainVStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.height.equalTo(75)
        }
    }
}
