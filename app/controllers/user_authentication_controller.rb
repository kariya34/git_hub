# coding: utf-8

class UserAuthenticationController < ApplicationController

  def login
    user = User.new
    user.user_id = params[:user_id]
    user.password = params[:password]
    @user_id = user.user_id
    @password = user.password

    if !(user.valid?) then
      @messages = user.errors.full_messages
      render 'index'
      return
    end
    # userテーブルを検索
    user = User.find_by(:user_id => params[:user_id])
    if user==nil then
      @messages = ['指定されたIDのユーザーは存在しません']

    elsif user.password != params[:password] then
      @messages = ['パスワードが間違っています']

    else
      # データが存在しパスワードが同じ場合、出退勤記録ページへ移動
      session[:user_id] = user.id
      redirect_to controller: 'timecard'
      return
    end
    render 'index'

  end

  def logout
    session[:user_id]=nil
    redirect_to action: 'index'
  end

  def index
    if session[:user_id]!=nil then
      redirect_to controller: 'timecard'
    end
  end

end
