class MoviesController < UITableViewController

  def viewDidLoad
    super
    self.title = "My Movies"
    
    @activity = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleGray)
    self.view.addSubview @activity
    @activity.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)
    @activity.startAnimating

    self.navigationItem.leftBarButtonItem = UIBarButtonItem.alloc.initWithTitle("Logout", style: UIBarButtonItemStyleBordered, target:self, action:'logout')

    @movies = []

    Movie.find_all do |movies|
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
end