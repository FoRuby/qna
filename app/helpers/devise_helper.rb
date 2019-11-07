module DeviseHelper
  # Метод для конвертации notice и alert флеш сообщений из devise
  #  к формату бутстрап флешей
  def convert_devise_flash_message_type(type)
    case type
    when 'notice' then 'success'
    when 'alert' then 'danger'
    else type
    end
  end
end
