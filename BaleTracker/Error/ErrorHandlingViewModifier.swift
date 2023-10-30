////
////  ErrorHandlingViewModifier.swift
////  BaleTracker
////
////  Created by Simon Goller on 12.07.23.
////
//
//import SwiftUI
//
//struct ErrorHandlingViewModifier: ViewModifier {
//    // MARK: Private properties
//
//    @Binding var error: Error?
//
//    var type: ErrorHandlingType?
//
//    // Initializer to show errors via alert type
//    init(error: Binding<Error?>, type: ErrorHandlingType) {
//        _error = error
//        self.type = type
//    }
//
//    // MARK: Public functions
//
//    func body(content: Content) -> some View {
//        if let error = error?.toCustomError(withRetryAction: nil) {
//            let title = errorTitle
//            let message = errorMessage
////            let image = errorImage
//
//            if !error.shouldShow {
//                content
//            } else if let type = type {
//                switch type {
//                case let .alert(action):
//
//                    if case let .retryableConnectionError(_, retryAction) = error {
//                        createAlert(content: content,
//                                    alert: Alert(
//                                        title: Text(title),
//                                        message: Text(message),
//                                        primaryButton: .default(Text("retry"), action: { // R.string.localizable.btn_retry()
//                                            Task {
//                                                try? await retryAction()
//                                            }
//                                        }),
//                                        secondaryButton: .cancel(Text("cancel"), action: action) // R.string.localizable.btn_cancel()
//                                    ))
//                    } else {
//                        createAlert(content: content,
//                                    alert: Alert(
//                                        title: Text(title),
//                                        message: Text(message),
//                                        dismissButton: .default(Text("ok"), action: action) // R.string.localizable.btn_ok()
//                                    ))
//                    }
//                case let .alertButtons(primary, secondary):
//                    createAlert(content: content,
//                                alert: Alert(
//                                    title: Text(title),
//                                    message: Text(message),
//                                    primaryButton: primary,
//                                    secondaryButton: secondary
//                                ))
////                case let .customErrorView(action):
////                    if let action = action {
////                        CustomErrorView(title: title, message: message, image: image, action: (action.title, {
////                            action.action()
////                        }))
////                    } else {
////                        CustomErrorView(title: title, message: message, image: image, action: nil)
////                    }
//                }
//            } else {
//                content
//            }
//        } else {
//            content
//        }
//    }
//
//    // MARK: Private functions
//
//    private func createAlert(content: Content, alert: Alert) -> some View {
//        let errorBinding: Binding<Bool> = .init(get: {
//            error != nil
//        }, set: { value in
//            if !value {
//                error = nil
//            }
//        })
//
//        return content.background(
//            EmptyView()
//                .alert(isPresented: errorBinding) {
//                    alert
//                }
//        )
//    }
//
//    private var errorTitle: String {
//        if let error = error as? LocalizedError, let title = error.errorDescription {
//            return title
//        } else {
//            return "Error"
//        }
//    }
//
//    private var errorMessage: String {
//        let message: String?
//
//        if let error = error as? LocalizedError {
//            message = error.failureReason
//        } else {
//            #if DEBUG
//                message = error?.localizedDescription
//            #else
//                message = nil
//            #endif
//        }
//
//        if let message = message {
//            if let error = error {
//                "Error occurred, msg: \(message), error: \(error)".log()
//            }
//            return message
//        } else {
//            return "An error occurred, please try again"
//        }
//    }
//
////    private var errorImage: Image {
////        if let error = error as? CustomError {
////            return error.image
////        } else {
////            return Image(systemName: "info.circle")
////        }
////    }
//}
//
//enum ErrorHandlingType {
//    case alert(action: () -> Void = {})
//    case alertButtons(primary: Alert.Button, secondary: Alert.Button)
////    case customErrorView(action: CustomErrorView.Action?)
//}
