class MoviesController < UITableViewController

  def viewDidLoad
    super
    self.title = "My Movies"
    
    @activity = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleGray)
    self.view.addSubview @activity
    @activity.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)
    @activity.startAnimating

    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Logout", style: UIBarButtonItemStyleBordered, target:self, action:'logout')

    self.navigationItem.rightBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Friends", style: UIBarButtonItemStyleBordered, target:self, action:'friends')


    @movies = []

    User.new(id: "me").movies.remote_find_all do |movies|
      @movies = movies
      @activity.stopAnimating
      @activity.removeFromSuperview
      self.tableView.reloadData
    end
  end

  def logout
    App.delegate.facebook.logout
    App.delegate.open_login
  end

  def friends
    self.navigationController.pushViewController(FriendsController.alloc.initWithNibName(nil, bundle:nil), animated: true)
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @movies.count
  end

  def layout_movie_in_cell(movie, cell)
    cell.textLabel.text = movie.name
    cell.detailTextLabel.text = movie.id
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    reuseIdentifier = "MovieCell"

    cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:reuseIdentifier)
      cell
    end

    cell.accessoryType = UITableViewCellAccessoryNone

    movie = @movies[indexPath.row]
    layout_movie_in_cell(movie, cell)

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:true)

    movie = @movies[indexPath.row]
    controller = MovieController.alloc.initWithId(movie.id)
    self.navigationController.pushViewController(controller, animated: true)
  end
end