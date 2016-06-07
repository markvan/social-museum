class SubscriptionsController < ApplicationController

  #todo more method calls like this in controllers before_action :authenticate_user!
  before_action :authenticate_user!

  expose(:user){ current_user }
  expose(:page){ Page.find(params[:id]) }
  expose((:page_subscriptions)) { Page.select { |p| p.subscribers.include?(user) }.sort { |a, b| a.name <=> b.name } }
  expose(:collection_item){ CollectionItem.find(params[:id]) }
  expose (:collection_item_subscriptions) do
    CollectionItem.select { |ci| ci.subscribers.include?(user) }.sort { |a, b| a.name <=> b.name }
  end
  expose(:resource_subscriptions){Resource.where(id: '_extremely **89; unlikely')}

  def index
  end

  def delete_subscription_on_page
    page.unsubscribe(user)
    redirect_to subscriptions_path
  end

  def delete_subscription_on_collection_item
    collection_item.unsubscribe(user)
    redirect_to subscriptions_path
  end

  def delete_all_page_subscriptions
    Page.select{|p| p.subscribers.include?(user)}.each{|p|p.unsubscribe(user)}
    redirect_to subscriptions_path
  end

  def delete_all_collection_item_subscriptions
    CollectionItem.select{|ci| ci.subscribers.include?(user)}.each{|ci|ci.unsubscribe(user)}
    redirect_to subscriptions_path
  end

  def delete_all_subscriptions
    delete_all_page_subscriptions && delete_all_collection_item_subscriptions
  end
end