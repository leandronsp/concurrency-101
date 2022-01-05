require 'celluloid'
require 'byebug'

Celluloid.boot

class Account
  include Celluloid

  def initialize(initial_balance = 0)
    @balance = initial_balance
  end

  def increment(value)
    @balance += value
  end
end

@account = Account.new

2.times.map do
  Celluloid::Future.new do
    50_000.times do
      @account.async.deposit(1)
    end
  end
end.each(&:value)

puts "Balance is: #{@account.balance}"
