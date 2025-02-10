//
//  CustomTableviewCell.swift
//  WeatherApp
//
//  Created by codeL on 2025/2/9.
//

import UIKit

// 自定义 UITableViewCell 类
class CustomTableViewCell: UITableViewCell {
    
    // 左边的 UILabel
    private let leftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    // 右边的 UILabel
    private let rightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    // 中间的竖线
    private let separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        setupCellBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 设置视图
    private func setupViews() {
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        contentView.addSubview(separatorView)
    }
    
    // 设置布局约束
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // 左边 label 的约束
            leftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            leftLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            leftLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            leftLabel.trailingAnchor.constraint(equalTo: separatorView.leadingAnchor, constant: -8),
            
            // 中间竖线的约束
            separatorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            separatorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            separatorView.widthAnchor.constraint(equalToConstant: 1),
            
            // 右边 label 的约束
            rightLabel.leadingAnchor.constraint(equalTo: separatorView.trailingAnchor, constant: 8),
            rightLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            rightLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            rightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    // 设置单元格边框
    private func setupCellBorder() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
    }
    
    // 设置单元格的文本内容
    func configure(leftText: String, rightText: String) {
        leftLabel.text = leftText
        rightLabel.text = rightText
    }
}
