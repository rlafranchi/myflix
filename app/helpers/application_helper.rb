module ApplicationHelper
  def average_rating(objs)
    sum = 0.0
    objs.all.each do |obj|
      sum += obj.rating.to_i
    end
    if objs.count != 0
      (sum.to_f / objs.all.count.to_f).round(1)
    else
      " - "
    end
  end
end
