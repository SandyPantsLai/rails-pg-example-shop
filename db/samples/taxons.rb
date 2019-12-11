require "daru"

["parts", "themes"].each do |taxonomy_name|
  taxonomy = Spree::Taxonomy.where(name: I18n.t("spree.taxonomies.#{taxonomy_name}")).first_or_create!
  parent_taxon = Spree::Taxon.where(name: I18n.t("spree.taxonomies.#{taxonomy_name}")).first_or_create!

  df = Daru::DataFrame.from_csv(File.join(__dir__, "initial-#{taxonomy_name}-taxons.csv"))

  # Find all unique parent taxons and create them, all nested under the main parent taxon
  df.uniq("parent")["parent"].each do |parent|
    unless parent.nil?
      taxon = parent_taxon.children.where(name: parent, position: 0).first_or_create!
      taxon.permalink = taxon.permalink.gsub("taxonomy_name/", "")
      taxon.taxonomy = taxonomy
      taxon.save!
    end
  end

  # create children taxons to nest under each parent taxon
  df.each(:row) do |row|
    row["parent"].nil? ? parent_name = I18n.t("spree.taxonomies.#{taxonomy_name}") : parent_name = row["parent"] 
    puts parent_name
    parent = Spree::Taxon.where(name: parent_name).first
    
    taxon = parent.children.where(name: row["name"]).first_or_create!
    taxon.permalink = taxon.permalink.gsub("taxonomy_name/#{row['parent']}", "")
    taxon.taxonomy = taxonomy
    taxon.save!
  end
end

category_taxonomy = Spree::Taxonomy.where(name: I18n.t("spree.taxonomies.category")).first_or_create!
category_parent_taxon = Spree::Taxon.where(name: I18n.t("spree.taxonomies.category")).first_or_create!
["Bestsellers", "Sale"].each do |taxon_name|
  taxon =  category_parent_taxon.children.where(name: taxon_name, position: 0).first_or_create!
  taxon.permalink = taxon.permalink.gsub("categories/", "")
  taxon.taxonomy = category_taxonomy
  taxon.save!
end
