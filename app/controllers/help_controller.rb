class HelpController < ApplicationController
  include PagesHelper

  expose(:page){ Page.find_by_title('Help') }

end