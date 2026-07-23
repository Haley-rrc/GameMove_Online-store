# Delete old products first because they belong to categories.

OrderItem.destroy_all
Order.destroy_all
User.destroy_all
Province.destroy_all
Product.destroy_all
Category.destroy_all

# Canadian provinces and territories with combined tax rates.
province_data = [
  ["Alberta", "AB", 0.05],
  ["British Columbia", "BC", 0.12],
  ["Manitoba", "MB", 0.12],
  ["New Brunswick", "NB", 0.15],
  ["Newfoundland and Labrador", "NL", 0.15],
  ["Northwest Territories", "NT", 0.05],
  ["Nova Scotia", "NS", 0.15],
  ["Nunavut", "NU", 0.05],
  ["Ontario", "ON", 0.13],
  ["Prince Edward Island", "PE", 0.15],
  ["Quebec", "QC", 0.14975],
  ["Saskatchewan", "SK", 0.11],
  ["Yukon", "YT", 0.05]
]

province_data.each do |name, code, tax_rate|
  Province.create!(
    name: name,
    code: code,
    tax_rate: tax_rate
  )
end

# Create four product categories.
categories = [
  Category.create!(
    name: "Video Games",
    description: "Video games for different consoles and computers."
  ),
  Category.create!(
    name: "Consoles",
    description: "Gaming consoles and entertainment systems."
  ),
  Category.create!(
    name: "Controllers",
    description: "Controllers and gaming accessories."
  ),
  Category.create!(
    name: "Gift Cards",
    description: "Digital gift cards for gaming platforms."
  )
]

# Create 100 sample products.
100.times do |number|
  category = categories[number % categories.length]

  Product.create!(
    category: category,
    name: "#{Faker::Game.title} #{number + 1}",
    description: Faker::Lorem.paragraph(sentence_count: 3),
    price: Faker::Commerce.price(range: 10.0..700.0),
    stock_quantity: rand(1..50)
  )
end

puts "Seed data created successfully."
puts "#{Province.count} provinces created."
puts "#{Category.count} categories created."
puts "#{Product.count} products created."