require 'rails_helper'


RSpec.feature "ProductDetails", type: :feature, js: true do

  @tmp = ''
  #SETUP 
  before :each do
    @category = Category.create! name: 'Apparel'

    1.times do |n|
      tmp = Faker::Hipster.sentence(3)
      puts tmp
      puts 'above is secret code!!!'
      @category.products.create!(
        name:  tmp,
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )
    end
  end

  scenario "They see product details by clicking on product" do
    #ACT
    visit '/'
    first('.pull-right').click

    sleep 5
    #DEBUG 
    save_and_open_screenshot

    #VERIFY
    expect(page).to have_content 'Description'
  end
end
