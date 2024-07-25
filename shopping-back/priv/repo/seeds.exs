# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Shopping.Repo.insert!(%Shopping.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Shopping.Repo
alias Shopping.Product.Inventory
alias Shopping.UserManager.User

# Create sample product inventories
inventories = [
  %{
    name: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
    description: "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
    price: Decimal.new("109.95"),
    quantity: 2,
    image_url: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg"
  },
  %{
    name: "Mens Casual Premium Slim Fit T-Shirts",
    description: "Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing.",
    price: Decimal.new("22.3"),
    quantity: 4,
    image_url: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg"
  },
  %{
    name: "Mens Cotton Jacket",
    description: "Great outerwear jackets for Spring/Autumn/Winter, suitable for many occasions.",
    price: Decimal.new("55.99"),
    quantity: 6,
    image_url: "https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg"
  },
  %{
    name: "Mens Casual Slim Fit",
    description: "The color could be slightly different between on the screen and in practice.",
    price: Decimal.new("15.99"),
    quantity: 6,
    image_url: "https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_.jpg"
  },
  %{
    name: "John Hardy Women's Legends Naga Gold & Silver Dragon Station Chain Bracelet",
    description: "From our Legends Collection, the Naga was inspired by the mythical water dragon.",
    price: Decimal.new("695"),
    quantity: 11,
    image_url: "https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_.jpg"
  },
  %{
    name: "Solid Gold Petite Micropave",
    description: "Satisfaction Guaranteed. Return or exchange any order within 30 days.",
    price: Decimal.new("168"),
    quantity: 70,
    image_url: "https://fakestoreapi.com/img/61sbMiUnoGL._AC_UL640_QL65_ML3_.jpg"
  },
  %{
    name: "White Gold Plated Princess",
    description: "Classic Created Wedding Engagement Solitaire Diamond Promise Ring for Her.",
    price: Decimal.new("9.99"),
    quantity: 33,
    image_url: "https://fakestoreapi.com/img/71YAIFU48IL._AC_UL640_QL65_ML3_.jpg"
  },
  %{
    name: "Pierced Owl Rose Gold Plated Stainless Steel Double",
    description: "Rose Gold Plated Double Flared Tunnel Plug Earrings.",
    price: Decimal.new("10.99"),
    quantity: 100,
    image_url: "https://fakestoreapi.com/img/51UDEzMJVpL._AC_UL640_QL65_ML3_.jpg"
  },
  %{
    name: "WD 2TB Elements Portable External Hard Drive - USB 3.0",
    description: "USB 3.0 and USB 2.0 Compatibility Fast data transfers Improve PC Performance.",
    price: Decimal.new("64"),
    quantity: 203,
    image_url: "https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_.jpg"
  },
  %{
    name: "SanDisk SSD PLUS 1TB Internal SSD - SATA III 6 Gb/s",
    description: "Easy upgrade for faster boot up, shutdown, application load and response.",
    price: Decimal.new("109"),
    quantity: 470,
    image_url: "https://fakestoreapi.com/img/61U7T1koQqL._AC_SX679_.jpg"
  },
  %{
    name: "Silicon Power 256GB SSD 3D NAND A55 SLC Cache Performance Boost SATA III 2.5",
    description: "3D NAND flash are applied to deliver high transfer speeds.",
    price: Decimal.new("109"),
    quantity: 319,
    image_url: "https://fakestoreapi.com/img/71kWymZ+c+L._AC_SX679_.jpg"
  },
  %{
    name: "WD 4TB Gaming Drive Works with Playstation 4 Portable External Hard Drive",
    description: "Expand your PS4 gaming experience, Play anywhere.",
    price: Decimal.new("114"),
    quantity: 400,
    image_url: "https://fakestoreapi.com/img/61mtL65D4cL._AC_SX679_.jpg"
  },
  %{
    name: "Acer SB220Q bi 21.5 inches Full HD (1920 x 1080) IPS Ultra-Thin",
    description: "21.5 inches Full HD (1920 x 1080) widescreen IPS display.",
    price: Decimal.new("599"),
    quantity: 250,
    image_url: "https://fakestoreapi.com/img/81QpkIctqPL._AC_SX679_.jpg"
  },
  %{
    name: "Samsung 49-Inch CHG90 144Hz Curved Gaming Monitor",
    description: "49 INCH SUPER ULTRAWIDE 32:9 CURVED GAMING MONITOR.",
    price: Decimal.new("999.99"),
    quantity: 140,
    image_url: "https://fakestoreapi.com/img/81Zt42ioCgL._AC_SX679_.jpg"
  },
  %{
    name: "BIYLACLESEN Women's 3-in-1 Snowboard Jacket Winter Coats",
    description: "Note: The Jackets is US standard size.",
    price: Decimal.new("56.99"),
    quantity: 235,
    image_url: "https://fakestoreapi.com/img/51Y5NI-I5jL._AC_UX679_.jpg"
  },
  %{
    name: "Lock and Love Women's Removable Hooded Faux Leather Moto Biker Jacket",
    description: "100% POLYURETHANE(shell) 100% POLYESTER(lining).",
    price: Decimal.new("29.95"),
    quantity: 340,
    image_url: "https://fakestoreapi.com/img/81XH0e8fefL._AC_UY879_.jpg"
  },
  %{
    name: "Rain Jacket Women Windbreaker Striped Climbing Raincoats",
    description: "Lightweight perfect for trip or casual wear.",
    price: Decimal.new("39.99"),
    quantity: 679,
    image_url: "https://fakestoreapi.com/img/71HblAHs5xL._AC_UY879_-2.jpg"
  },
  %{
    name: "MBJ Women's Solid Short Sleeve Boat Neck V",
    description: "95% RAYON 5% SPANDEX, Made in USA or Imported.",
    price: Decimal.new("9.85"),
    quantity: 130,
    image_url: "https://fakestoreapi.com/img/71z3kpMAYsL._AC_UY879_.jpg"
  },
  %{
    name: "Opna Women's Short Sleeve Moisture",
    description: "100% Polyester, Machine wash.",
    price: Decimal.new("7.95"),
    quantity: 146,
    image_url: "https://fakestoreapi.com/img/51eg55uWmdL._AC_UX679_.jpg"
  },
  %{
    name: "DANVOUY Womens T Shirt Casual Cotton Short",
    description: "95%Cotton,5%Spandex, Features: Casual, Short Sleeve.",
    price: Decimal.new("12.99"),
    quantity: 145,
    image_url: "https://fakestoreapi.com/img/61pHAEJ4NML._AC_UX679_.jpg"
  }
]

# Insert the inventories into the database
for inventory <- inventories do
  Repo.insert!(%Inventory{
    name: inventory.name,
    description: inventory.description,
    price: inventory.price,
    quantity: inventory.quantity,
    image_url: inventory.image_url
  })
end

Repo.insert!(%User{
  username: "admin",
  password: Argon2.hash_pwd_salt("admin"),
  balance: Decimal.new("100")
})
