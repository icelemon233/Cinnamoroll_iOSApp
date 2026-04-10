import SwiftUI

struct AddTransactionView: View {
    @Binding var transactions: [Transaction]
    @Environment(\.dismiss) var dismiss
    
    @State private var amount: String = ""
    @State private var selectedCategory: Category = Category.defaultCategories[0]
    @State private var note: String = ""
    @State private var selectedType: TransactionType = .expense
    
    private let categories = StorageManager.shared.loadCategories()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("类型") {
                    Picker("类型", selection: $selectedType) {
                        Text("支出").tag(TransactionType.expense)
                        Text("收入").tag(TransactionType.income)
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("金额") {
                    TextField("0.00", text: $amount)
                        .keyboardType(.decimalPad)
                }
                
                Section("分类") {
                    Picker("分类", selection: $selectedCategory) {
                        ForEach(categories.filter { $0.type == selectedType }) { category in
                            Text("\(category.icon) \(category.name)").tag(category)
                        }
                    }
                }
                
                Section("备注") {
                    TextField("可选", text: $note)
                }
                
                Section {
                    Button("保存") {
                        saveTransaction()
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(amount.isEmpty || Double(amount) == nil)
                }
            }
            .navigationTitle("添加记录")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveTransaction() {
        guard let amountValue = Double(amount) else { return }
        
        let transaction = Transaction(
            amount: amountValue,
            category: selectedCategory.name,
            note: note,
            type: selectedType
        )
        
        transactions.append(transaction)
        StorageManager.shared.saveTransactions(transactions)
        dismiss()
    }
}

#Preview {
    AddTransactionView(transactions: .constant([]))
}