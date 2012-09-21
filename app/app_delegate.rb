class CamelCaseModel < Maglev::Model
  has_one :another_camel_case_model
  has_many :bunch_of_camel_case_models
end

class AnotherCamelCaseModel < Maglev::Model
  remote_attributes :id

  belongs_to :camel_case_model
end

class BunchOfCamelCaseModel < Maglev::Model
  belongs_to :camel_case_model
end

class AppDelegate
  attr_reader :user
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    #@user = User.new(id: 5, name: "Clay", bio: "Herp")
    #@view_controller = Maglev::ModelController.for(self.user)

    #@view_controller = Maglev::ListController.for(Movie, display_key: :name)
    #@window.rootViewController = @view_controller
    @window.makeKeyAndVisible

    true
  end
end
