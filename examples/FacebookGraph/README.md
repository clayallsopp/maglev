# Facebook Graph Example

Facebook auth code adapted from [facebook-auth-ruby-motion-example](https://github.com/aaronfeng/facebook-auth-ruby-motion-example)

## Running

```
bundle install
rake
```

You need to specify an FB app ID, which you can create [in FB's Developer app](https://www.facebook.com/developers):

###### app_delegate.rb

```ruby
def application(application, didFinishLaunchingWithOptions:launchOptions)
  ...
  @facebook = Facebook.alloc.initWithAppId("YOUR-APP-ID", andDelegate:self)
  ...
end
```

###### Rakefile

```ruby
Motion::Project::App.setup do |app|
  ...
  fb_app_id = "YOUR-APP-ID"
  app.info_plist['CFBundleURLTypes'] = [{'CFBundleURLSchemes' => ["fb#{fb_app_id}"]}]
  ...
end
```