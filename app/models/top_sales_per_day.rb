# frozen_string_literal: true

class TopSalesPerDay < ContalinkRecord
  class << self
    def all(limit: nil, start_date: nil, end_date: nil)
      result = connection.exec_query(base_query(limit:, start_date:, end_date:))
      result.to_a
    end

    private

    def base_query(limit: nil, start_date: nil, end_date: nil)
      <<-SQL
        SELECT
          invoice_date::date AS sale_date,
          SUM(total) AS total,
          COUNT(*) AS invoices_count
        FROM invoices
        WHERE #{where_clause(start_date:, end_date:)}
        GROUP BY invoice_date::date
        ORDER BY total DESC
        #{limit_clause(limit)};
      SQL
    end

    def where_clause(start_date: nil, end_date: nil)
      end_date ||= Date.yesterday
      conditions = ['active = TRUE', "status IN ('Vigente', 'Pagado')"]
      conditions << "invoice_date >= '#{start_date}'" if start_date
      conditions << "invoice_date <= '#{end_date}'" if end_date
      conditions.join(' AND ')
    end

    def limit_clause(limit)
      limit ? "LIMIT #{limit}" : ''
    end
  end
end
