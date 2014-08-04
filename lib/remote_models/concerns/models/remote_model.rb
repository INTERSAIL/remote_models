module Intersail
  module RemoteModels
    module RemoteModel
      extend ActiveSupport::Concern

      included do
        include ActiveModel::Model
        include ActiveModel::Serializers::JSON

        mattr_accessor :rattrs do
          []
        end
      end

      module ClassMethods
        def remote_attributes(*attr_accessor_args)
          (self.rattrs << attr_accessor_args).flatten!
          attr_accessor *attr_accessor_args
        end

        def remote_fields_param()
          self.rattrs.join(',')
        end

        # Model.all: ritorna tutti gli elementi di questo model
        def all
          # creo una RemoteRelation temporanea, di cui chiamo il metodo "all"
          relation = Intersail::RemoteModels::RemoteModel::RemoteRelation.instantiate(name: self.name.to_s.underscore, klass: self.name)
          relation.all
        end

        # Model.first: ritorna il primo elemento di questo model
        def first
          # chiamo il metodo "return_first" impostando "limit = 1"
          return_first { |options| options[:limit] = 1 }
        end

        # Model.last: ritorna l'ultimo elemento di questo model
        def last
          # chiamo il metodo "return_first" impostando "limit = -1"
          return_first { |options| options[:limit] = -1 }
        end

        # Model.find: ritorna l'elemento il cui "id" è uguale al parametro passato
        def find(id)
          # chiamo il metodo "return_first" mettendo l'id passato come uno degli id da cercare
          return_first do |options|
            options[:ids] = []
            options[:ids] << id
          end
        end

        # Model.where: ritorna una RemoteRelation inizializzata con la condizione passata
        def where(condition)
          Intersail::RemoteModels::RemoteModel::RemoteRelation.instantiate(name: self.name.to_s.underscore, klass: self.name, where: condition)
        end

        # Model.order: ritorna una RemoteRelation inizializzata con l'ordinamento passato
        def order(order_list)
          Intersail::RemoteModels::RemoteModel::RemoteRelation.instantiate(name: self.name.to_s.underscore, klass: self.name, order: order_list)
        end

        # Model.limit: ritorna una RemoteRelation inizializzata con il limit passato
        def limit(items_limit)
          Intersail::RemoteModels::RemoteModel::RemoteRelation.instantiate(name: self.name.to_s.underscore, klass: self.name, limit: items_limit)
        end

        private

        def return_first(&block)
          # inizializzo la variabile "options" con name e klass (e default limit = 1), e chiamo l'eventuale blocco passato
          options ||= {name: self.name.to_s.underscore, klass: self.name, limit: 1}
          block.call(options) if block_given?
          # creo una RemoteRelation con le opzioni, e poi chiamo la "all" della relazione
          relation = Intersail::RemoteModels::RemoteModel::RemoteRelation.instantiate(options)
          items = relation.all
          if (items && items.count > 0)
            items[0]
          else
            nil
          end
        end
      end

      def attributes=(hash)
        hash.each do |key, value|
          send("#{key}=", value)
        end
      end

      def attributes
        instance_values
      end

      def write_attribute(attr_name, value)
        instance_variable_set "@#{attr_name}", value
      end
    end
  end
end
