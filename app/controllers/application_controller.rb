class ApplicationController < ActionController::API
  def hello
    render json: { hello: 'world' }
  end
end
