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
    # モデル名が Plan なので、require(:plan) に修正
    params.require(:plan).permit(:date, :plan)
  end

  def set_week_days
    wdays = ['(日)', '(月)', '(火)', '(水)', '(木)', '(金)', '(土)']

    @today = Date.today
    @week_days = []

    # 今日から6日後までの予定を取得
    plans = Plan.where(date: @today..@today + 6)

    # 1週間分の日付を作成して代入
    7.times do |x|
      day_date = @today + x
      today_plans = plans.select { |plan| plan.date == day_date }.map(&:plan)

      wday_num = day_date.wday
      days = {
        month: day_date.month,
        date: day_date.day,
        wday: wdays[wday_num],
        plans: today_plans
      }

      @week_days.push(days)
    end
  end
end
