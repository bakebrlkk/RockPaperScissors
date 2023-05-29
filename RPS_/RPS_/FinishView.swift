//
//  FinishView.swift
//  RockPaperScicors
//
//  Created by bakebrlk on 29.05.2023.
//

import UIKit
import SnapKit

class FinishView: ViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    private func setup(){
        
        view.backgroundColor = .white
        let image = winner.getImage()
        
        view.addSubview(image)
        image.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        view.addSubview(text)
        text.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.snp.top).offset(50)
        }
    }
    
    var text: UILabel = {
        let t = UILabel()
        t.text = "Winner !!!"
        t.textColor = .green
        t.font = .boldSystemFont(ofSize: 44)
        
        return t
    }()
}
