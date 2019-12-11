require "daru"

["parts", "themes"].each do |taxonomy_name|
  taxonomy = Spree::Taxonomy.where(name: I18n.t("spree.taxonomies.#{taxonomy_name}")).first_or_create!
  parent_taxon = Spree::Taxon.where(name: I18n.t("spree.taxonomies.#{taxonomy_name}")).first_or_create!
  df = Daru::DataFrame.from_csv(File.join(__dir__, "#{taxonomy_name}-taxons.csv"))

  # Find all unique parent taxons and create them, all nested under the main parent taxon
  df.uniq("parent")["parent"].each do |parent|
    taxon = parent_taxon.children.where(name: parent).first_or_create!
    taxon.permalink = taxon.permalink.gsub("parts/", "")
    taxon.taxonomy = taxonomy
    taxon.save!
  end

  # create children taxons to nest under each parent taxon
  df.each(:row) do |row|
    parent = Spree::Taxon.where(name: row["parent"]).first
    taxon = parent.children.where(name: row["name"]).first_or_create!
    taxon.permalink = taxon.permalink.gsub("parts/#{row['parent']}", "")
    taxon.taxonomy = taxonomy
    taxon.save!
  end
end

category_taxonomy = Spree::Taxonomy.where(name: I18n.t("spree.taxonomies.category")).first_or_create!
category_parent_taxon = Spree::Taxon.where(name: I18n.t("spree.taxonomies.category")).first_or_create!
["Bestsellers", "Sale"].each do |taxon_name|
  taxon =  category_parent_taxon.children.where(name: taxon_name).first_or_create!
  taxon.permalink = taxon.permalink.gsub("categories/", "")
  taxon.taxonomy = category_taxonomy
  taxon.save!
end
