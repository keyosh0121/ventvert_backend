# frozen_string_literal: true

class CreditsController < ApplicationController
  before_action :set_credit, only: %i[show update destroy]

  # GET /credits/info
  def info
    @credits = Credit.all
    user_id = params[:user_id]
    credits = []
    bonds = []
    res = {
      credit_total: 0,
      credit_count: 0,
      bond_total: 0,
      bond_count: 0
    }

    # 借りている額
    credits += @credits.where(created_user_id: user_id).where(credit: true).where(completed: false)
    credits += @credits.where.not(created_user_id: user_id).where(credit: false).where(completed: false)

    # 貸している額
    bonds += @credits.where(created_user_id: user_id).where(credit: false).where(completed: false)
    bonds += @credits.where.not(created_user_id: user_id).where(credit: true).where(completed: false)

    res[:credit_total] = credits.sum(&:amount)
    res[:credit_count] = credits.count

    res[:bond_total] = bonds.sum(&:amount)
    res[:bond_count] = bonds.count

    render json: res
  end

  # GET /credits
  def index
    @credits = Credit.all.order(created_at: :desc)
    count = @credits.count
    if params[:page] && params[:count]
      start = (params[:page].to_i - 1) * params[:count].to_i
      @credits = @credits[start, params[:count].to_i]
    elsif params[:page]
      @credits = @credits[params[:page].to_i - 1, 10]
    elsif params[:count]
      @credits = @credits.limit(params[:count].to_i)
    end

    render json: { count: count, credits: @credits }
  end

  # GET /credits/1
  def show
    render json: @credit
  end

  # POST /credits
  def create
    @credit = Credit.new(credit_params)

    if @credit.save
      render json: @credit, status: :created, location: @credit
    else
      render json: @credit.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /credits/1
  def update
    if @credit.update(credit_params)
      render json: @credit
    else
      render json: @credit.errors, status: :unprocessable_entity
    end
  end

  # DELETE /credits/1
  def destroy
    @credit.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_credit
    @credit = Credit.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def credit_params
    params.require(:credit).permit(:amount, :content, :created_user_id, :credit, :completed)
  end
end
