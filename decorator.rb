require 'securerandom'

class EventQueue
  attr_accessor :messages

  def initialize
    @messages = []
  end

  def enqueue(event, args, state)
    @messages << [event, args, state]
  end
end

module Notifier
  def notify_on(event)
    guid = SecureRandom.uuid
    puts "#{guid} ==> #{event}"

    define_method("#{guid}") do |*args|
      @event_queue.enqueue(event, args, :start)
      begin
        result = __send__("#{guid}_#{event}", *args)
      ensure
        @event_queue.enqueue(event, args, :end)
      end
      result
    end

    alias_method "#{guid}_#{event}", event
    alias_method event, "#{guid}"
  end
end

class Store
  extend Notifier

  def initialize(event_queue)
    @event_queue = event_queue
  end

  def order_purchase(user, items)
    ## @event_queue.enqueue(__method__, [user, items], :start)
    do_stuff
    ## @event_queue.enqueue(__method__, [user, items], :end)
  end

  def decrease_inventory(items)
    ## @event_queue.enqueue(__method__, [items], :start)
    do_stuff
    ## @event_queue.enqueue(__method__, [items], :end)
  end

  notify_on :order_purchase
  notify_on :decrease_inventory      

  private

  def do_stuff
    puts "called from #{caller[0]}"
  end
end

puts "#" * 100
queue = EventQueue.new
store = Store.new(queue)
store.order_purchase("alan", ["book", "pen"])
puts "#" * 100
puts "messages = #{queue.messages.inspect}"
puts "#" * 100
puts Store.new(queue).methods.sort - Object.methods.sort
