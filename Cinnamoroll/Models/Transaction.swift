import Foundation

enum TransactionType: String, Codable, CaseIterable {
    case income = "收入"
    case expense = "支出"
}

struct Category: Identifiable, Codable {
    let id: UUID
    var name: String
    var icon: String
    var type: TransactionType
    
    init(id: UUID = UUID(), name: String, icon: String, type: TransactionType) {
        self.id = id
        self.name = name
        self.icon = icon
        self.type = type
    }
    
    static let defaultCategories: [Category] = [
        Category(name: "餐饮", icon: "🍔", type: .expense),
        Category(name: "交通", icon: "🚗", type: .expense),
        Category(name: "购物", icon: "🛍️", type: .expense),
        Category(name: "工资", icon: "💰", type: .income),
        Category(name: "奖金", icon: "🎁", type: .income),
    ]
}

struct Transaction: Identifiable, Codable {
    let id: UUID
    var amount: Double
    var category: String
    var note: String
    var date: Date
    var type: TransactionType
    
    init(id: UUID = UUID(), amount: Double, category: String, note: String, date: Date = Date(), type: TransactionType) {
        self.id = id
        self.amount = amount
        self.category = category
        self.note = note
        self.date = date
        self.type = type
    }
}