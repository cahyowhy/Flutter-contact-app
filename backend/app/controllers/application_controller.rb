class ApplicationController < ActionController::API
  def generate_response(results, serializer, status, serializer_param = {})
    if results.as_json.kind_of?(Array)
      {data: ActiveModel::SerializableResource.new(results, each_serializer: serializer).as_json, status: status}
    else
      {data: serializer.new(results, serializer_param).as_json, status: status}
    end
  end

  def get_status_code(key)
    if key == :updated
      209
    elsif key == :deleted
      210
    else
      Rack::Utils::SYMBOL_TO_STATUS_CODE[key]
    end
  end

  def generate_response_custom(results, status)
    {data: results, status: status}
  end
end
