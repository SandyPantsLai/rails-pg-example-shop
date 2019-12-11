taxonomies = [
  { name: I18n.t('spree.taxonomies.themes') },
  { name: I18n.t('spree.taxonomies.parts') },
  { name: I18n.t('spree.taxonomies.category') }

]

taxonomies.each do |taxonomy_attrs|
  Spree::Taxonomy.where(taxonomy_attrs).first_or_create!
end