# 01_basic_adapter.rb
# Basic example of the Adapter Pattern

# Target interface that client expects
class Target
  def request
    "Target: The default target behavior."
  end
end

# Adaptee (existing class with incompatible interface)
class Adaptee
  def specific_request
    ".eetpadA eht fo roivaheb laicepS"  # "Special behavior of the Adaptee." backwards
  end
end

# Adapter - makes Adaptee compatible with Target
class Adapter < Target
  def initialize(adaptee)
    @adaptee = adaptee
  end
  
  def request
    # Translate the request to something the Adaptee can process
    # then translate the response back to what the client expects
    "Adapter: (TRANSLATED) #{@adaptee.specific_request.reverse}"
  end
end

# Client code
def client_code(target)
  puts target.request
end

# Using the Target directly
puts "Client: I can work with Target objects:"
target = Target.new
client_code(target)
puts "\n"

# Using the Adaptee through an Adapter
puts "Client: The Adaptee has an incompatible interface. See:"
adaptee = Adaptee.new
puts "Adaptee: #{adaptee.specific_request}"
puts "\n"

puts "Client: But I can work with it via the Adapter:"
adapter = Adapter.new(adaptee)
client_code(adapter)

# Expected output:
# Client: I can work with Target objects:
# Target: The default target behavior.
#
# Client: The Adaptee has an incompatible interface. See:
# Adaptee: .eetpadA eht fo roivaheb laicepS
#
# Client: But I can work with it via the Adapter:
# Adapter: (TRANSLATED) Special behavior of the Adaptee.
