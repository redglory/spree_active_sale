Deface::Override.new(
            :virtual_path => "spree/admin/shared/sub_menu/_configuration",
            :name => "add_active_sale_to_admin_configuration_sidebar",
            :insert_bottom => "[data-hook='admin_configurations_sidebar_menu']",
            :text => %q{
              <%= configurations_sidebar_menu_item(Spree.t(:active_sales), admin_active_sales_path) %>
              }
)