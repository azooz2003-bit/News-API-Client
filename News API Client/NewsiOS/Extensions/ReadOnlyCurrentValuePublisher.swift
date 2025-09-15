//
//  ReadOnlyCurrentValueSubject.swift
//  News API Client
//
//  Created by Abdulaziz Albahar on 9/14/25.
//

import Combine

public class ReadOnlyCurrentValuePublisher<Output, Failure>: Publisher where Failure : Error {
    
    internal let currentValueSubject: CurrentValueSubject<Output, Failure>
    
    public internal(set) var value: Output {
        get { currentValueSubject.value }
        set { currentValueSubject.value = newValue }
    }
    
    public init(_ subject: CurrentValueSubject<Output, Failure>) {
        currentValueSubject = subject
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        currentValueSubject.receive(subscriber: subscriber)
    }
}

extension CurrentValueSubject {
    func toReadOnlyCurrentValuePublisher() -> ReadOnlyCurrentValuePublisher<Output, Failure> {
        .init(self)
    }
}
