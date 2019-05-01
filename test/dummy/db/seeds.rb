category_ids = [2,3,5,7]

category_ids.each do |n|
  Category.create(id: n, title: "Category #{n}")
end


(0..100).each do |n|
  Doohickey.create(title: "Doohickey #{n+1}",
    weight: (n % 10) / 2,
    amount: (n % 10),
    available: (n % 2) == 1,
    description: "A general purpose doohickey",
    category_ids: category_ids.select{|c| n % c == 0})
end

places = [:first, :second, :third]
places.each do |a|
  places.each do |b|
    Comment.create(message: "This is the #{b.to_s.titleize} Comment on the #{a.to_s.titleize} Doohickey", doohickey: Doohickey.send(a))
  end
end
