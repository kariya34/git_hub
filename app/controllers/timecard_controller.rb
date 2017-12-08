class TimecardController < ApplicationController

  def index
    setIndexValues()
  end

  def workStart
    # 出勤時間の登録がないか検索
    pressedAt = currentDateTime()
    from = Date.parse(pressedAt.strftime("%Y/%m/%d"))
    to = from + 1
    workStarts = WorkStart.where('pressed_at >= ? and pressed_at < ? and user_id = ?', \
      from , to, session[:user_id])

    if workStarts.count > 0 then
      # 既に登録済み
      workStarts.each do |workStart|
        @message = workStart.pressed_at.strftime("%Y-%m-%d %H:%M:%S") + ' に出社しています'
      end
      setIndexValues()
      render 'index'

    else
      # 登録
      workStart = WorkStart.new
      workStart.user_id = session[:user_id]
      workStart.pressed_at = pressedAt
      workStart.save
      redirect_to action: 'index'
    end
  end

  def workEnd
    # 退勤時間の登録がないか検索
    pressedAt = currentDateTime()
    from = Date.parse(pressedAt.strftime("%Y/%m/%d"))
    to = from + 1
    workEnds = WorkEnd.where('pressed_at >= ? and pressed_at < ? and user_id = ?', \
      from , to, session[:user_id])

    if workEnds.count > 0 then
      # 既に登録済み
      workEnds.each do |workEnd|
        @message = workEnd.pressed_at.strftime("%Y-%m-%d %H:%M:%S") + ' に退社しています'
      end
      setIndexValues()
      render 'index'

    else
      # 登録
      workEnd = WorkEnd.new
      workEnd.user_id = session[:user_id]
      workEnd.pressed_at = pressedAt
      workEnd.save
      redirect_to action: 'index'
    end
  end

  private def setIndexValues

    # 本日の日付
    now = currentDateTime()
    @year = now.year
    @month = now.month
    @day = now.day
    youbi = %w[日 月 火 水 木 金 土]
    @youbi = youbi[now.wday]

    # 現在時刻
    @time = now.strftime("%H:%M:%S")

    # 現在状況
    from = Date.parse(now.strftime("%Y/%m/%d"))
    to = from + 1
    workStarts = WorkStart.where('pressed_at >= ? and pressed_at < ? and user_id = ?', \
      from , to, session[:user_id])
    workEnds = WorkEnd.where('pressed_at >= ? and pressed_at < ? and user_id = ?', \
      from , to, session[:user_id])

    @isWorkStart = workStarts.count > 0
    @isWorkEnd = workEnds.count > 0

  end

end
