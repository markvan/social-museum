require 'spec_helper'

describe "LinkInterpreter output" do

  def check_outputs(link_interpreter, li_method, html_output)
    expect(link_interpreter.send(li_method)).to eq html_output
  end

  def check_li_outputs(str, li_method, html_output)
    link_interpreter=LinkInterpreter.new(str)
    expect(link_interpreter.send(li_method)).to eq html_output
  end

  def new_page(name)
    user = FactoryGirl.create(:user)
    title = FactoryGirl.create(:title, title: name, titleable_type: 'Page')
    page = FactoryGirl.create(:page, title:   title, user_id: user.id, description: 'any')
    title.titleable_id = page.id
    page
  end

  def new_resource(name)
    user = FactoryGirl.create(:user)
    title = FactoryGirl.create(:title, title: name, titleable_type: 'Resource')
    resource = FactoryGirl.create(:resource, title:   title, user_id: user.id, description: 'any', url: 'http://hedtek.com/image.png')
    title.titleable_id = resource.id
    resource
  end

  context "Trial for resources" do

    it "should output a hyperlink to an existing 'new name format' resource" do
      resource = new_resource('_A resource with an image')
      check_li_outputs(resource.name, :process_title, "<a href='/resources/_a-resource-with-an-image' data-resource>_A resource with an image</a>")
    end

    it "should output a hyperlink to create a missing 'new name format' resource" do
      check_li_outputs('_Not a resource yet', :process_title, "<a href='/resources/new?resource_title=_Not a resource yet' data-new-resource>_Not a resource yet</a>" )
    end

    it "should correctly output a hyperlink to create a * page * if not a 'new name format' uncreated resource" do
      check_li_outputs('A resource with a bad title', :process_title, "<a href='/pages/new?page_title=A resource with a bad title' data-new-page>A resource with a bad title</a>")
    end

  end

  context "Pages" do

    it "should output a hyperlink to an existing page" do
      page = new_page('An unusual  Name')
      check_li_outputs(page.name, :process_title, "<a href='/pages/an-unusual-name' data-page>An unusual  Name</a>" )
    end

    it "should output a hyperlink to create a missing page" do
      check_li_outputs('Not a page yet', :process_title, "<a href='/pages/new?page_title=Not a page yet' data-new-page>Not a page yet</a>" )
    end
  end

  context "Content" do
    context "Images" do
      it "should process an unsized image" do
        image_url = 'http://hedtek.com/some/page.png'
        li = LinkInterpreter.new(image_url)

        check_outputs(li, :process_image_url,
            "<img src='#{image_url}'/>" )
      end

      it "should process an image with a width in pixels" do
        image_url_and_width = 'http://hedtek.com/some/page.png 300'
        li = LinkInterpreter.new(image_url_and_width)

        check_outputs(li, :process_image_url,
            "<img src='http://hedtek.com/some/page.png' style='width: 300px;'/>" )
      end
    end

    context "youtube" do
      let(:video_slug) {"pNe6fsaCVtI"}
      let(:non_video_link) {"http://www.youtube.com"}
      let(:video_link) {"http://www.youtube.com/watch?v=#{video_slug}"}
      let(:video_link_with_playlist) {"http://www.youtube.com/watch?v=#{video_slug}&playlist=awesome_playlist"}
      let(:video_link_reverse_order) {"http://www.youtube.com/watch?playlist=awesome_playlist&v=#{video_slug}"}
      let(:width) {600}
      let(:height) { (width * (9.fdiv(16))).ceil }
      let(:video_link_with_width){"#{video_link} #{width}"}

      it "should process a video link" do
        li = LinkInterpreter.new(video_link)

        check_outputs(li, :process_youtube_url,
                      "<iframe src='//youtube.com/embed/#{video_slug}' width='400' height='225' frameborder='0' allowfullscreen sandbox='allow-scripts allow-same-origin'></iframe>")
      end

      it "should process a video with a width" do
        li = LinkInterpreter.new(video_link_with_width)

        check_outputs(li, :process_youtube_url,
                      "<iframe src='//youtube.com/embed/#{video_slug}' width='#{width}' height='#{height}' frameborder='0' allowfullscreen sandbox='allow-scripts allow-same-origin'></iframe>")
      end

      it "should process a video with a playlist" do
        li = LinkInterpreter.new(video_link_with_playlist)

        check_outputs(li, :process_youtube_url,
                      "<iframe src='//youtube.com/embed/#{video_slug}' width='400' height='225' frameborder='0' allowfullscreen sandbox='allow-scripts allow-same-origin'></iframe>")
      end

      it "should process a video with a reversed order query string" do
        li = LinkInterpreter.new(video_link_reverse_order)

        check_outputs(li, :process_youtube_url,
                      "<iframe src='//youtube.com/embed/#{video_slug}' width='400' height='225' frameborder='0' allowfullscreen sandbox='allow-scripts allow-same-origin'></iframe>")
      end

      it "should process a youtube link which is not a video" do
        li = LinkInterpreter.new(non_video_link)

        check_outputs(li, :process_youtube_url,
                      "<a href='#{non_video_link}' external-link>#{non_video_link}</a>")
      end
    end

    context "vimeo" do
      let(:video_slug) {"42109988"}
      let(:non_video_link) {"http://www.vimeo.com"}
      let(:video_link) {"http://www.vimeo.com/channels/staffpicks/#{video_slug}"}
      let(:video_link_with_query) {"http://www.vimeo.com/channels/staffpicks/#{video_slug}?playlist=awesome_playlist"}
      let(:width) {600}
      let(:height) { (width * (9.fdiv(16))).ceil }
      let(:video_link_with_width){"#{video_link} #{width}"}

      it "should process a video link" do
        li = LinkInterpreter.new(video_link)

        check_outputs(li, :process_vimeo_url,
                      "<iframe src='//player.vimeo.com/video/#{video_slug}' width='400' height='225' frameborder='0' allowfullscreen sandbox='allow-scripts allow-same-origin'></iframe>")
      end

      it "should process a video with a width" do
        li = LinkInterpreter.new(video_link_with_width)

        check_outputs(li, :process_vimeo_url,
                      "<iframe src='//player.vimeo.com/video/#{video_slug}' width='#{width}' height='#{height}' frameborder='0' allowfullscreen sandbox='allow-scripts allow-same-origin'></iframe>")
      end

      it "should process a video with a query" do
        li = LinkInterpreter.new(video_link_with_query)

        check_outputs(li, :process_vimeo_url,
                      "<iframe src='//player.vimeo.com/video/#{video_slug}' width='400' height='225' frameborder='0' allowfullscreen sandbox='allow-scripts allow-same-origin'></iframe>")
      end

      it "should process a vimeo link which is not a video" do
        li = LinkInterpreter.new(non_video_link)

        check_outputs(li, :process_vimeo_url,
                      "<a href='#{non_video_link}' external-link>#{non_video_link}</a>")
      end
    end
  end

  context "resources" do
    it "should process an existing resource title" do
      resource = new_resource('_My resource')
      li = LinkInterpreter.new(resource.name)
      check_outputs(li, :process_title, "<a href='/resources/_my-resource' data-resource>_My resource</a>")
    end

    it "should process a non-existing resource title" do
      li = LinkInterpreter.new('_A resource title')
      check_outputs(li, :process_title, "<a href='/resources/new?resource_title=_A resource title' data-new-resource>_A resource title</a>")
    end

    it "should process a url resource asset" do
      resource = new_resource('_My resource')
      resource.update(url: 'http:/hedtek.com/image.png')
      li = LinkInterpreter.new('_' + resource.name)
      check_outputs(li, :process_resource_asset, "<img src='http:/hedtek.com/image.png'/>")
    end

    it "should process a url (with width spec) resource asset" do
      resource = new_resource('_My resource')
      resource.update(url: 'http:/hedtek.com/image.png')
      li = LinkInterpreter.new('_' + resource.name + ' 300')
      check_outputs(li, :process_resource_asset, "<img src='http:/hedtek.com/image.png' style='width: 300px;'/>")
    end

    it "should process a file resource asset" do
      resource = new_resource('_My resource')
      resource.update(url: '/images/1/image.png')
      li = LinkInterpreter.new('_' + resource.name)
      check_outputs(li, :process_resource_asset, "<img src='/get_uploaded_file/images/1/image.png'/>")
    end

    it "should process a file (with width) resource asset" do
      resource = new_resource('_My resource')
      resource.update(url: '/images/1/image.png')
      resource.update(url: 'http:/hedtek.com/image.png')
      li = LinkInterpreter.new('_' + resource.name+ ' 300')
       check_outputs(li, :process_resource_asset, "<img src='http:/hedtek.com/image.png' style='width: 300px;'/>")
    end

  end
end