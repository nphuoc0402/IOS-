//
//  DatePickerTextField.swift
//  IOSDemo
//
//  Created by EP_NonFunc on 2023/04/03.
//
//import Foundation
//import SwiftUI
//
//struct DatePickerTextField: View {
//    private let textField = UITextField()
//    private let datePicker = UIDatePicker()
//    private let helper = Helper()
//    private let dateFormatter: DateFormatter = {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "mm/dd/yyyy"
//        return dateFormatter
//    }
//    public var placeholder:String
//    @binding public var date:Date?
//    
//    func makeUIView(context: Context)->UITextView {
//        self.datePicker.datePickerMode = .date
//        self.datePicker.preferredDatePickerStyle = .compact
//        self.datePicker.addTarget(self.helper,
//                                  action: #selector(self.helper.dateValueChanged),
//                                  for: .valueChanged)
//        self.textField.placeholder = self.placeholder
//        self.textField.inputView = self.datePicker
//        
//        self.helper.dateChanged = {
//            self.date = self.datePicker.date
//        }
//        return self.textField
//    }
//    func UpdateUIView(_ uiView: UITextView, context: Context) {
//        if let selectedDate = self.date {
//            uiView.text = self.dateFormatter.string(from: selectedDate)
//        }
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator()
//    }
//    class Helper {
//        public var dateChanged: (() -> Void)?
//        @objc func dateValueChanged(){
//            self.dateChanged?()
//        }
//    }
//    class Coordinator{
//        
//    }
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct DatePickerTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        DatePickerTextField()
//    }
//}
