require "open-uri"
require "json"

class FetchDolarPriceJob < ApplicationJob
  queue_as :default

  def perform(*args)
    url = "https://pydolarvenezuela-api.vercel.app/api/v1/dollar?page=bcv&monitor=usd"
    res_serialized = URI.open(url).read
    res = JSON.parse(res_serialized)

    price = CurrentDolarPrice.last || CurrentDolarPrice.create(price: 0, old_price: 0)
    info = res

    date = DateTime.tomorrow
    next_date = DateTime.new(date.year, date.month, date.day, 8)
    if info["price"] == price.price
      next_date = DateTime.now
      FetchDolarPriceJob.set(wait_until: next_date + 30.minutes).perform_later
    else
      price.update(price: info["price"], old_price: price.price)
    end
  end
end
