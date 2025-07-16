# Common Use Cases for Adapter Pattern in Ruby

## 1. Database Adapters

Rails' ActiveRecord uses adapters to provide a consistent interface across different database systems:

```ruby
# Simplified example of how Rails might use adapters
module ActiveRecord
  class Base
    def self.establish_connection(config)
      adapter_class = case config[:adapter]
        when 'postgresql'
          PostgreSQLAdapter
        when 'mysql2'
          MySQL2Adapter
        when 'sqlite3'
          SQLite3Adapter
        else
          raise "Unknown adapter: #{config[:adapter]}"
        end

      @@connection = adapter_class.new(config)
    end
    
    def self.connection
      @@connection
    end
  end
end
```

## 2. API Clients

Adapting between different APIs:

```ruby
# Unified interface for weather services
class WeatherClient
  def initialize(service)
    @service = service
  end
  
  def current_temperature(city)
    @service.get_temperature(city)
  end
  
  def forecast(city, days)
    @service.get_forecast(city, days)
  end
end

# Different weather services with their own interfaces
class WeatherStackAdapter
  def get_temperature(city)
    response = HTTP.get("http://api.weatherstack.com/current", params: {
      access_key: ENV['WEATHERSTACK_KEY'],
      query: city
    })
    response.parse['current']['temperature']
  end
  
  def get_forecast(city, days)
    # Implementation for WeatherStack forecast
  end
end

class OpenWeatherMapAdapter
  def get_temperature(city)
    response = HTTP.get("http://api.openweathermap.org/data/2.5/weather", params: {
      q: city,
      appid: ENV['OPENWEATHERMAP_KEY'],
      units: 'metric'
    })
    response.parse['main']['temp']
  end
  
  def get_forecast(city, days)
    # Implementation for OpenWeatherMap forecast
  end
end
```

## 3. File Format Conversion

Converting between different file formats:

```ruby
# Common interface for document processing
class DocumentProcessor
  def process_document(document)
    raise NotImplementedError
  end
end

# Adapters for different document formats
class PDFAdapter < DocumentProcessor
  def initialize(pdf_parser)
    @parser = pdf_parser
  end
  
  def process_document(document)
    content = @parser.extract_text(document)
    { title: content[:metadata][:title], text: content[:body] }
  end
end

class DocxAdapter < DocumentProcessor
  def initialize(docx_parser)
    @parser = docx_parser
  end
  
  def process_document(document)
    parsed = @parser.parse(document)
    { title: parsed.properties.title, text: parsed.body.text }
  end
end
```

## 4. Testing Adapters

Creating test doubles for external dependencies:

```ruby
# Real payment gateway
class PaymentGateway
  def charge(amount, card_token)
    # Real implementation that calls external API
  end
end

# Test adapter for PaymentGateway
class TestPaymentGateway
  def initialize(responses = {})
    @responses = responses
    @charges = []
  end
  
  def charge(amount, card_token)
    @charges << { amount: amount, token: card_token }
    @responses[:charge] || { success: true, id: "test_#{rand(1000)}" }
  end
  
  def charges
    @charges
  end
end

# Usage in tests
RSpec.describe OrderProcessor do
  let(:payment_gateway) { TestPaymentGateway.new }
  let(:order_processor) { OrderProcessor.new(payment_gateway) }
  
  it "processes payment for an order" do
    order_processor.process(order, "card_token")
    expect(payment_gateway.charges.length).to eq(1)
    expect(payment_gateway.charges.first[:amount]).to eq(order.total)
  end
end
```

## 5. Compatibility Layers

Adapting legacy code to modern interfaces:

```ruby
# Legacy authentication system
class LegacyAuth
  def check_credentials(username, password)
    # Legacy authentication logic
    password == "password" ? "valid" : "invalid"
  end
  
  def get_user_info(username)
    { name: username, level: "user" }
  end
end

# Modern authentication interface
class AuthAdapter
  def initialize(legacy_auth)
    @legacy = legacy_auth
  end
  
  def authenticate(credentials)
    result = @legacy.check_credentials(credentials[:email], credentials[:password])
    { success: result == "valid" }
  end
  
  def get_user(email)
    info = @legacy.get_user_info(email)
    User.new(email: email, name: info[:name], role: info[:level])
  end
end
```

## 6. Integrating External Libraries

Making incompatible libraries work with your application:

```ruby
# Generic notification interface for your app
class NotificationService
  def send_notification(user, message)
    raise NotImplementedError
  end
end

# Adapters for different notification libraries
class TwilioAdapter < NotificationService
  def initialize(client)
    @client = client
  end
  
  def send_notification(user, message)
    @client.messages.create(
      from: ENV['TWILIO_PHONE'],
      to: user.phone,
      body: message
    )
    { success: true }
  end
end

class SendgridAdapter < NotificationService
  def initialize(client)
    @client = client
  end
  
  def send_notification(user, message)
    email = @client.helpers.mail.create(
      from_email: 'notifications@example.com',
      subject: 'Notification',
      to_email: user.email,
      content: message
    )
    
    @client.send(email)
    { success: true }
  end
end
```

## 7. Using Ruby's Standard Library

Adapting between different Ruby standard library interfaces:

```ruby
# Adapter to standardize different Ruby IO-like objects
class IOAdapter
  def initialize(io_like_object)
    @io = io_like_object
  end
  
  def read(bytes = nil)
    if @io.respond_to?(:read)
      @io.read(bytes)
    elsif @io.respond_to?(:gets)
      bytes ? @io.gets(bytes) : @io.gets
    else
      raise "Cannot read from #{@io.class}"
    end
  end
  
  def write(data)
    if @io.respond_to?(:write)
      @io.write(data)
    elsif @io.respond_to?(:puts)
      @io.puts(data)
    else
      raise "Cannot write to #{@io.class}"
    end
  end
end

# Usage examples
file_adapter = IOAdapter.new(File.open('data.txt'))
string_io_adapter = IOAdapter.new(StringIO.new)
```
