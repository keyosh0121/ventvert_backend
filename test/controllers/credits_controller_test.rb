# frozen_string_literal: true

require 'test_helper'

class CreditsControllerTest < ActionDispatch::IntegrationTest
  setup do
    post users_url params: { user: { email: 'user1@email.jp', password: 'password' } }, as: :json
    res = JSON.parse(response.body)
    @token_user1 = res['access_token']
    @user1_id = res['user_id']

    post users_url params: { user: { email: 'user2@email.jp', password: 'password' } }, as: :json
    res = JSON.parse(response.body)
    @token_user2 = res['access_token']
    @user2_id = res['user_id']
    @credit = credits(:one)
  end

  # リストの全取得（成功）
  test 'CRED-S001' do
    get credits_url, headers: { Authorization: @token_user1 }, as: :json
    assert_response :success
  end

  # リストの追加（成功）
  test 'CRED-S002' do
    assert_difference('Credit.count') do
      post credits_url,
           params: { credit: { amount: 200, content: 'test', created_user_id: @user1_id, credit: false } }, headers: { Authorization: @token_user1 }, as: :json
    end

    assert_response 201
  end

  # リストInfo機能（成功）
  test 'CRED-S003' do
    # user1 で下記の通りのレコードを作成
    # 貸している額 総額 ¥8,000 (4件)
    # 借りている額 総額 ¥2,000 (3件)
    post credits_url,
         params: { credit: { amount: 1000, completed: @credit.completed, content: 'user1 -> user2 (1) created by user1 ', created_user_id: @user1_id, credit: false } }, headers: { Authorization: @token_user1 }, as: :json
    post credits_url,
         params: { credit: { amount: 2000, completed: @credit.completed, content: 'user1 -> user2 (2) created by user1 ', created_user_id: @user1_id, credit: false } }, headers: { Authorization: @token_user1 }, as: :json
    post credits_url,
         params: { credit: { amount: 1500, completed: @credit.completed, content: 'user1 -> user2 (3) created by user1 ', created_user_id: @user1_id, credit: false } }, headers: { Authorization: @token_user1 }, as: :json
    post credits_url,
         params: { credit: { amount: 3500, completed: @credit.completed, content: 'user1 -> user2 (4) created by user1 ', created_user_id: @user1_id, credit: false } }, headers: { Authorization: @token_user1 }, as: :json
    post credits_url,
         params: { credit: { amount: 1000, completed: @credit.completed, content: 'user2 -> user1 (1) created by user1 ', created_user_id: @user1_id, credit:  true } }, headers: { Authorization: @token_user1 }, as: :json
    post credits_url,
         params: { credit: { amount:  550, completed: @credit.completed, content: 'user2 -> user1 (1) created by user1 ', created_user_id: @user1_id, credit:  true } }, headers: { Authorization: @token_user1 }, as: :json
    post credits_url,
         params: { credit: { amount:  450, completed: @credit.completed, content: 'user2 -> user1 (1) created by user1 ', created_user_id: @user1_id, credit:  true } }, headers: { Authorization: @token_user1 }, as: :json

    # user2 で下記の通りのレコードを作成
    # 貸している額 総額 ¥5,000 (2件)
    # 借りている額 総額 ¥6,000 (4件)
    post credits_url,
         params: { credit: { amount: 1650, completed: false, content: 'user2 -> user1 (1) created by user2 ', created_user_id: @user2_id, credit: false } }, headers: { Authorization: @token_user2 }, as: :json
    post credits_url,
         params: { credit: { amount: 3350, completed: false, content: 'user2 -> user1 (2) created by user2 ', created_user_id: @user2_id, credit: false } }, headers: { Authorization: @token_user2 }, as: :json
    post credits_url,
         params: { credit: { amount: 1500, completed: false, content: 'user1 -> user2 (1) created by user2 ', created_user_id: @user2_id, credit:  true } }, headers: { Authorization: @token_user2 }, as: :json
    post credits_url,
         params: { credit: { amount: 3000, completed: false, content: 'user1 -> user2 (2) created by user2 ', created_user_id: @user2_id, credit:  true } }, headers: { Authorization: @token_user2 }, as: :json
    post credits_url,
         params: { credit: { amount: 1000, completed: false, content: 'user1 -> user2 (3) created by user2 ', created_user_id: @user2_id, credit:  true } }, headers: { Authorization: @token_user2 }, as: :json
    post credits_url,
         params: { credit: { amount: 500, completed: false, content: 'user1 -> user2 (4) created by user2 ', created_user_id: @user2_id, credit: true } }, headers: { Authorization: @token_user2 }, as: :json

    # user1 側のinfo情報が下記となることを確認
    # 貸している額 総額 ¥14,000 (8件)
    # 借りている額 総額 ¥7,000 (5件)
    get credits_info_url(user_id: @user1_id),
        headers: { Authorization: @token_user1 },
        as: :json
    res = JSON.parse(response.body)
    assert_response :success
    assert_equal 14_000, res['bond_total']
    assert_equal 8, res['bond_count']
    assert_equal 7000, res['credit_total']
    assert_equal 5, res['credit_count']

    # user1 側のinfo情報が下記となることを確認
    # 貸している額 総額 ¥7,000 (5件)
    # 借りている額 総額 ¥14,000 (8件)
    get credits_info_url(user_id: @user2_id),
        headers: { Authorization: @token_user2 },
        as: :json
    res = JSON.parse(response.body)
    assert_response :success
    assert_equal 7000, res['bond_total']
    assert_equal 5, res['bond_count']
    assert_equal 14_000, res['credit_total']
    assert_equal 8, res['credit_count']
  end

  # リストの削除（成功）
  test 'CRED-S004' do
    assert_difference('Credit.count', -1) do
      delete credit_url(@credit), headers: { Authorization: @token_user1 }, as: :json
    end

    assert_response 204
  end

  # リストの更新（成功）
  test 'CRED-S005' do
    patch credit_url(@credit),
          params: { credit: { amount: @credit.amount, completed: @credit.completed, content: @credit.content, created_user_id: @user1_id, credit: @credit.credit } }, headers: { Authorization: @token_user1 }, as: :json
    assert_response 200
  end

  # リストの全取得失敗パターン（ログイン認証なし）
  test 'CRED-E001' do
    get credits_url, as: :json
    assert_response 401
  end

  # リストの追加失敗パターン
  test 'CRED-E002' do
    # ログイン認証なし
    post credits_url, params: { credit: { amount: 200, content: 'test', created_user_id: 1, credit: false } },
                      as: :json
    assert_response 401

    # 必要パラメータなし
    post credits_url, params: { credit: { content: 'test', created_user_id: 1, credit: false } },
                      headers: { Authorization: @token_user1 }, as: :json
    assert_response 422
  end

  # リストInfo機能失敗パターン（ログイン認証なし）
  test 'CRED-E003' do
    get credits_info_url(user_id: 1), as: :json
    assert_response 401
  end

  # リストの削除失敗パターン
  test 'CRED-E004' do
    delete credit_url(@credit), as: :json
    assert_response 401
  end

  # リストの更新失敗パターン
  test 'CRED-E005' do
    patch credit_url(@credit),
          params: { credit: { amount: @credit.amount, completed: @credit.completed, content: @credit.content, created_user_id: 1, credit: @credit.credit } }, as: :json
    assert_response 401
  end
end
