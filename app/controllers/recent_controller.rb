class RecentController < ApplicationController
  expose (:recently_created_pages){Page.order('created_at DESC').limit(40)}
  expose (:recently_edited_pages){Page.order('updated_at DESC').limit(40)}
  expose (:recently_created_comments){Comment.order('created_at DESC').limit(40)}

  def index
  end
end