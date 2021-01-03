# frozen_string_literal: true

require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @notification = notifications(:one)
    post users_url params: { user: { email: 'user1@email.jp', password: 'password' } }, as: :json
    res = JSON.parse(response.body)
    @token = res['access_token']
    request.headers['Authorization'] = @token
  end

  # 通知の全取得
  test 'NOTF-S001' do
    get notifications_url, headers: { Authorization: @token }, as: :json
    assert_response :success
  end

  # 通知の追加
  test 'NOTF-S002' do
    assert_difference('Notification.count') do
      post notifications_url,
           params: { notification: { alert: @notification.alert, content: @notification.content, title: @notification.title, unopened: @notification.unopened, user_id: @notification.user_id } }, headers: { Authorization: @token }, as: :json
    end

    assert_response 201
  end

  test 'should show notification' do
    get notification_url(@notification), headers: { Authorization: @token }, as: :json
    assert_response :success
  end

  # 通知の削除
  test 'NOTF-S003' do
    assert_difference('Notification.count', -1) do
      delete notification_url(@notification), headers: { Authorization: @token }, as: :json
    end

    assert_response 204
  end

  # 通知の更新
  test 'NOTF-S004' do
    patch notification_url(@notification),
          params: { notification: { alert: @notification.alert, content: @notification.content, title: @notification.title, unopened: @notification.unopened, user_id: @notification.user_id } }, headers: { Authorization: @token }, as: :json
    assert_response 200
  end

  # 通知の全取得（ログイン認証なし）
  test 'NOTF-E001' do
    get notifications_url, as: :json
    assert_response 401
  end

  # 通知の追加（ログイン認証なし）
  test 'NOTF-E002' do
    post notifications_url,
         params: { notification: { alert: @notification.alert, content: @notification.content, title: @notification.title, unopened: @notification.unopened, user_id: @notification.user_id } }, as: :json
    assert_response 401
  end

  # 通知の削除（ログイン認証なし）
  test 'NOTF-E003' do
    delete notification_url(@notification), as: :json
    assert_response 401
  end

  # 通知の更新（ログイン認証なし）
  test 'NOTF-E004' do
    patch notification_url(@notification),
          params: { notification: { alert: @notification.alert, content: @notification.content, title: @notification.title, unopened: @notification.unopened, user_id: @notification.user_id } }, as: :json
    assert_response 401
  end
end
