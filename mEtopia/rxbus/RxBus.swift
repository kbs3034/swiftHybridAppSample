//
//  RxBus.swift
//  mEtopia
//
//  Created by sbk on 7/4/25.
//
import RxSwift
import RxCocoa

final class RxBus {
    static let shared = RxBus()

    public let disposeBag = DisposeBag()
    private let eventSubject = PublishSubject<RxBusEvent>()

    private init() {}

    func post(_ event: RxBusEvent) {
        eventSubject.onNext(event)
    }

    func observe<T: RxBusEvent>(_ eventType: T.Type) -> Observable<T> {
        return eventSubject
            .compactMap { $0 as? T }
    }
}
