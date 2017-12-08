# coding: utf-8

class UserAuthenticationController < ApplicationController
  def login
  
    @message = ""
    if params[:user_id]=="" then
      @message = 'ユーザーIDを入力してください'
    elsif params[:password]=="" then
      @message = 'パスワードを入力してください'
    else
      # userテーブルを検索
      user = User.find_by(:user_id => params[:user_id]) 
      if user==nil then
        @message = 'ユーザーは存在しません'
        
      elsif user.password != params[:password] then 
        @message = 'パスワードが異なります'
      
      else 
        # データが存在しパスワードが同じ場合、出退勤記録ページへ移動
        session[:user_id] = user.id
        redirect_to controller: 'timecard'
        return
        
        # TODO:バリデーション、レイアウトの微調整、追加機能を実装する。
      end 
    end
    
    @user_id = params[:user_id]
    @password = params[:password]
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
