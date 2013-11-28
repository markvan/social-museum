require 'spec_helper'

def user
  @user || @user = FactoryGirl.create(:user)
end
def page
  @page || @page = FactoryGirl.create(:page, user: user)
end
def user2
  @user2 || @user2 = FactoryGirl.create(:user)
end
def page2
  @page2 || @page2 = FactoryGirl.create(:page, user: user2)
end

describe Page do
  before(:each) do
    user
    page
    user2
    page2
    subject { page }
  end

  it "creator should be set when page first created" do
    page.user.should == user
    page.creator.should == user
    page2.user.should == user2
    page2.creator.should == user2
  end

  it "editor should be set when page content is changed"  do
    page.change_content(user: user2, content: 'changed content')
    page.user.should == user2
    page.editor.should == user2
  end

  it "editor should be set when page title is changed" do
    page.change_title(user: user2, content: 'changed title')
    page.user.should == user2
    page.editor.should == user2
  end

  it "editor should be set when page title or content is changed" do
    page.change(user2, content: 'changed title')
    page.user.should == user
    page.editor.should == user
  end

  it "creator should not vary when successively changing title" do
    page.creator.should == user
    page.change_content(user: user2, content: 'changed content')
    page.creator.should == user
    page.change_content(user: user2, content: 'changed content')
    page.creator.should == user
  end

  it "creator should not vary when successively changing title"  do
    page.creator.should == user
    page.change_title(user: user2, content: 'changed title')
    page.creator.should == user
    page.change_title(user: user2, content: 'changed title')
    page.creator.should == user
  end
end
