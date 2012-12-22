class FriendsController < UITableViewController
  def viewDidLoad
    super

    self.title = "Friends"

    @activity = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleGray)
    self.view.addSubview @activity
    @activity.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)
    @activity.startAnimating

    @friends = []

    User.new(id: "me").friends.remote_find_all do |friends|
      @friends = friends
      @activity.stopAnimating
      @activity.removeFromSuperview
      self.tableView.reloadData
    end
  end

  def tableView(tableView, numberOfRowsInSection:section)
    @friends.count
  end

  def layout_in_cell(friend, cell)
    cell.textLabel.text = friend.name
    cell.detailTextLabel.text = friend.id
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    reuseIdentifier = "FriendCell"

    cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:reuseIdentifier)
      cell
    end

    cell.accessoryType = UITableViewCellAccessoryNone

    friend = @friends[indexPath.row]
    layout_in_cell(friend, cell)

    cell
  end
end