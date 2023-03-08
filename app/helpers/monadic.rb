module Monadic

  class Ok
    attr_accessor :value

    def self.[](arg)
      Ok.new(arg)
    end

    def initialize(value)
      @value = value
    end
  end

  class Error
    attr_accessor :error

    def self.[](arg)
      Error.new(arg)
    end

    def initialize(error)
      @error = error
    end
  end

  module Result
    # Usage example
    
    # class UsersController 
    #   include Monadic::Result

    #   def validate_params
    #     Ok[[:email, :password].inject(Hash.new) { |h, v| h[v] = params.fetch(v); h}] rescue Error.new("Email or password is missing")
    #   end
  
    #   def find_user params
    #     user = User.find_by(email: params[:email])
    #     return Error["User with email #{params[:email]} doesn't exist"] if user.nil?
    #     return Error["Wrong password"] unless user.password == params[:password]
    #     Ok[user]
    #   end
    
    # Every function, the result of which
    # is yielded in do_login(such as validate_params and find_user), 
    # should return either Ok or Error.
    # In case of Ok the value is extracted from Ok
    # object and then used further in code. 
    # In case of Error the early return is used
    # and the execution of a function is terminated
    # returning this error.

    #   def do_login
    #     validated_params = yield validate_params
    #     user = yield find_user(validated_params)
    #     cookie = new_cookie
    #     user.update_attribute(:cookie, cookie)
    #     Ok[user_id: user.id, cookie: cookie]
    #   end
  
    #   def login
    #     case result = run_result(:do_login)
    #     when Ok
    #       render json: {
    #         message: "Logged in",
    #         user_id: result.value[:user_id],
    #         cookie: result.value[:cookie]
    #      }
    #     when Error
    #       render json: {
    #         message: "Error: #{result.error}"
    #       }
    #     end
    #   end

    Ok = Monadic::Ok
    Error = Monadic::Error

    # Can only be used with a method.
    # It would be cool to use it with a block like this
    # result = run_result_block(10) do |value| # value is 10
    #   value1 = yield do_this(value) # do_this adds 5, returns Ok[15], unwrapped to 15 in yield
    #   value2 = yeild do_that(value1) # do_that adds 1, returns Ok[16], unwrapped to 16
    #   Ok[value1 + value2] # returns Ok[31]
    # end
    # But yield inside the block is lexically
    # scoped and at the moment of the block
    # definition there is no other block to yield to, 
    # so AFAIK it's impossible

    def run_result_method(symbol, *args)
      self.send(symbol, *args) do |arg|
        case arg
        when Ok
          arg.value
        when Error 
          break(arg)
        end
      end
    end
  end

  module Transaction

    Ok = Monadic::Ok
    Error = Monadic::Error
    
    class Abort < StandardError
      attr_accessor :reason

      def self.[](reason)
        raise Abort.new(reason)
      end

      def initialize(reason)
        self.reason = reason
      end
    end

    # Usage example for run_transaction_method
    # def do_register(user)
    #   Abort[user.errors.full_messages] if !user.save
    #   Abort["Failed to add contact"] if !add_contact(user, user.id)
    #   Ok[user_id: user.id]
    # end
  
    # def register
    #   user = User.new(register_params)
    #   result = run_transaction_method(:do_register, user)
    #   case result
    #     when Ok
    #       ...
    #     when Error
    #       ...
    #   end
    # end
    
    def run_transaction_method(symbol, *args)
      run_transaction_block(*args) { |*args| self.send(symbol, *args) }
    end

    def run_transaction_block(*args)
      result = nil
      begin
        ActiveRecord::Base.transaction do
          result = yield(*args)
        end
        case result
        when Ok
          result
        else
          Ok[result]
        end
      rescue => abort
        case abort
        when Abort
          Error[abort.reason]
        else
          Error[abort]
        end
      end
    end
  end

end