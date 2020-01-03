properties = {
  min_age: "Mininum Age",
  collection: "Collection",
  condition: "Condition",
  num_of_pieces: "Number of Pieces",
  set_num: "Set Number",
  year: "Year Released"
}

properties.each do |name, presentation|
  Spree::Property.where(name: name, presentation: presentation).first_or_create!
end