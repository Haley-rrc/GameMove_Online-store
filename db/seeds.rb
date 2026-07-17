# Delete old products first because they belong to categories.
AdminUser.destroy_all
Product.destroy_all
Category.destroy_all

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
puts "#{Category.count} categories created."
puts "#{Product.count} products created."

# Create one administrator account.
AdminUser.create!(
  username: "admin",
  password: "password",
  password_confirmation: "password"
)

puts "#{AdminUser.count} administrator created."