class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    set_week_days
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:calendar).permit(:date, :plan)
  end

  def set_week_days
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @today = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @today..@today + 6)


    7.times do |x|
      day_date = @todays_date + x       # ← 日付オブジェクトを作成
      today_plans = plans.select { |plan| plan.date == day_date }.map(&:plan)
      wday_num = day_date.wday % 7

      days = { :month => (@todays_date + x).month, :date => (@todays_date+x).day, wday: wdays[wday_num], :plans => today_plans}
      @week_days.push(days)
    7.times do |offset|
      today_plans = []
      plans.each do |plan|
        today_plans << plan.plan if plan.date == @today + offset
      end
      days = { month: (@today + offset).month, date: (@today + offset).day, plans: today_plans }
      @week_days << days

    end
  end
end
