require 'test_helper'

class UserControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:two)
  end

  # ユーザ登録成功
  test "USER-SOO1" do
  	post users_url params: { user: { email: "email@email.jp", password: "password" } }, as: :json
  	res = JSON.parse(response.body)
  	token = res['access_token']
  	assert_response :success
  end

  #ユーザ登録後、ログイン成功
  test "USER-S002" do
  	post users_url params: { user: { email: "email@email.jp", password: "password" } }, as: :json
  	res = JSON.parse(response.body)
  	token = res['access_token']
  	assert_response :success

  	post login_url params: { email: "email@email.jp", password: "password" }, headers: { Authorization: token }, as: :json
  	login_res = JSON.parse(response.body)
  	assert_nil(login_res['error'])
  	assert_not_nil(login_res['email'])
  	assert_not_nil(login_res['user_id'])
  	assert_not_nil(login_res['access_token'])
  	assert_equal("email@email.jp", login_res['email'])

  end


  #ユーザ登録後、ログイン失敗
  test "USER-S003" do
  	#ユーザ登録処理
  	post users_url params: { user: { email: "email@email.jp", password: "password" } }, as: :json
  	res = JSON.parse(response.body)
  	token = res['access_token']
  	assert_response :success

  	#passwordが間違っている
  	post login_url params: { email: "email@email.jp", password: "pass" }, headers: { Authorization: token }, as: :json
  	login_res = JSON.parse(response.body)
  	assert_not_nil(login_res['error'])

  	#emailが存在しない
  	post login_url params: { email: "emailio@email.jp", password: "password" }, headers: { Authorization: token }, as: :json
  	login_res = JSON.parse(response.body)
  	assert_not_nil(login_res['error'])

  end


  #ユーザ登録失敗パターン① 必須パラメータなし
  test "USER-E001" do

  	# Emailが未入力
  	assert_raises(ActiveRecord::RecordInvalid) do
  		post users_url params: { user: { email: "", password: "password" } }, as: :JSON
  	end

  	# Passwordが未入力
  	assert_raises(ActiveRecord::RecordInvalid) do
  		post users_url params: { user: { email: "email@email.jp", password: "" } }, as: :JSON
  	end


  end


  #ユーザ登録失敗パターン① Email形式異常
  test "USER-E002" do

  	assert_raises(ActiveRecord::RecordInvalid) do
  		post users_url params: { user: { email: "200080", password: "password" } }, as: :json
  	end

  end





end
