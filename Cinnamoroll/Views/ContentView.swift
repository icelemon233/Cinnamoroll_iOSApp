import SwiftUI

struct ContentView: View {
    @State private var transactions: [Transaction] = []
    @State private var showingAddTransaction = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 统计卡片
                HStack(spacing: 16) {
                    StatCard(title: "收入", amount: totalIncome, color: .green)
                    StatCard(title: "支出", amount: totalExpense, color: .red)
                }
                .padding()
                
                // 交易列表
                if transactions.isEmpty {
                    Spacer()
                    Text("还没有记账记录")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List {
                        ForEach(groupedTransactions.keys.sorted(by: { $0 > $1 }), id: \.self) { date in
                            Section(header: Text(formatDate(date))) {
                                ForEach(groupedTransactions[date] ?? []) { transaction in
                                    TransactionRow(transaction: transaction)
                                }
                            }
                        }
                        .onDelete(perform: deleteTransaction)
                    }
                }
            }
            .navigationTitle("记账本")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTransaction = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView(transactions: $transactions)
            }
            .onAppear {
                transactions = StorageManager.shared.loadTransactions()
            }
        }
    }
    
    private var totalIncome: Double {
        transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }
    
    private var totalExpense: Double {
        transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }
    
    private var groupedTransactions: [String: [Transaction]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return Dictionary(grouping: transactions) { formatter.string(from: $0.date) }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else { return dateString }
        formatter.dateFormat = "MM月dd日"
        return formatter.string(from: date)
    }
    
    private func deleteTransaction(at offsets: IndexSet) {
        transactions.remove(atOffsets: offsets)
        StorageManager.shared.saveTransactions(transactions)
    }
}

struct StatCard: View {
    let title: String
    let amount: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(String(format: "¥%.2f", amount))
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.category)
                    .font(.body)
                if !transaction.note.isEmpty {
                    Text(transaction.note)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            Text("\(transaction.type == .income ? "+" : "-")¥\(String(format: "%.2f", transaction.amount))")
                .foregroundColor(transaction.type == .income ? .green : .red)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    ContentView()
}