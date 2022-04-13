require 'rails_helper'

RSpec.describe Food, type: :model do
  let(:category){
    Category.create(name: 'Makanan')
  }
  subject(:food){
     Food.create(
      name: 'Nasi Uduk',
      description: 'Betawi style steamed rice cooked in coconut milk. Delicious!',
      price: 15000.0,
      category_id: category.id
    )
  }

  it 'is valid with a name and description' do
    expect(food).to be_valid
  end

  it 'is invalid without a name' do
    cateogry = Category.create(name: 'Makanan')
    food = Food.create(
      name: nil,
      description: 'Betawi style steamed rice cooked in coconut milk. Delicious!',
      price: 15000.0,
      category_id: cateogry.id
    )
    expect(food.errors[:name]).to include("can't be blank")
  end
  

  it 'is invalid with a duplicate name' do
    category2 = Category.create(name: 'Minuman')
    food1 = Food.create(
      name: "Nasi Uduk",
      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
      price: 10000.0,
      category_id: category2.id
    )
    
    food2 = Food.new(
      name: "Nasi Uduk",
      description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
      price: 10000.0,
      category_id: category2.id
    )

    food2.valid?
    
    expect(food2.errors[:name]).to include("has already been taken")
  end

  describe 'self#by_letter' do
    it "should return a sorted array of results that match" do
    category2 = Category.create(name: 'Minuman')
      food1 = Food.create(
        name: "Nasi Uduk",
        description: "Betawi style steamed rice cooked in coconut milk. Delicious!",
        price: 10000.0,
        category_id: category2.id
      )

      food2 = Food.create(
        name: "Kerak Telor",
        description: "Betawi traditional spicy omelette made from glutinous rice cooked with egg and served with serundeng.",
        price: 8000.0,
        category_id: category2.id
      )

      food3 = Food.create(
        name: "Nasi Semur Jengkol",
        description: "Based on dongfruit, this menu promises a unique and delicious taste with a small hint of bitterness.",
        price: 8000.0,
        category_id: category2.id
      )

      expect(Food.by_letter("N")).to eq([food3, food1])
    end
  end

    it 'is invalid because Food model does not accept non numeric values for "price" field' do
    food = Food.new(
      name: 'Nasi Uduk',
      description: 'Betawi style steamed rice cooked in coconut milk. Delicious!',
      price: "harga"
    )

    food.valid?

    expect(food.errors[:price]).to include("is not a number")
  end

  it 'is invalid because Food model does not accept "price" less than 0.01' do
    food = Food.new(
      name: 'Nasi Uduk',
      description: 'Betawi style steamed rice cooked in coconut milk. Delicious!',
      price:  0.001
    )

    food.valid?

    expect(food.errors[:price]).to include("must be greater than or equal to 0.01")
  end
end
