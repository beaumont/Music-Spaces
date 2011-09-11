module Admin::BaseHelper

  # Handles case where no value provided for in_place_editor
  # There is an :external_control arg (http://mikeburnscoder.wordpress.com/2006/07/04/in-place-editing-blank-fields/),
  # but we don't want labels littering our table
  def set_in_place_edit_defaults(obj, fields, message = '[ none provided ]')
    fields.each do |f|
      obj[f] = message if obj.send(f).blank? || obj.send(f).strip.blank?
    end
  end
      
end
