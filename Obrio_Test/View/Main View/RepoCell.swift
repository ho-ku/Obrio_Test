//
//  RepoCell.swift
//  Obrio_Test
//
//  Created by Денис Андриевский on 05.12.2020.
//

import UIKit

struct CellData {
    var name: String
    var fullName: String
}

class RepoCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var repoNameLabel: UILabel!
    @IBOutlet private weak var repoFullNameLabel: UILabel!
    
    // MARK: - Properties
    var cellData: CellData? {
        didSet {
            didUpdateCellData()
        }
    }

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    private func setupView() {
        repoNameLabel.font = UIFont(name: "Avenir-Medium", size: 20)
        repoFullNameLabel.font = UIFont(name: "Avenir", size: 14)
        repoFullNameLabel.textColor = Color.repoFullNameFontColor
    }
    
    private func didUpdateCellData() {
        repoNameLabel.text = cellData?.name
        repoFullNameLabel.text = cellData?.fullName
    }

}
