module Intersail
  module RemoteModels
    module RemoteModel
      class RemoteRelation

        extend ActiveSupport::Concern
        include Intersail::RemoteModels::RemoteCall

        attr_accessor :klass
        attr_accessor :name

        # inizializzo una RemoteRelation con le opzioni passate
        def self.instantiate(options)
          relation = RemoteRelation.new
          relation.klass = options[:klass]
          relation.name = options[:name]
          relation.where(options[:where]) if options[:where]
          relation.order(options[:order]) if options[:order]
          relation.limit(options[:limit]) if options[:limit]
          options[:ids].each { |id| relation.ids << id } if options[:ids]
          relation
        end

        # aggiunge una condizione in AND
        def where(condition)
          @where ||= []
          @where << condition
          self
        end

        # aggiunge un ulteriore ordinamento
        def order(order_list)
          @order ||= []
          @order << order_list
          self
        end

        # imposta il numero di elementi ritornati
        def limit(items_limit)
          @limit = items_limit
          self
        end

        # imposta il set di id da cercare
        def ids
          @ids ||= []
        end

        def all
          read_items
        end

        def each(&block)
          all.each do |item|
            block.call(item)
          end
        end

        def count
          count = 0
          each do |item|
            count += 1
          end
          count
        end

        private

        # crea una stringa concatenando le varie condizioni in AND
        def where_concat
          @where.join(' AND ') if @where
        end

        # crea una stringa concatenando gli ordinamento e dividendoli con una virgola
        def order_concat
          @order.join(',') if @order
        end

        # effettua la chiamata remota, o ritorna gli elementi già letti
        def read_items
          @results = build_call_to_site(name: name, klass: klass, where: where_concat, order: order_concat, limit: @limit, ids: @ids) unless @results
          @results
        end
      end
    end
  end
end