class UploadController < ApplicationController
  def index
    @upload = ''
  end
  def receive
    uploaded = params[:file]
    @total_revenue = 0.00
    #Save the upload file in public/uploads with the original file name
    FileUtils.mkdir_p("public/uploads")
    File.open(Rails.root.join('public', 'uploads', uploaded.original_filename), 'wb') do |file|
      file.write(uploaded.read)
    end
    #Opens the uploaded file, parses and save it according the correspondent table
    File.open("public/uploads/#{uploaded.original_filename}", 'r').each_with_index do |line, index|
      next if index == 0
      #identify every single item in the file
      purchaser_name, item_description, item_price, purchase_count, merchant_address, merchant_name  = line.strip.split("\t")

      #sums the revenue of items in file
      @total_revenue += item_price.to_f

      #send data to purchaser table
      purchaser = Purchaser.new(name: purchaser_name)
      purchaser.save
      #send data to the purchase count table
      purchase = Purchase.new(count: purchase_count)
      purchase.save
      #send data to the item table
      item = Item.new(description: item_description, price: item_price)
      item.save
      #send data to the merchant table
      merchant = Merchant.new(name: merchant_name, address: merchant_address)
      merchant.save
    end
  end
end
