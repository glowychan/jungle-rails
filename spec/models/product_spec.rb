require 'rails_helper'

RSpec.describe Product, type: :model do

  before(:each) do
    @category = Category.new(name: "test")
    @params = {
      name: "test product",
      price: 10,
      quantity: 100
    }
  end

  describe 'Validations' do
    it "should save valid parameters" do
      @product = @category.products.new(@params)
      expect(@product.valid?).to be true
    end

    it "should have a valid name" do
      @params[:name] = nil
      @product = @category.products.new(@params)
      @product.save
      expect(@product.errors.full_messages).to include "Name must be present"
    end

    it "should have a valid price" do
      @params[:price] = nil
      @product = @category.products.new(@params)
      @product.save
      expect(@product.errors.full_messages).to include "Price must be present"
    end

    it "should have a valid quantity" do
      @params[:quantity] = nil
      @product = @category.products.new(@params)
      @product.save
      expect(@product.errors.full_messages).to include "Quantity must be present"
    end

    it "should have a valid category" do
      @product = Product.new(@params)
      @product.save
      expect(@product.errors.full_messages).to include "Category must be present"
    end
  end
end