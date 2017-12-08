class WorkHistoryController < ApplicationController
  layout 'timecard'
  def index
    setShowListValues(currentDateTime())
  end

  def prev
    showListDate = DateTime.new(params[:showListDateY].to_i, params[:showListDateM].to_i, 1) << 1
    setShowListValues(showListDate)
    render 'index'
  end

  def next
    showListDate = DateTime.new(params[:showListDateY].to_i, params[:showListDateM].to_i, 1) >> 1
    setShowListValues(showListDate)
    render 'index'
  end

  private def setShowListValues(showListDate)

    @showListDateY = showListDate.strftime("%Y")
    @showListDateM = showListDate.strftime("%m")

    # 月初を取得
    dateStart = Date.new(showListDate.year , showListDate.month , 1 )
    dateStartNextMonth = dateStart >> 1

    # 出勤時間を取得
    h_workStarts = Hash.new
    workStarts = WorkStart.where('pressed_at >= ? and pressed_at < ? and user_id = ?', \
      dateStart , dateStartNextMonth, session[:user_id])
    workStarts.each do |workStart|
      pressedDay = Date.parse(workStart.pressed_at.strftime("%Y/%m/%d"))
      if !(h_workStarts.has_key?(pressedDay))
        h_workStarts.store(pressedDay,workStart)
      end
    end

    # 退勤時間を取得
    h_workEnds = Hash.new
    workEnds = WorkEnd.where('pressed_at >= ? and pressed_at < ? and user_id = ?', \
      dateStart , dateStartNextMonth, session[:user_id])
    workEnds.each do |workEnd|
      pressedDay = Date.parse(workEnd.pressed_at.strftime("%Y/%m/%d"))
      if !(h_workEnds.has_key?(pressedDay))
        h_workEnds.store(pressedDay,workEnd)
      end
    end

    # 勤務表を作成
    @workTimelist = Array.new
    youbi = %w[日 月 火 水 木 金 土]
    (dateStart..(dateStartNextMonth - 1)).each do |day|

      workTimeData = Hash.new
      startTime = nil
      endTime = nil

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
        workTimeData[:time_m] = convertToWorkMinute(startTime,endTime)
        workTimeData[:time] = convertToHourMinuteFormat(workTimeData[:time_m])
      end

      @workTimelist.push(workTimeData)
    end

    # 勤務日数、勤務時間合計
    @workCount = @workTimelist.count{|data| data[:start]!=nil}
    workTimeTotal = 0
    @workTimelist.each do |data|
      if data[:time_m]!=nil then
        workTimeTotal += data[:time_m]
      end
    end
    @workTimeTotal = convertToHourMinuteFormat(workTimeTotal)
  end

  private def truncSecond(dt)
    return DateTime.new(dt.year,dt.month,dt.day,dt.hour,dt.min,0)
  end

  private def convertToWorkMinute(s,e)
    s1 = truncSecond(s)
    e1 = truncSecond(e)
    return ((e1 - s1) * 24 * 60 * 60).to_i / 60
  end

  private def convertToHourMinuteFormat(m)
    h = m / 60
    m = m % 60
    return format("%02d", h) + ":" + format("%02d", m)
  end

end
