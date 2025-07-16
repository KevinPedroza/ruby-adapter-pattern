# Interactive Workshop Guide: The Adapter Pattern

## 🔍 Explaining the Problem (Interactive Session)

### Interactive Demonstration: "The Incompatible Interface Challenge"

**Materials Needed:**
- USB-C cable
- Old iPhone with Lightning port
- USB-A port computer
- USB-C port computer
- Physical adapter (if available)

**Step 1: Physical Metaphor (3 minutes)**

[Hold up the USB-C cable and the iPhone]

"I have a USB-C cable and an iPhone with a Lightning port. Can I connect them directly? No! The interfaces are incompatible."

[Hold up USB-A port computer and USB-C cable]

"Similarly, I can't plug this USB-C cable directly into this old computer with USB-A ports. In the physical world, what do we do? We use adapters!"

[Show physical adapter if available]

"The adapter solves our incompatibility problem without changing either the cable or the device. This physical example perfectly illustrates what we're trying to do in code."

**Step 2: Code Demonstration (5 minutes)**

"Let's look at a coding scenario. I'll display two code examples side-by-side."

[Display the following code examples side by side]

```ruby
# Company A's Weather API
class WeatherAPI
  def get_temperature(city)
    # API call to get temperature
    rand(0..30)  # Simulating API response
  end
  
  def get_humidity(city)
    # API call to get humidity
    rand(30..90)  # Simulating API response
  end
end

# Our weather dashboard
class WeatherDashboard
  def initialize(weather_service)
    @service = weather_service
  end
  
  def display_weather(city)
    temp = @service.get_temperature(city)
    humidity = @service.get_humidity(city)
    puts "#{city}: #{temp}°C, Humidity: #{humidity}%"
  end
end

# Usage example
api = WeatherAPI.new
dashboard = WeatherDashboard.new(api)
dashboard.display_weather("London")
```

```ruby
# Company B's Weather Service
class BetterWeatherService
  def temperature_data(location)
    # Different API call format
    {
      celsius: rand(0..30),
      fahrenheit: rand(32..86)
    }
  end
  
  def atmospheric_conditions(location)
    {
      humidity: rand(30..90),
      pressure: rand(980..1020)
    }
  end
end
```

**Step 3: Group Interaction (5 minutes)**

"Now I'd like you to discuss with the person next to you:
1. What's the incompatibility problem here?
2. How would you make `BetterWeatherService` work with our existing `WeatherDashboard`?
3. What are the constraints we're working under?"

[Allow 2-3 minutes for discussion]

"Let's hear some of your thoughts..."
[Take 2-3 responses from participants]

"Great observations! You've identified our key challenge: we have two systems with different interfaces that need to work together. Let's now explore the adapter solution."

## 🔧 Explaining the Solution (Interactive Session)

### Interactive Coding: "Building the Adapter"

**Step 1: Collaborative Solution Design (5 minutes)**

"Let's design our adapter together. What methods should our adapter implement to make it compatible with the `WeatherDashboard`?"

[Take responses - looking for: `get_temperature` and `get_humidity`]

"Excellent! And which methods from `BetterWeatherService` will we need to call to fulfill these requirements?"

[Take responses - looking for: `temperature_data` and `atmospheric_conditions`]

"Perfect! Now let's build our adapter."

**Step 2: Live Coding (5 minutes)**

"I'll implement this adapter based on your suggestions:"

```ruby
# Weather Service Adapter
class WeatherServiceAdapter
  def initialize(better_weather_service)
    @service = better_weather_service
  end
  
  def get_temperature(city)
    # Translate the call to the new service's interface
    @service.temperature_data(city)[:celsius]
  end
  
  def get_humidity(city)
    # Translate the call to the new service's interface
    @service.atmospheric_conditions(city)[:humidity]
  end
end

# Usage with the adapter
better_service = BetterWeatherService.new
adapter = WeatherServiceAdapter.new(better_service)
dashboard = WeatherDashboard.new(adapter)

# Now this works even though the interfaces are different!
dashboard.display_weather("Tokyo")
```

**Step 3: Visual Diagram (3 minutes)**

[Draw on whiteboard or show prepared slide]

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│ WeatherDashboard│---->│WeatherSvcAdapter│---->│BetterWeatherSvc │
└─────────────────┘     └─────────────────┘     └─────────────────┘
      Expects:                 Provides:              Provides:
   get_temperature         get_temperature        temperature_data
   get_humidity            get_humidity          atmospheric_cond
```

"This diagram shows the relationship between our classes. The adapter sits in the middle, presenting the interface expected by the dashboard while delegating to the methods provided by the new service."

**Step 4: Key Principles (2 minutes)**

"The adapter pattern has several key principles:

1. **Don't modify what works** - We didn't touch the dashboard code
2. **Separation of concerns** - The adapter's only job is interface translation
3. **Composition over inheritance** - We used object composition to solve the problem
4. **Single responsibility** - Each class has a clear purpose"

## 💡 Real-World Application (5 minutes)

"Let's consider a common real-world scenario in Ruby development:

Imagine you're working with a Rails application that needs to send notifications through multiple channels: email, SMS, and push notifications. Each service has its own interface:

- `EmailService` has `deliver_email(to, subject, body)`
- `SMSProvider` has `send_text(phone_number, message)`
- `PushNotificationAPI` has `push(user_token, notification)`

Instead of writing conditional code throughout your application to handle each service differently, you could create adapters that all implement a common interface like `send_notification(recipient, message)`.

This is exactly how Rails handles database adapters. ActiveRecord communicates with MySQL, PostgreSQL, and SQLite using a consistent interface, despite these databases having very different native APIs."

## 🤔 Reflection Question

"Before we move on to implementing our own adapters, I'd like you to consider: Where in your current projects might the adapter pattern be useful? Think about places where you're dealing with incompatible interfaces or where you might be writing code that has too many conditionals to handle different implementations."

[Allow 1 minute for reflection]

"Now that we understand the problem and solution, let's dig deeper into implementation strategies, starting with our first code example..."
