module Admin

  class MoneyReportQuery
    attr_accessor :start_date, :end_date, :sender_name, :receiver_name,
      :payment_type, :currency, :errors
    DATE_FIELD = 'created_at'

    def initialize(params)
      return if !params
      @start_date = Date.parse(params[:start_date]) if !params[:start_date].blank?
      @end_date = Date.parse(params[:end_date]) if !params[:end_date].blank?

      @start_date = @start_date.to_time if @start_date
      @end_date = @end_date.to_time + 1.day - 1.second if @end_date

      @sender_name = params[:sender_name] if !params[:sender_name].blank?
      @receiver_name = params[:receiver_name] if !params[:receiver_name].blank?
      @payment_type = params[:payment_type] if !params[:payment_type].blank?
      @currency = params[:currency] if !params[:currency].blank?
      @errors = []
    end

    def find_user(name)
      user = User.find_by_login(name)
      user = User.find(:first, :conditions => ['login like ?', '%s%' % name]) unless user
      if !user
        @errors << "User whose login starts with '{{user_login}}' not found" / name
      end
      return user
    end

    def add_sender_conditions(query_parts, values)
      if @sender_name
        return if guest_user(:sender_name, 'sender_id', query_parts, values)
        user = find_user(@sender_name)
        query_parts << "false" and return if !user
        as = AccountSetting.find_by_user_id(user.id)
        if as
          query_parts << "sender_account_setting_id = ?"
          values << as.id
        else
          query_parts << "false" #AccountSetting not found for given sender - there should be no results
        end
      end
    end

    def add_date_conditions(query_parts, values, date_value, op)
      if date_value
        query_parts << "%s %s ?" % [DATE_FIELD, op]
        values << date_value
      end
    end

    def add_receiver_conditions(query_parts, values)
      if @receiver_name
        return if guest_user(:receiver_name, 'receiver_id', query_parts, values)
        user = find_user(@receiver_name)
        query_parts << "false" and return if !user
        as = AccountSetting.find_by_user_id(user.id)
        if as
          query_parts << "receiver_account_setting_id = ?"
          values << as.id
        else
          query_parts << "false" #AccountSetting not found for given receiver - there should be no results
        end
      end
    end
    
    def add_payment_type_conditions(query_parts, values)
      if @payment_type
        return if empty_param(:payment_type, 'monetary_processor_id', query_parts, values)
        ps = MonetaryProcessor.find_by_short_name(@payment_type).workers
        query_parts << "monetary_processor_id in (?)"
        values << ps.map(&:id)
      end
    end
    
    def guest_user(filter_var, field, query_parts, values)
      if instance_variable_get("@#{filter_var}").downcase == 'guest'
        query_parts << "%1$s IS NULL OR %1$s = -1" % field
      end
    end

    def empty_param(filter_var, field, query_parts, values)
      if instance_variable_get("@#{filter_var}").to_s == '-1'
        instance_variable_set("@#{filter_var}", -1)
        query_parts << "%1$s IS NULL OR %1$s = -1" % field
      end
    end

    def add_currency_conditions(query_parts, values)
      #raise "admin/money_report_query: add_currency_conditions is broken right now"
    end

    def conditions
      query_parts = ['gross_amount_usd >= ?', 'monetary_transactions.type = ?']
      values = [0, 'MonetaryDonation']

      [[@start_date, '>='], [@end_date, '<=']].each do |date_value, op|
        add_date_conditions(query_parts, values, date_value, op)
      end

      add_sender_conditions(query_parts, values)
      add_receiver_conditions(query_parts, values)
      add_payment_type_conditions(query_parts, values)
      add_currency_conditions(query_parts, values)
      [query_parts.join(" AND ")] + values
    end
  end

end
