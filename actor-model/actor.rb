class Actor
  def initialize(initial_state)
    @state = Queue.new
    @state << initial_state
  end
end
