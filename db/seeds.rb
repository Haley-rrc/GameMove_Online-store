# Remove old data before adding new seed data.
Product.destroy_all
Category.destroy_all

# Create product categories.
video_games = Category.create!(
  name: "Video Games",
  description: "Games for Nintendo Switch, PlayStation, Xbox and PC."
)

consoles = Category.create!(
  name: "Consoles",
  description: "Video game consoles and gaming systems."
)

controllers = Category.create!(
  name: "Controllers",
  description: "Controllers and accessories for different game systems."
)

gift_cards = Category.create!(
  name: "Gift Cards",
  description: "Digital gift cards for popular gaming platforms."
)

# Create ten products.
Product.create!(
  category: video_games,
  name: "The Legend of Zelda: Tears of the Kingdom",
  description: "An open-world adventure game for Nintendo Switch.",
  price: 79.99,
  stock_quantity: 12
)

Product.create!(
  category: video_games,
  name: "Super Mario Bros. Wonder",
  description: "A colourful platform game for Nintendo Switch.",
  price: 79.99,
  stock_quantity: 15
)

Product.create!(
  category: video_games,
  name: "Marvel's Spider-Man 2",
  description: "An action adventure game for PlayStation 5.",
  price: 89.99,
  stock_quantity: 8
)

Product.create!(
  category: video_games,
  name: "Minecraft",
  description: "A building and survival game for many platforms.",
  price: 39.99,
  stock_quantity: 20
)

Product.create!(
  category: consoles,
  name: "Nintendo Switch OLED",
  description: "Nintendo Switch console with an OLED screen.",
  price: 449.99,
  stock_quantity: 5
)

Product.create!(
  category: consoles,
  name: "PlayStation 5",
  description: "Sony PlayStation 5 console with disc drive.",
  price: 649.99,
  stock_quantity: 4
)

Product.create!(
  category: controllers,
  name: "Xbox Wireless Controller",
  description: "Wireless controller for Xbox and Windows PC.",
  price: 74.99,
  stock_quantity: 10
)

Product.create!(
  category: controllers,
  name: "Nintendo Switch Pro Controller",
  description: "Wireless controller for Nintendo Switch.",
  price: 89.99,
  stock_quantity: 9
)

Product.create!(
  category: gift_cards,
  name: "PlayStation Store Gift Card $50",
  description: "A digital gift card for the PlayStation Store.",
  price: 50.00,
  stock_quantity: 9999
)

Product.create!(
  category: gift_cards,
  name: "Nintendo eShop Gift Card $25",
  description: "A digital gift card for the Nintendo eShop.",
  price: 25.00,
  stock_quantity: 9999
)

puts "Seed data created successfully."
puts "#{Category.count} categories created."
puts "#{Product.count} products created."