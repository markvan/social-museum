class TagsController < ApplicationController

  expose(:tag_from_param) { Tag.where(name: params[:id]).first }

  expose(:tagged_collection_items) { none ? [] : tag_from_param.collection_items }
  expose(:tagged_pages)            { none ? [] : tag_from_param.pages }
  expose(:tagged_resources)        { none ? [] : tag_from_param.resources }

  expose(:paginated_collection_items) { Kaminari.paginate_array(tagged_collection_items).page(params[:page]).per(10) }
  expose(:paginated_pages) { Kaminari.paginate_array(tagged_pages).page(params[:page]).per(10) }
  expose(:paginated_resources) { Kaminari.paginate_array(tagged_resources).page(params[:page]).per(10) }

  expose(:ci_count) { none ? 0 : tagged_collection_items.count }
  expose(:p_count)  { none ? 0 : tagged_pages.count }
  expose(:r_count)  { none ? 0 : tagged_resources.count }

  expose(:none)     { ci_count + p_count + r_count == 0 }

  expose(:ci_tab_active) { ci_count > 0 ? 'active' : '' }
  expose(:p_tab_active)  { ci_count == 0 && p_count > 0 ? 'active' : '' }
  expose(:r_tab_active)  { ci_count == 0 && p_count == 0 && r_count > 0 ? 'active' : '' }

end