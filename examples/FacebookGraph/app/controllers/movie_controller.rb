class MovieController < UIViewController
  attr_accessor :movie

  def initWithId(id)
    initWithNibName(nil, bundle:nil)
    @load_id = id
    self
  end

  def viewDidLoad
    super

    self.title = "Loading"
    self.view.backgroundColor = UIColor.whiteColor

    @activity = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleGray)
    self.view.addSubview @activity
    @activity.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)
    @activity.startAnimating

    @cover = UIImageView.alloc.initWithFrame CGRect.new([0, 0], [self.view.frame.size.width, 170])
    @cover.backgroundColor = UIColor.blueColor.colorWithAlphaComponent(0.2)
    self.view.addSubview(@cover)

    @profile = UIImageView.alloc.initWithFrame CGRect.new([20, 50], [70, 70])
    @profile.backgroundColor = UIColor.grayColor.colorWithAlphaComponent(0.2)
    self.view.addSubview(@profile)

    Movie.find(@load_id) do |movie|
      @activity.stopAnimating
      @activity.removeFromSuperview
      self.title = movie.name
      @cover.setImageWithURL(NSURL.URLWithString(movie.cover_url))
      @cover.contentMode = UIViewContentModeScaleAspectFit | UIViewContentModeTop
      @cover.backgroundColor = UIColor.whiteColor

      @profile.setImageWithURL(NSURL.URLWithString("#{Maglev::API.complete_url(movie.member_path)}/picture"))
      @profile.contentMode = UIViewContentModeScaleAspectFill
      @profile.backgroundColor = UIColor.whiteColor
    end
  end
end