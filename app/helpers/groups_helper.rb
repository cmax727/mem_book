module GroupsHelper
  def popular_groups(groups)    
    arr = []    
    groups.each do |group|          
      arr << {:id => group.id, :popular_size => group.users.size}
    end
    sorted_arr = arr.sort_by{|e| -e[:popular_size]}
    popular_groups = []
    sorted_arr.each do |element|
      popular_groups << Group.find(element[:id])
    end
    popular_groups
  end
  
  
  def comments_count(group)
    counts = 0
    group.discussions.each do |d|
      counts = counts + d.comments.size
    end
    counts
  end
end