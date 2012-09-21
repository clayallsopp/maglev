class AppDelegate
  attr_accessor :facebook
  attr_accessor :navigationController

  def set_access_token(token)
    Maglev::API.default_query = { access_token: token }
  end

  def application(application, didFinishLaunchingWithOptions:options)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @navigationController = UINavigationController.alloc.init
    @window.rootViewController = @navigationController
    @window.makeKeyAndVisible

    Maglev::API.setup do
      root "https://graph.facebook.com"
      extension ""
    end

    fb_app_id = "340990539314215"
    if fb_app_id == "YOUR-APP-ID"
      raise "You need to specify a Facebook App ID in ./app/app_delegate.rb"
    end
    @facebook = Facebook.alloc.initWithAppId(fb_app_id, andDelegate:self)

    if App::Persistence["FBAccessTokenKey"] && App::Persistence["FBExpirationDateKey"]
      @facebook.accessToken = App::Persistence["FBAccessTokenKey"]
      @facebook.expirationDate = App::Persistence["FBExpirationDateKey"]
    end

    if facebook.isSessionValid
      open_movies
    else
      open_login
    end

    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible

    true
  end

  def open_login
    @navigationController.setViewControllers([FacebookLoginController.alloc.init], animated: false)
  end

  def open_movies
    set_access_token App::Persistence["FBAccessTokenKey"]
    #movies_controller = Maglev::ListController.for(Movie, display_name: "name")
    movies_controller = MoviesController.alloc.initWithNibName(nil, bundle:nil)
    @navigationController.setViewControllers([movies_controller], animated: false)
  end

  def fbDidLogin
    App::Persistence["FBAccessTokenKey"] = @facebook.accessToken
    App::Persistence["FBExpirationDateKey"] = @facebook.expirationDate
    open_movies
  end


  def application(application,
                  openURL:url,
                  sourceApplication:sourceApplication,
                  annotation:annotation)
    @facebook.handleOpenURL(url)
  end
end
