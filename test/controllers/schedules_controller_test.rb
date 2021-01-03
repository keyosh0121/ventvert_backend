# frozen_string_literal: true

require 'test_helper'

class SchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @schedule = schedules(:one)
    post users_url params: { user: { email: 'user1@email.jp', password: 'password' } }, as: :json
    res = JSON.parse(response.body)
    @token = res['access_token']
    request.headers['Authorization'] = @token
  end

  test 'should show schedule' do
    get schedule_url(@schedule), headers: { Authorization: @token }, as: :json
    assert_response :success
  end

  # 予定の全取得
  test 'PLAN-S001' do
    get schedules_url, headers: { Authorization: @token }, as: :json
    assert_response :success
  end

  # 予定の追加
  test 'PLAN-S002' do
    assert_difference('Schedule.count') do
      post schedules_url,
           params: { schedule: { content: @schedule.content, date: @schedule.date, time: @schedule.time, user_id: @schedule.user_id } }, headers: { Authorization: @token }, as: :json
    end

    assert_response 201
  end

  # 予定の削除
  test 'PLAN-S003' do
    assert_difference('Schedule.count', -1) do
      delete schedule_url(@schedule), headers: { Authorization: @token }, as: :json
    end

    assert_response 204
  end

  # 予定の更新
  test 'PLAN-S004' do
    patch schedule_url(@schedule),
          params: { schedule: { content: @schedule.content, date: @schedule.date, time: @schedule.time, user_id: @schedule.user_id } }, headers: { Authorization: @token }, as: :json
    assert_response 200
  end

  # 予定の全取得（ログイン認証なし）
  test 'PLAN-E001' do
    get schedules_url, as: :json
    assert_response 401
  end

  # 予定の追加（ログイン認証なし）
  test 'PLAN-E002' do
    post schedules_url,
         params: { schedule: { content: @schedule.content, date: @schedule.date, time: @schedule.time, user_id: @schedule.user_id } }, as: :json
    assert_response 401
  end

  # 予定の削除（ログイン認証なし）
  test 'PLAN-E003' do
    delete schedule_url(@schedule), as: :json
    assert_response 401
  end

  # 予定の更新（ログイン認証なし）
  test 'PLAN-E004' do
    patch schedule_url(@schedule),
          params: { schedule: { content: @schedule.content, date: @schedule.date, time: @schedule.time, user_id: @schedule.user_id } }, as: :json
    assert_response 401
  end
end
