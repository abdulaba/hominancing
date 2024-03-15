require "open-uri"
require "json"

class FetchDolarPriceJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # url = "https://pydolarvenezuela-api.vercel.app/api/v1/dollar/"
    # res_serialized = URI.open(url).read
    # res = JSON.parse(res_serialized)

    # price = CurrentDolarPrice.last
    # info = res["monitors"]["bcv"]

    # date = DateTime.tomorrow
    # next_date = DateTime.new(date.year, date.month, date.day, 8)
    # if info["last_update"] == price.last_update
    #   FetchDolarPriceJob.set(wait_until: next_date + 15.min).perform_later
    # else
    #   FetchDolarPriceJob.set(wait_until: next_date).perform_later
    #   price.update(price: info["price"]], old_price: price.price, last_updated: info["last_update"])
    # end
    url = "https://pydolarvenezuela-api.vercel.app/api/v1/dollar/unit/enparalelovzla"
    res_serialized = URI.open(url).read
    res = JSON.parse(res_serialized)

    price = CurrentDolarPrice.last
    price.update(price: res["price"], old_price: price.price)

    date = DateTime.now
    next_date = DateTime.new(date.year, date.month, date.day, 13, 45, 0, date.offset)
    FetchDolarPriceJob.set(wait_until: next_date).perform_later
    FetchDolarPriceJob.set(wait_until: next_date + 15.minutes).perform_later
  end
end
