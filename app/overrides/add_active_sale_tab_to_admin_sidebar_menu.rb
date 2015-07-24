Deface::Override.new(
            :virtual_path => "spree/layouts/admin",
            :name => "add_active_sale_tab_to_admin_sidebar_menu",
            :insert_bottom => "#main-sidebar",
            :partial => 'spree/admin/shared/active_sales_sidebar_menu',
            :original => '157d0ef6cfb4569a9d4d07712fcfc5bc995511c3'
)