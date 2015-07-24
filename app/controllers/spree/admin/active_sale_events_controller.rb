module Spree
  module Admin
    class ActiveSaleEventsController < ResourceController
      belongs_to 'spree/active_sale', :find_by => :id
      before_filter :load_active_sale, :only => [:index]
      before_filter :parent_id_for_event, :only => [:new, :edit, :create, :update]
      update.before :get_eventable
      respond_to :json, :only => [:update_events]

      def show
        redirect_to( :action => :edit )
      end

      def destroy
        @active_sale_event = Spree::ActiveSaleEvent.find(params[:id])
        @active_sale_event.destroy
        respond_with(@active_sale_event) { |format| format.json { render :json => '' } }
      end

      def update_events
        @active_sale_event.update_attributes active_sale_event_params
        respond_with(@active_sale_event)
      end

      protected

        def collection
          return @collection if @collection.present?
          @search = Spree::ActiveSaleEvent.where(:active_sale_id => params[:active_sale_id]).ransack(params[:q])
          @collection = @search.result.page(params[:page]).per(Spree::ActiveSaleConfig[:admin_active_sale_events_per_page])
        end

        def load_active_sale
          @active_sale = Spree::ActiveSale.find(params[:active_sale_id])
        end

        def build_resource
          binding.pry
          get_eventable unless params[object_name].nil?
          if parent_data.present?
            parent.send(controller_name).build(params[object_name])
          else
            model_class.new(params[object_name])
          end
        end

        def get_eventable
          object_name = active_sale_event_params
          get_eventable_object(object_name)
        end

        def parent_id_for_event
          params[:parent_id] ||= check_active_sale_event_params
          @parent_id = params[:parent_id]
          binding.pry
          if @parent_id.blank?
            redirect_to edit_admin_active_sale_path(params[:active_sale_id]), :notice => Spree.t('active_sale.event.parent_id_cant_be_nil')
          end
        end

        def check_active_sale_event_params(event = active_sale_event_params)
          return nil if event.nil?
          parent_id = event[:parent_id]
          event.delete(:parent_id) if event[:parent_id].nil? || event[:parent_id] == "nil"
          parent_id
        end
      
      private
        def active_sale_event_params
          params.require(:active_sale_event).permit(:description, :end_date, :eventable_id, :eventable_type, 
                                                    :is_active, :is_hidden, :is_permanent, :name, :permalink, 
                                                    :active_sale_id, :start_date, :eventable_name, :discount, :parent_id)
        end
    end
  end
end
