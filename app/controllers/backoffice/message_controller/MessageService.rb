class Backoffice::MessageController::MessageService
  def self.send_message(from_name, from_email, to_name, to_email, message)
    @errors = []
    @message_sent = OpenStruct.new success: false, message: ""
    if message.blank?
      @errors.push(I18n.t "errors.messages.message.blank")
    end
    if !message.blank? && message.length < 2
      @errors.push(I18n.t "errors.messages.message.min_length", min_length: 2)
    end
    if from_email == to_email
      @errors.push(I18n.t "errors.messages.recipient.same_as_user")
    end
    if to_email.blank?
      @errors.push(I18n.t "errors.messages.recipient.blank")
    end
    if @errors.any?
      @message_sent.message = @errors.join("\n")
      return @message_sent
    end

    begin
      should_raise_error?

      AdminMailer.send_message_to(from_name, from_email, to_name, to_email, message).deliver_now
      @message_sent.success = true
      @message_sent.message = I18n.t "layout.mailing.text.success_to_send"
    rescue Exception => e
      puts "Error to send message: #{e}"
      @message_sent.message = I18n.t "layout.mailing.text.error_to_send"
    ensure
      return @message_sent
    end
  end

  private

  def self.should_raise_error?
    raise_error = [1..10].sample % 2 == 0
    puts "Should raise an error? #{raise_error ? "yes" : "no"}"
    if raise_error
      raise "Email could not be sent, check the logs for more details!"
    end
  end
end
