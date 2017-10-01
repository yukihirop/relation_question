require 'bundler'
Bundler.require

require "active_record"
require "minitest/autorun"
require "logger"

# This connection will do for database-independent bug reports.
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")
ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Schema.define do
  create_table :orders, force: true do |t|
    t.string 'name'
    t.string 'description'
  end
end

class Order < ActiveRecord::Base
end

3.times { |i| Order.create(name: "name_#{i}", description: "description_#{i}") }
$binding_pry = true
@order = Order.where("foo.name" => "name_1", description: "description_1")
