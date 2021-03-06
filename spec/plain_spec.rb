require File.expand_path('../spec_helper', __FILE__)

require 'sprockets'

describe RailsSassImages do
  before(:all) do
    @original = RailsSassImages.assets

    @assets = Sprockets::Environment.new
    @assets.append_path(DIR.join('app/app/assets/images'))
    @assets.append_path(DIR.join('app/app/assets/stylesheets'))
    @assets.css_compressor = :sass

    @assets.context_class.class_eval do
      def asset_path(path, options = {})
        "/assets/#{path}"
      end
    end

    RailsSassImages.install(@assets)
  end

  after(:all) do
    RailsSassImages.assets = @original
  end

  it "should inline assets" do
    @assets['inline.css'].to_s.should == ".icon{background:#{INLINE}}\n"
  end

  it "should raise error on unknown file" do
    proc {
      @assets['wrong-inline.css']
    }.should raise_error(/Can't find asset no\.png/)
  end

  it "should get image size" do
    @assets['size.css'].to_s.should == ".icon{width:4px;height:6px}\n"
  end

  it "should get image size by mixin" do
    @assets['image-size.css'].to_s.should == ".icon{width:4px;height:6px}\n"
  end

  it "should has hidpi-image mixin" do
    @assets['hidpi-image.css'].to_s == ".icon{width:2px;height:3px;" +
      "background:url(/assets/monolith.png) no-repeat;" +
      "background-size:2px 3px}\n"
  end

  it "should has hidpi-inline mixin" do
    @assets['hidpi-inline.css'].to_s.should == ".icon{width:2px;height:3px;" +
      "background:#{INLINE} no-repeat;" +
      "background-size:2px 3px}\n"
  end
end
