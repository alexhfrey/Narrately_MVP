class CurrencyInput < SimpleForm::Inputs::Base
  def input
    "<span style = \"font-size:25px;\">$</span> #{@builder.text_field(attribute_name, input_html_options)}".html_safe
  end
end