class TimecardController < ApplicationController

  def index
    setIndexValues()
  end

  def showList
    setShowListValues(systemDate())
  end
  
  def showListPrev
    showListDate = DateTime.new(params[:showListDateY].to_i, params[:showListDateM].to_i, 1) << 1
    setShowListValues(showListDate)
    render 'showList'
  end
  
  def showListNext
    showListDate = DateTime.new(params[:showListDateY].to_i, params[:showListDateM].to_i, 1) >> 1
    setShowListValues(showListDate)
    render 'showList'
  end
  
  def workStart
    # 出勤時間の登録がないか検索
    pressedAt = systemDate()
    from = Date.parse(pressedAt.strftime("%Y/%m/%d"))
    to = from + 1
    workStarts = WorkStart.where('pressed_at >= ? and pressed_at < ? and user_id = ?', from , to, session[:user_id])
    
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
    pressedAt = systemDate()
    from = Date.parse(pressedAt.strftime("%Y/%m/%d"))
    to = from + 1
    workEnds = WorkEnd.where('pressed_at >= ? and pressed_at < ? and user_id = ?', from , to, session[:user_id])
    
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
  
  private def systemDate
    @systemDate = DateTime.now
    return @systemDate
  end
  
  private def setIndexValues
  
    # 本日の日付
    now = systemDate()
    @year = now.year
    @month = now.month
    @day = now.day
    youbi = %w[日 月 火 水 木 金 土]
    @youbi = youbi[now.wday]

    # 現在時刻
    @time = now.strftime("%H:%M:%S")

    # 現在状況
    now = systemDate()
    from = Date.parse(now.strftime("%Y/%m/%d"))
    to = from + 1
    workStarts = WorkStart.where('pressed_at >= ? and pressed_at < ? and user_id = ?', from , to, session[:user_id])
    workEnds = WorkEnd.where('pressed_at >= ? and pressed_at < ? and user_id = ?', from , to, session[:user_id])
    
    @isWorkStart = workStarts.count > 0
    @isWorkEnd = workEnds.count > 0

  end
  
  private def setShowListValues(showListDate)
  
    @showListDateY = showListDate.strftime("%Y")
    @showListDateM = showListDate.strftime("%m")
    
    # 月末日を取得
    dateStart = Date.new(showListDate.year , showListDate.month , 1 )
    dateStartNextMonth = dateStart >> 1
    
    # 出勤時間を取得
    h_workStarts = Hash.new
    workStarts = WorkStart.where('pressed_at >= ? and pressed_at < ? and user_id = ?', dateStart , dateStartNextMonth, session[:user_id])
    workStarts.each do |workStart|
      pressedDay = Date.parse(workStart.pressed_at.strftime("%Y/%m/%d"))
      if !(h_workStarts.has_key?(pressedDay))
        h_workStarts.store(pressedDay,workStart)
      end 
    end

    # 退勤時間を取得
    h_workEnds = Hash.new
    workEnds = WorkEnd.where('pressed_at >= ? and pressed_at < ? and user_id = ?', dateStart , dateStartNextMonth, session[:user_id])
    workEnds.each do |workEnd|
      pressedDay = Date.parse(workEnd.pressed_at.strftime("%Y/%m/%d"))
      if !(h_workEnds.has_key?(pressedDay))
        h_workEnds.store(pressedDay,workEnd)
      end 
    end
    
    # 勤務表を作成
    @workTimelist = Array.new
    dateEnd = dateStartNextMonth - 1
    day = dateStart
    youbi = %w[日 月 火 水 木 金 土]
    while day <= dateEnd do

      workTimeData = Hash.new
      
      startTime = nil
      endTime = nil
      time = nil
      m = nil
      workTimeData[:day] = day.strftime("%m/%d")
      workTimeData[:youbi] = youbi[day.wday]
      if h_workStarts.has_key?(day) then
        startTime = h_workStarts.fetch(day).pressed_at
        workTimeData[:start] = startTime.strftime("%H:%M")
      end 
      if h_workEnds.has_key?(day) then
        endTime = h_workEnds.fetch(day).pressed_at
        workTimeData[:end] = endTime.strftime("%H:%M")
      end
      if startTime!=nil && endTime!=nil then
        s = (endTime - startTime).to_i
        m = s / 60
        workTimeData[:time_m] = m
        h = m / 60
        m = m % 60
        time = format("%02d", h) + ":" + format("%02d", m)
        workTimeData[:time] = time
      end
      
      @workTimelist.push(workTimeData)

      day += 1
    end
    
    # 勤務日数、勤務時間合計
    @workCount = @workTimelist.count{|data| data[:start]!=nil}
    workTimeTotal = 0
    @workTimelist.each do |data|
      if data[:time_m]!=nil then
        workTimeTotal += data[:time_m]
      end
    end
    h = workTimeTotal / 60
    m = workTimeTotal % 60
    @workTimeTotal = format("%02d", h) + ":" + format("%02d", m)
  end
end
