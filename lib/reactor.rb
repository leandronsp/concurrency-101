require 'fiber'

class Reactor
  def initialize
    @readable = {}
    @writable = {}
  end

  def run
    while @readable.any? or @writable.any?
      readable, writable =
        IO.select(@readable.keys, @writable.keys, [])

      readable.each do |io|
        @readable[io].resume
      end

      writable.each do |io|
        @writable[io].resume
      end
    end
  end

  def wait_readable(io)
    @readable[io] = Fiber.current
    Fiber.yield
    @readable.delete(io)

    return yield if block_given?
  end

  def wait_writable(io)
    @writable[io] = Fiber.current
    Fiber.yield
    @writable.delete(io)

    return yield if block_given?
  end
end
