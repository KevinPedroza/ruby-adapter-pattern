# 02_payment_processor_adapter.rb
# Real-world example: Payment gateway adapters

# Our application's expected interface for payment processing
class PaymentProcessor
  def process_payment(amount)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
  
  def refund_payment(transaction_id)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

# Stripe payment gateway - third-party service with its own interface
class StripeGateway
  def charge(amount_in_cents, token)
    # In a real application, this would call the Stripe API
    puts "Stripe charging $#{amount_in_cents / 100.0}..."
    { success: true, transaction_id: "stripe_#{rand(1000)}" }
  end
  
  def refund(transaction_reference)
    # In a real application, this would call the Stripe API
    puts "Stripe refunding transaction #{transaction_reference}..."
    { success: true }
  end
end

# PayPal payment gateway - another third-party service with different interface
class PayPalService
  def make_payment(amount_usd, user_account)
    # In a real application, this would call the PayPal API
    puts "PayPal charging $#{amount_usd}..."
    { status: "COMPLETED", paypal_id: "paypal_#{rand(1000)}" }
  end
  
  def issue_refund(paypal_transaction_id)
    # In a real application, this would call the PayPal API
    puts "PayPal refunding transaction #{paypal_transaction_id}..."
    { status: "REFUNDED" }
  end
end

# Adapter for Stripe
class StripeAdapter < PaymentProcessor
  def initialize(stripe_gateway)
    @stripe = stripe_gateway
  end
  
  def process_payment(amount)
    # Convert dollars to cents for Stripe
    result = @stripe.charge(amount * 100, "dummy_token")
    
    if result[:success]
      { success: true, transaction_id: result[:transaction_id] }
    else
      { success: false, error: "Payment failed" }
    end
  end
  
  def refund_payment(transaction_id)
    result = @stripe.refund(transaction_id)
    
    if result[:success]
      { success: true }
    else
      { success: false, error: "Refund failed" }
    end
  end
end

# Adapter for PayPal
class PayPalAdapter < PaymentProcessor
  def initialize(paypal_service)
    @paypal = paypal_service
  end
  
  def process_payment(amount)
    result = @paypal.make_payment(amount, "dummy_user@example.com")
    
    if result[:status] == "COMPLETED"
      { success: true, transaction_id: result[:paypal_id] }
    else
      { success: false, error: "Payment failed" }
    end
  end
  
  def refund_payment(transaction_id)
    result = @paypal.issue_refund(transaction_id)
    
    if result[:status] == "REFUNDED"
      { success: true }
    else
      { success: false, error: "Refund failed" }
    end
  end
end

# Client code
class OnlineStore
  def initialize(payment_processor)
    @payment_processor = payment_processor
  end
  
  def purchase_product(product_name, amount)
    puts "Processing purchase for #{product_name} at $#{amount}..."
    result = @payment_processor.process_payment(amount)
    
    if result[:success]
      puts "Payment successful! Transaction ID: #{result[:transaction_id]}"
      result[:transaction_id]
    else
      puts "Payment failed: #{result[:error]}"
      nil
    end
  end
  
  def refund_product(transaction_id)
    puts "Processing refund for transaction #{transaction_id}..."
    result = @payment_processor.refund_payment(transaction_id)
    
    if result[:success]
      puts "Refund successful!"
    else
      puts "Refund failed: #{result[:error]}"
    end
  end
end

# Demo usage with Stripe
puts "=== USING STRIPE ==="
stripe_gateway = StripeGateway.new
stripe_adapter = StripeAdapter.new(stripe_gateway)
store_with_stripe = OnlineStore.new(stripe_adapter)

transaction = store_with_stripe.purchase_product("Mechanical Keyboard", 149.99)
store_with_stripe.refund_product(transaction) if transaction

puts "\n=== USING PAYPAL ==="
paypal_service = PayPalService.new
paypal_adapter = PayPalAdapter.new(paypal_service)
store_with_paypal = OnlineStore.new(paypal_adapter)

transaction = store_with_paypal.purchase_product("Ergonomic Mouse", 59.99)
store_with_paypal.refund_product(transaction) if transaction
