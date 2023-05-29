//
//  StartView.swift
//  RockPaperScicors
//
//  Created by bakebrlk on 29.05.2023.
//

import UIKit
import SnapKit


class StartView: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        s()
    }
    
    private func s(){
        view.backgroundColor = .blue
        
        view.addSubview(btn)
        view.backgroundColor = .white
        btn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-50)
            make.height.equalTo(56)
        }
        
        view.addSubview(text)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(btn.snp.top).offset(-20)
        }
        
        view.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        image.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-100)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(400)
            
        }
        btn.addTarget(self, action: #selector(nextView), for: .touchUpInside)

    }
    
    
    var text: UILabel = {
        let t = UILabel()
        t.text = "Welcome to the \nrock-paper-scissors game!"
        t.numberOfLines = 0
        t.font = .boldSystemFont(ofSize: 24)
        t.textColor = .black
        return t
    }()
    
    
    var btn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Start", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .black
        btn.layer.cornerRadius = 24
        return btn
    }()
    
    @objc func nextView(){
        navigationController?.pushViewController(ViewController(), animated: true)
    }
    
    var image: UIImageView = {
        let im = UIImageView(image: UIImage(named: "back"))
        return im
    }()
}
