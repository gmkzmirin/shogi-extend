module BuefyTableMethods
  extend ActiveSupport::Concern

  included do
    let :current_query do
      params[:query].presence
    end

    let :current_queries do
      if current_query
        current_query.scan(/\P{Space}+/)
      end
    end

    let :current_records do
      s = current_scope
      s = s.select(current_model.column_names - exclude_column_names)
      if current_sort_column && current_sort_order
        s = s.order(current_sort_column => current_sort_order)
      end
      s = s.order(id: :desc)
      s.page(params[:page]).per(current_per)
    end

    let :exclude_column_names do
      ["meta_info"]
    end

    let :current_per do
      (params[:per].presence || (Rails.env.production? ? 25 : 25)).to_i
    end

    let :current_sort_column do
      params[:sort_column].presence || default_sort_column
    end

    let :default_sort_column do
      "created_at"
    end

    let :current_sort_order do
      params[:sort_order].presence || "desc"
    end

    let :current_placeholder do
      ""
    end

    let :pure_current_scope do
      current_model.all
    end

    let :current_scope do
      s = pure_current_scope
      if r = current_ransack
        s = s.merge(r.result)
      end
      s
    end

    let :current_ransack do
      if current_queries
        current_model.ransack(title_or_description_cont_all: current_queries)
      end
    end

    let :js_index_options do
      {
        query: current_query || "",
        xhr_index_path: polymorphic_path([ns_prefix, current_plural_key]),
        total: current_records.total_count,
        page: current_records.current_page,
        per: current_per,
        sort_column: current_sort_column,
        sort_order: current_sort_order,
        sort_order_default: "desc", # カラムをクリックしたときの最初の向き
        # records: js_current_records,
        records: [],
        table_columns_hash: js_table_columns_hash,
      }
    end

    let :js_table_columns_hash do
      table_columns_hash.inject({}) do |a, e|
        visible = e[:visible]
        if visible_columns
          visible = visible_columns.include?(e[:key].to_s)
        end
        visible ||= !Rails.env.production?
        a.merge(e[:key] => e.merge(visible: visible))
      end
    end

    let :visible_columns do
      if v = params[:visible_columns]
        v.scan(/\w+/).to_set
      end
    end

    let :js_show_options do
      {
        xhr_put_path: url_for([ns_prefix, current_record, format: "json"]),
        kifu_canvas_image_attached: current_record.thumbnail_image.attached?,
        tweet_image_url: current_record.tweet_image_url,
      }
    end
  end

  def show
    if request.xhr? && request.format.json?
      render json: { sp_sfen: current_record.sfen }
      return
    end

    super
  end
end
