module Spree
  TaxonsController.class_eval do

    def show
      @taxon = Taxon.friendly.find(params[:id])
      return unless @taxon

      if @taxon.live?
        @searcher = build_searcher(params.merge(taxon: @taxon.id, include_images: true))
        @products = @searcher.retrieve_products
        @taxonomies = Spree::Taxonomy.includes(root: :children)

        respond_with(@taxon)
      else
        redirect_to root_url, :error => t('spree.active_sale.event.flash.error')
      end
    end
  end
end