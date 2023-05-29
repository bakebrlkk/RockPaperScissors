//
//  Customs.swift
//  RockPaperScicors
//
//  Created by bakebrlk on 28.05.2023.
//

import UIKit

enum RPS{
    case rock
    case paper
    case scissors
    
    func getImage() -> UIImageView{
        switch self {
        case .rock:
            return UIImageView(image: UIImage(named: "rock"))
        case .paper:
            return UIImageView(image: UIImage(named: "paper"))
        case .scissors:
            return UIImageView(image: UIImage(named: "scissors"))
        }
    }
}


