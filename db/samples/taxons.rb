require "resource_creator"

["parts", "themes"].each do |taxonomy_name|
  df = Daru::DataFrame.from_csv(File.join(__dir__, "initial-#{taxonomy_name}-taxons.csv"))
  resource_creator = ResourceCreator.new
  resource_creator.create_nested_taxons(df, taxonomy_name)
end

category_taxonomy = Spree::Taxonomy.where(name: I18n.t("spree.taxonomies.category")).first_or_create!
category_parent_taxon = Spree::Taxon.where(name: I18n.t("spree.taxonomies.category")).first_or_create!
["Bestsellers", "Sale"].each do |taxon_name|
  taxon =  category_parent_taxon.children.where(name: taxon_name, position: 0).first_or_create!
  taxon.permalink = taxon.permalink.gsub("categories/", "")
  taxon.taxonomy = category_taxonomy
  taxon.save!
end
