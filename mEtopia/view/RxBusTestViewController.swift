//
//  RxBusTestViewController.swift
//  mEtopia
//
//  Created by sbk on 7/4/25.
//

import UIKit

class RxBusTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let label = UILabel()
        label.text = "🧪 RxBus 테스트 중..."
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        // 3초 뒤에 닫기 + RxBus 이벤트 발행
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            var event:RxTestEvent = RxTestEvent(data:"테스트")
            RxBus.shared.post(event)
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}
