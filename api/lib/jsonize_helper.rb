class JsonizeHelper
  DEFAULT = {
    :status => 200, 
    :status_text => "OK", 
    :date => Time.now, 
    :content => [], 
    :failed => false, 
    :error => "",
    :notice => "",
    :info => "",
    :errors => []}

  # TODO : need to find solution for issue on "only" options
  # @param [ Hash ] options The options to pass.
  #
  # @option options [ Symbol ] :include What relations to include.
  # @option options [ Symbol ] :only Limit the fields to only these.
  # @option options [ Symbol ] :except Dont include these fields.
  # @option options [ Symbol ] :methods What methods to include.
  def self.format(param = {}, options = {})
    if param.is_a? Hash
      DEFAULT.merge( param ).to_json(options)
    else
      DEFAULT.to_json(options)
    end
  end
end
