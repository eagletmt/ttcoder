class CodeboardController < ApplicationController
  CODEBOARD_KEY = 'ttcoder:codeboard'
  CODEBOARD_EXPIRE = 1.hour

  def show
    $redis.expire CODEBOARD_KEY, CODEBOARD_EXPIRE
    @source = $redis.get CODEBOARD_KEY
  end

  def create
    code = params[:source]
    $redis.expire CODEBOARD_KEY, CODEBOARD_EXPIRE
    $redis.set CODEBOARD_KEY, code
    head :no_content
  end
end
