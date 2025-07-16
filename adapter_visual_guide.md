# Adapter Pattern Visual Guide

## Basic Structure

```
┌─────────┐     ┌─────────┐     ┌─────────────┐
│ Client  │────▶│ Target  │◀────│   Adapter   │
└─────────┘     │Interface│     │             │
                └─────────┘     │  ┌─────────┐│
                               ┌┼──│ Adaptee ││
                               │└──┤         ││
                               └───┴─────────┘┘
```

## UML Class Diagram

```
┌───────────┐     ┌───────────────┐
│  Client   │     │    Target     │
└───────────┘     │───────────────│
      │           │ + request()   │
      │           └───────┬───────┘
      │                   ▲
      │                   │
      │           ┌───────┴───────┐         ┌───────────────┐
      └──────────▶│    Adapter    │─────────│    Adaptee    │
                  │───────────────│         │───────────────│
                  │ + request()   │         │ + specificReq │
                  └───────────────┘         └───────────────┘
                          │                         ▲
                          └─────────────────────────┘
```

## Adapter Patterns in Ruby

### 1. Class Adapter Pattern (using inheritance)

```ruby
# Uses inheritance to adapt one interface to another
class Adapter < Target
  def initialize
    @adaptee = Adaptee.new
  end
  
  def request
    # Translate and delegate to adaptee
    result = @adaptee.specific_request
    # Process result as needed
    result
  end
end
```

### 2. Object Adapter Pattern (using composition)

```ruby
# Uses composition to adapt one interface to another
class Adapter
  def initialize(adaptee)
    @adaptee = adaptee
  end
  
  def request
    # Translate and delegate to adaptee
    result = @adaptee.specific_request
    # Process result as needed
    result
  end
end
```

### 3. Ruby Specific: Module as Adapter

```ruby
# Define adapter behavior in a module
module AdapterBehavior
  def request
    # Call the adaptee's method and adapt result
    result = specific_request
    # Process result as needed
    result
  end
end

# Extend an object with the adapter module
adaptee = Adaptee.new
adaptee.extend(AdapterBehavior)
```

## When to Use Each Approach

| Approach | When to Use | Pros | Cons |
|----------|-------------|------|------|
| Class Adapter | When adapting a single class | Simple implementation | Limited to single inheritance |
| Object Adapter | When adapting multiple classes | Flexible, works with class hierarchies | Slightly more complex |
| Monkey Patching | When making minor changes to existing classes | Direct and concise | Can lead to conflicts, harder to debug |
| Singleton Methods | When adapting specific instances | No global changes | Doesn't apply to new instances |
| Module Extensions | When behavior is reusable | Clean organization, reusable | Requires understanding of Ruby modules |

## Real-world Use Cases

1. **Database Adapters** - Abstract database-specific implementations
2. **API Clients** - Convert between different API formats
3. **Payment Gateways** - Standardize interfaces to payment processors
4. **Legacy System Integration** - Adapt old systems to new interfaces
5. **Testing** - Create test adapters for external dependencies
