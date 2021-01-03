# frozen_string_literal: true

class ShopListItemsController < ApplicationController
  before_action :set_shop_list_item, only: %i[show update destroy]

  # GET /shop_list_items
  def index
    @shop_list_items = ShopListItem.all
    @shop_list_items = @shop_list_items.limit(3) if params[:limit]
    render json: @shop_list_items
  end

  # GET /shop_list_items/1
  def show
    render json: @shop_list_item
  end

  # POST /shop_list_items
  def create
    @shop_list_item = ShopListItem.new(shop_list_item_params)

    if @shop_list_item.save
      render json: @shop_list_item, status: :created, location: @shop_list_item
    else
      render json: @shop_list_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /shop_list_items/1
  def update
    if @shop_list_item.update(shop_list_item_params)
      render json: @shop_list_item
    else
      render json: @shop_list_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shop_list_items/1
  def destroy
    @shop_list_item.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_shop_list_item
    @shop_list_item = ShopListItem.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def shop_list_item_params
    params.require(:shop_list_item).permit(:content, :user_id, :color, :icon)
  end
end
