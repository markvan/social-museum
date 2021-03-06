require 'spec_helper'

describe Resource do
  let(:title){ FactoryGirl.create(:title) }
  let(:resource){ FactoryGirl.create(:resource, title: title )}

  # ----------------------------------------------------

  describe "Validations" do
    it { expect(resource).to validate_presence_of(:title)   }

    it "should pass validation if the resource is a valid URL" do
      resource.update(url: 'http://hedtek.com')
      expect(resource).to be_valid

      resource.update(url: 'htttttp://hedtek.com')
      expect(resource).to_not be_valid
    end

    it "should pass validation if the resource is a file" do
      skip "Add test once implementation details become clearer."
    end

    it "should pass validation if at least one valid resource is present" do
      skip "Add test once implementation details become clearer."
    end
  end

  describe "Versioning" do
    it "creation works and has starting version" do
      expect(resource.versions.count).to eq 1
    end

    it "should have successive versions" do
      resource.update(title: 'New Title')

      expect(resource.versions.count).to eq 2

      expect(resource.versions.first.object_changes['title']).to eq [nil, 'Title 1']
      expect(resource.versions.last. object_changes['title']).to eq ['Title 1', 'New Title']

      expect(resource.versions[1].object_changes['title']).to eq [nil, 'Title 1']
      expect(resource.versions[0].object_changes['title']).to eq ['Title 1', 'New Title']
    end
  end

end