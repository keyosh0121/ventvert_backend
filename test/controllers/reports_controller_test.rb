require 'test_helper'

class ReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    post users_url params: { user: { email: "user1@email.jp", password: "password" } }, as: :json
    res = JSON.parse(response.body)
    @token = res['access_token']
    request.headers['Authorization'] = @token
    @report = reports(:one)
  end


  test "should get index" do
    
  end

  test "should create report" do
    
  end

  test "should show report" do
    get report_url(@report), headers: {Authorization: @token},as: :json
    assert_response :success
  end

  #レポートの全取得
  test "REPO-S001" do
    get reports_url, headers: {Authorization: @token},as: :json
    assert_response :success
  end

  #レポートの追加
  test "REPO-S002" do
    assert_difference('Report.count') do
      post reports_url, params: { report: { category: @report.category, content: @report.content, title: @report.title, user_id: @report.user_id } }, headers: {Authorization: @token},as: :json
    end

    assert_response 201
  end

  #レポートの削除
  test "REPO-S003" do
    assert_difference('Report.count', -1) do
      delete report_url(@report), headers: {Authorization: @token},as: :json
    end

    assert_response 204
  end

  #レポートの更新
  test "REPO-S004" do
    patch report_url(@report), params: { report: { category: @report.category, content: @report.content, title: @report.title, user_id: @report.user_id } }, headers: {Authorization: @token},as: :json
    assert_response 200
  end

  #レポートの全取得（ログイン認証なし）
  test "REPO-E001" do
    get reports_url ,as: :json
    assert_response 401
  end

  #レポートの追加（ログイン認証なし）
  test "REPO-E002" do
    post reports_url, params: { report: { category: @report.category, content: @report.content, title: @report.title, user_id: @report.user_id } },as: :json
    assert_response 401
  end

  #レポートの削除（ログイン認証なし）
  test "REPO-E003" do
    patch report_url(@report), params: { report: { category: @report.category, content: @report.content, title: @report.title, user_id: @report.user_id } },as: :json
    assert_response 401
  end

  #レポートの更新（ログイン認証なし）
  test "REPO-E004" do
    patch report_url(@report), params: { report: { category: @report.category, content: @report.content, title: @report.title, user_id: @report.user_id } }, as: :json
    assert_response 401
  end

end
