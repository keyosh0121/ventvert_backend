# frozen_string_literal: true

require 'test_helper'

class ShopListItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shop_list_item = shop_list_items(:one)
    post users_url params: { user: { email: 'user1@email.jp', password: 'password' } }, as: :json
    res = JSON.parse(response.body)
    @token = res['access_token']
    request.headers['Authorization'] = @token
  end

  # 買い物リストの全取得
  test 'SHOP-S001' do
    get shop_list_items_url, headers: { Authorization: @token }, as: :json
    assert_response :success
  end

  # 買い物リストの追加
  test 'SHOP-S002' do
    assert_difference('ShopListItem.count') do
      post shop_list_items_url,
           params: { shop_list_item: { color: @shop_list_item.color, content: @shop_list_item.content, icon: @shop_list_item.icon, user_id: @shop_list_item.user_id } }, headers: { Authorization: @token }, as: :json
    end

    assert_response 201
  end

  test 'should show shop_list_item' do
    get shop_list_item_url(@shop_list_item), headers: { Authorization: @token }, as: :json
    assert_response :success
  end

  # 買い物リストの削除
  test 'SHOP-S003' do
    assert_difference('ShopListItem.count', -1) do
      delete shop_list_item_url(@shop_list_item), headers: { Authorization: @token }, as: :json
    end

    assert_response 204
  end

  # 買い物リストの更新
  test 'SHOP-S004' do
    patch shop_list_item_url(@shop_list_item),
          params: { shop_list_item: { color: @shop_list_item.color, content: @shop_list_item.content, icon: @shop_list_item.icon, user_id: @shop_list_item.user_id } }, headers: { Authorization: @token }, as: :json
    assert_response 200
  end

  # 買い物リストの全取得（ログイン認証なし）
  test 'SHOP-E001' do
    get shop_list_items_url, headers: { Authorization: '' }, as: :json
    assert_response 401
  end

  # 買い物リストの追加（ログイン認証なし）
  test 'SHOP-E002' do
    post shop_list_items_url,
         params: { shop_list_item: { color: @shop_list_item.color, content: @shop_list_item.content, icon: @shop_list_item.icon, user_id: @shop_list_item.user_id } }, as: :json
    assert_response 401
  end

  # 買い物リストの削除（ログイン認証なし）
  test 'SHOP-E003' do
    delete shop_list_item_url(@shop_list_item), as: :json
    assert_response 401
  end

  # 買い物リストの更新（ログイン認証なし）
  test 'SHOP-E004' do
    patch shop_list_item_url(@shop_list_item),
          params: { shop_list_item: { color: @shop_list_item.color, content: @shop_list_item.content, icon: @shop_list_item.icon, user_id: @shop_list_item.user_id } }, as: :json
    assert_response 401
  end
end
